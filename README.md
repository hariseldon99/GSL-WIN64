# GSL-WIN64
Standalone 64-bit Windows Installer for the [GNU Scientific Library](https://www.gnu.org/software/gsl/). Can be installed without dependencies. Use from the [powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview) or with any IDE such as [Code::Blocks](https://www.codeblocks.org/), [geany](https://www.geany.org/) or [VS Code](https://code.visualstudio.com/). Tested with codeblocks.

# Note
This project is kinda deprecated.

Better methods for running GSL on windows are available now, such as the [C/C++ extension to VSCode](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools), which can be setup with GSL using [vcpkg](https://vcpkg.link/ports/gsl). Therefore, I won't be updating this repo anymore past gsl-2.8.


# Download and Install

If you just want to download and install the libraries, [click here](https://github.com/hariseldon99/GSL-WIN64/releases/) to obtain the installer.

The installer will install the GSL libraries into a folder of your choice (defaults to 'C:\Program Files\GSL_W64\gsl-x.y.z' where 'x.y.z' is the version number) and makes registry entries for the uninstaller. 

Note that if you install other (earlier or later) versions later, they will coexist with older installations. Therefore, it is possible to have multiple versions, and old versions will not be uninstalled automatically. However, the installer tells the system (via the 'PATH' environment variable) that GSL path can be found in the value of the variable 'GSL_LIBRARY_PATH', which is set to the folder where you told the installer to put GSL. So if you need to compile/run programs with other versions, you'll have to (gingerly) edit the 'GSL_LIBRARY_PATH' environment variable afterwards. I advise against editing 'PATH' manually unless you absolutely have to.

# Build Instructions
If you want to build the installer from scratch, read on.

Here are the instructions to build the Windows Installer on any Linux distribution. If you want to build on Windows, simply install [MSYS2](https://www.msys2.org/) and continue inside the bash shell installed by it.

Let's say that this repo has been cloned to the directory given by the environment variable: 

    GSL_WIN64DIR=/home/me/gitrepos/GSL-WIN64.

Let's also say that the latest version of GSL is stored in the environment variable:

    GSL_VERSION=2.7.1

The values need to be changed to meet your requirements. You can set them explicitly if you want by running (assuming bash shell or zsh) the [export](https://devconnected.com/set-environment-variable-bash-how-to/) command

### Obtain GSL
Download the latest tarball of the GNU Scientific Library Source Code:

    $ cd $GSL_WIN64DIR
    $ wget https://mirror.ibcp.fr/pub/gnu/gsl/gsl-latest.tar.gz
    $ tar zxvf gsl-latest.tar.gz src/

### Cross-Compile
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

**Note:** If you're compiling natively on Windows, then simply run the './configure' command above without the '--host' flag.

### Build Windows Executable

Once cross-compilation is complete, build the Windows Installer executable in the same shell with:
    
    $ cd $GSL_WIN64DIR
    $ makensis GSL-WIN64.nsi

It'll create the "GSL-WIN64.exe" file in $GSL_WIN64DIR. Copy it over to a running instance of Microsoft Windows and double-click for installation.


# License
GSL-WIN64 is an installer for GSL, therefore inherits the [GPL license](http://www.gnu.org/copyleft/gpl.html).
