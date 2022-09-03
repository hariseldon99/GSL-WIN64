# GSL-WIN64
Standalone 64-bit Windows Installer for the GNU Scientific Library

# Obtain GSL
Download the latest tarball of the GNU Scientific Library Source Code:

    $ wget https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz
    $ tar zxvf gsl-latest.tar.gz src/

# Cross-Compile
To prepare GNU Scientific Library for Windows, download the source code and cross-compile on linux.

On Linux, download the latest gsl tarball, then install mingw-w64 via apt. Unpack the tarball, goto 
the source directory and cross-compile for windows with 

    $ ./configure --host=x86_64-w64-mingw32 --prefix=<LOCAL-REPO-DIR>/gsl-2.7.1
    $ make
    $ make install

# Build Windows Executable

Use the included project files in Advanced Installer Architect (on Windows or on Linux using wine) to build the executable.


# TODO
Switch from Advanced Installer to NSIS