#!/usr/bin/env python
import setuptools
import distutils
import distutils.core
import distutils.sysconfig
import os
from os import path
import sys
from glob import glob
import shutil


distutils.sysconfig.get_config_vars()


def install_headers():
    dest_dir = path.join(sys.prefix, 'include', 'murmurhash')
    if not path.exists(dest_dir):
        shutil.copytree('murmurhash/headers/murmurhash', dest_dir)

def rm_cflag(text):
    cflags = distutils.sysconfig._config_vars['CFLAGS']
    cflags = cflags.replace(text, '')
    distutils.sysconfig._config_vars['CFLAGS'] = cflags

install_headers()
includes = ['.', path.join(sys.prefix, 'include')]

rm_cflag('-fno-strict-aliasing')
rm_cflag('-Wstrict-prototypes')
rm_cflag('-NDEBUG')


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
    package_data={'murmurhash': ['*.pyx', 'headers/murmurhash/*.h', '*.pxd']},
    author='Matthew Honnibal',
    author_email='honnibal@gmail.com',
    version='0.24',
    ext_modules=exts,
    classifiers=[
                'Development Status :: 4 - Beta',
                'Environment :: Console',
                'Operating System :: OS Independent',
                'Intended Audience :: Science/Research',
                'Programming Language :: Cython',
                'Topic :: Scientific/Engineering'],
)
