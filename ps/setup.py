#!/usr/bin/env python
#
# Distutils setup script for Process library
#
#
#
from distutils.core import setup, Extension

release_version = '0.1'

setup(
    name='python-ps',
    version=release_version,
    description='Process Information',
    long_description='Ps is a module for querying the proc filesystem for process information on Linux',
    license='GPL',
    author='John Hover',
    author_email='jhover@bnl.gov',
    url='http://www.saros.us/moin/JohnHover',

    #
    # Define packages-- placed in <prefix>/lib/python/site-packages/
    #
    #
    py_modules = ['ps'],

    #
    # Info for Sourceforge/RPM
    #
    classifiers=[ 'Development Status :: 4 - Beta',
          'Environment :: Console',
          'Intended Audience :: Devlopers',
          'License :: OSI Approved :: GPL',
          'Operating System :: POSIX',
          'Programming Language :: Python',
          'Topic :: Software Development',
    ],
) # end setup()
