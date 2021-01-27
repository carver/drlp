import drlp

length_prefix = drlp.lengthPrefix

for offset in [0x80, 0xc0]:
    for length in range(4294967296, 4294967296+1000000):
        length_prefix(length, offset)
