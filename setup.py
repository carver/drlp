from pyd.support import setup, Extension

projName = 'drlp'

setup(
    name=projName,
    version='0.1',
    ext_modules=[
        Extension(projName, ['drlp.d'],
            extra_compile_args=['-w'],
            build_deimos=True,
            d_lump=True
        )
    ],
)
