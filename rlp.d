import std.bitmanip : nativeToBigEndian;
import std.conv : to;
import std.range : front, popFront;
import std.stdio : writefln;

void main()
{
  foreach(ubyte offset; [0x80, 0xc0]){
    foreach(length; 0 .. 3){
    //foreach(length; 0 .. 100000){
    //foreach(length; 4294967296 - 2 .. 4294967296 + 2){
    //foreach(length; 4294967296 .. 4294967296 + 1000000){
      auto encoded = lengthPrefix(length, offset);
      // format string docs: https://dlang.org/phobos/std_format.html#formattedWrite
      // more inspiration: https://stackoverflow.com/q/42782598
      if (false && length < 4294967296 +100){
        writefln("encoded %s, %s to: 0x%(%02x%)", offset, length, encoded);
      }
    }
  }
}

const(ubyte[]) longToBigEndian(const ulong length) @safe
{
    auto bigEndian = nativeToBigEndian(length);

    //writefln("encoded bytes: %s", bigEndian);

    // trim off the leading 0 bytes
    foreach(idx, nextByte; bigEndian){
      if (nextByte != 0){
        auto trimmed = bigEndian[idx..$];
        return trimmed;
      }
    }
    assert(length == 0);
    return [0];
}

// See pyrlp:rlp/codec.py for reference
const(ubyte[]) lengthPrefix(const ulong length, const ubyte offset) @safe
{
    // LATER: assert that `offset in (0x80, 0xc0)`
    if (length < 56)
    {
        return [to!ubyte(length + offset)];
    }
    else
    {
        const encoded = longToBigEndian(length);
        const startChar = to!ubyte(offset + 56 - 1 + encoded.length);
        const result = [startChar] ~ encoded;
        return result;
    }
    // at the python boundary, if length >= 256**8, raise exception
}

@safe unittest {
  import std.format;

  // Hm, when does this actually run? It's supposed to be failing right now.
  void testPrefix(const ulong length, const ubyte offset, const string expected) @safe
  {
    const bytesPrefix = lengthPrefix(length, offset);
    const hexPrefix = format!"0x%(%02x%)"(bytesPrefix);
    if (hexPrefix != expected)
    {
      writefln(
          "Test failed! offset: %s, length: %s, expected: %s, actual: %s",
          offset,
          length,
          expected,
          hexPrefix,
      );
      assert(false);
    }
  }

  // 0x80 offset tests
  testPrefix(0, 0x80, "0x80");
  testPrefix(55, 0x80, "0xb7");
  testPrefix(56, 0x80, "0xb838");
  // max 32-bit unsigned int:
  testPrefix(4294967295, 0x80, "0xbbffffffff");
  testPrefix(4294967296, 0x80, "0xbc0100000000");
  // max 64-bit unsigned int:
  testPrefix(18446744073709551615, 0x80, "0xbfffffffffffffffff");

  // 0xc0 offset tests
  testPrefix(0, 0xc0, "0xc0");
  testPrefix(55, 0xc0, "0xf7");
  testPrefix(56, 0xc0, "0xf838");
  // max 32-bit unsigned int:
  testPrefix(4294967295, 0xc0, "0xfbffffffff");
  testPrefix(4294967296, 0xc0, "0xfc0100000000");
  // max 64-bit unsigned int:
  testPrefix(18446744073709551615, 0xc0, "0xffffffffffffffffff");
}
