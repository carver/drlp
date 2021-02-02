drlp
====

Aspirational: An implementation of RLP encoding/decoding in D, with Python bindings. (See how
rusty-rlp integrates with pyrlp)

Actual: A tinkering project to learn how D works, and how it connects to Python.

Notes for complete beginners in D. They are probably wrong, because I am one.

Running
-------

To just run the native D code like a script (with unit tests running):
```sh
rdmd -unittest rlp.d
```

To time the native benchmark, uncomment the loop with 1 million (x2) invocations, then run:
```sh
# Build the optimized binary
dmd -O rlp.d

# Time the invocations
time ./rlp
```

To time the benchmark through python bindings:
```sh
rm -rf build/ && python setup.py install
time python pyboundrun.py
```
(You'll need to have dpy & wheel python packages installed first)

Stats
-----

When running 2 million invocations natively:
  real    0m0.338s
  user    0m0.351s
  sys     0m0.009s

When running 2 million invocations via python bindings:
  real    0m1.903s
  user    0m1.958s
  sys     0m0.025s

The pure python implementation runs in:
  real    0m1.062s
  user    0m1.042s
  sys     0m0.020s

TODO
----

Deduplicate the lengthPrefix methods (original, and python bindings). I think it wasn't working when
linking from the python project because I need to manually select both `drlp.d` AND `rlp.d`.
