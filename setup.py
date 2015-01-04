#!/usr/bin/env python
import setuptools
import os
from os import path
from glob import glob


includes = ['murmurhash/']


try:
    from Cython.Build import cythonize
    from Cython.Distutils import Extension

    exts=cythonize([
        Extension('murmurhash.mrmr', ["murmurhash/mrmr.pyx", "murmurhash/MurmurHash2.cpp",
              "murmurhash/MurmurHash3.cpp"], language="c++", include_dirs=includes),
    ])
except ImportError:
    from distutils.extension import Extension
    exts = [
        Extension('murmurhash.mrmr', ["murmurhash/mrmr.cpp", "murmurhash/MurmurHash2.cpp",
              "murmurhash/MurmurHash3.cpp"], language="c++", include_dirs=includes),
    ]


setuptools.setup(
    name='murmurhash',
    packages=['murmurhash'],
    package_data={'murmurhash': ['*.pyx', '*.h', '*.pxd']},
    author='Matthew Honnibal',
    author_email='honnibal@gmail.com',
    version='0.22',
    ext_modules=exts,
    classifiers=[
                'Development Status :: 4 - Beta',
                'Environment :: Console',
                'Operating System :: OS Independent',
                'Intended Audience :: Science/Research',
                'Programming Language :: Cython',
                'Topic :: Scientific/Engineering'],
    headers=["murmurhash/MurmurHash2.h", "murmurhash/MurmurHash3.h"]
)
