# GSL-WIN64
Standalone 64-bit Windows Installer for the GNU Scientific Library. Can be installed without dependencies. Use with IDEs such as [Code::Blocks](https://www.codeblocks.org/)

# Build Instructions

Instructions to build the Windows Installer on any Linux distribution. Let's say that this repo has been cloned to the directory given by the environment variable: 

    GSL_WIN64DIR=/home/me/gitrepos/GSL-WIN64.

Let's also say that the latest version of GSL is stored in the environment variable:

    GSL_VERSION=2.7.1

The values need to be changed to meet your requirements. You can set them explicitly if you want.

## Obtain GSL
Download the latest tarball of the GNU Scientific Library Source Code:

    $ cd $GSL_WIN64DIR
    $ wget https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz
    $ tar zxvf gsl-latest.tar.gz src/

## Cross-Compile
To prepare GNU Scientific Library for Windows, download the source code and cross-compile on Linux.

On Linux, download the latest gsl tarball, then install the following dependencies using your Linux package manager

1. [mingw-w64](https://www.mingw-w64.org/) Windows C-cross-compiler for Linux 
2. [NSIS](https://nsis.sourceforge.io): Nullsoft Scriptable Install System for building Windows Installers for Linux

Both packages are available in the Ubuntu repositories

In addition, the EnVar Plug-in for NSIS needs to be installed. Download from [The EnVar Plugin Page](https://nsis.sourceforge.io/EnVar_plug-in)

In a shell, cross-compile for windows with 

    $ cd $GSL_WIN64DIR/src/gsl-$GSL_VERSION
    $ ./configure --host=x86_64-w64-mingw32 --prefix=$GSL_WIN64DIR/gsl-$GSL_VERSION
    $ make
    $ make install

## Build Windows Executable

Once cross-compilation is complete, build the Windows Installer executable in the same shell with:
    
    $ cd $GSL_WIN64DIR
    $ makensis GSL-WIN64.nsi

It'll create the "GSL-WIN64.exe" file in $GSL_WIN64DIR.
