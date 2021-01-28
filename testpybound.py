import drlp

length_prefix = drlp.lengthPrefix

test_cases =[
    # length, offset, hex-encoded

    (0, 0x80, "0x80"),
    (55, 0x80, "0xb7"),
    (56, 0x80, "0xb838"),
    # max 32-bit unsigned int:
    (4294967295, 0x80, "0xbbffffffff"),
    (4294967296, 0x80, "0xbc0100000000"),
    # max 64-bit unsigned int:
    (18446744073709551615, 0x80, "0xbfffffffffffffffff"),

    (0, 0xc0, "0xc0"),
    (55, 0xc0, "0xf7"),
    (56, 0xc0, "0xf838"),
    # max 32-bit unsigned int:
    (4294967295, 0xc0, "0xfbffffffff"),
    (4294967296, 0xc0, "0xfc0100000000"),
    # max 64-bit unsigned int:
    (18446744073709551615, 0xc0, "0xffffffffffffffffff"),
]

for length, offset, expected in test_cases:
    actual_dnative = length_prefix(length, offset)
    hex_prefix = bytes(actual_dnative).hex()
    assert "0x" + hex_prefix == expected
