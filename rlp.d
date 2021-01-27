import std.bitmanip : nativeToBigEndian;
import std.conv : to;
import std.range : front, popFront;
import std.stdio : writefln;

void main()
{
  foreach(ubyte offset; [0x80, 0xc0]){
    foreach(length; 0 .. 300){
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
    return ['\x00'];
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

unittest {
  // Hm, when does this actually run? It's supposed to be failing right now.
  assert(lengthPrefix(0, 0x80) == '\x81');
}
