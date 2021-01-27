// Source: https://pyd.readthedocs.io/en/latest/extend.html

// A minimal "hello world" Pyd module.
module drlp;

import pyd.pyd;
//import rlp: lengthPrefix;

import std.bitmanip : nativeToBigEndian;
import std.conv : to;
import std.range : front, popFront;
import std.stdio : writefln;

extern(C) void PydMain() {
    def!(lengthPrefix)();
    module_init();
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
