# GSL-WIN64
Standalone 64-bit Windows Installer for the GNU Scientific Library. Can be installed without dependencies. Use with IDEs such as [Code::Blocks](https://www.codeblocks.org/)

# Build Instructions

Instructions to build the Windows Installer on any Linux distribution:

## Obtain GSL
Download the latest tarball of the GNU Scientific Library Source Code:

    $ wget https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz
    $ tar zxvf gsl-latest.tar.gz src/

## Cross-Compile
To prepare GNU Scientific Library for Windows, download the source code and cross-compile on Linux.

On Linux, download the latest gsl tarball, then install the following dependencies using your Linux package manager

1. [mingw-w64](https://www.mingw-w64.org/) Windows C-cross-compiler for Linux 
2. [NSIS](https://nsis.sourceforge.io): Nullsoft Scriptable Install System for building Windows Installers for Linux

Both packages are available in the Ubuntu repositories

In addition, the EnVar Plug-in for NSIS needs to be installed. Download from [The EnVar Plugin Page](https://nsis.sourceforge.io/EnVar_plug-in)

In a shell, navigate to the GSL source directory (say, <GSL-WIN64>) and cross-compile for windows with 

    $ ./configure --host=x86_64-w64-mingw32 --prefix=<GSL-WIN64>/gsl-2.7.1
    $ make
    $ make install

## Build Windows Executable

Once cross-compilation is complete, build the Windows Installer executable in the same shell with:

    $ makensis GSL-WIN64.nsi

It'll create the "GSL-WIN64.exe" file in the GSL source directory.