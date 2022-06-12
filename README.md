# Folding@home Desktop Client OSX Uninstaller

A package to uninstall Folding@home versions 5 through 8
for macOS 10.5+, all architectures.

Pre-built packages are available at
[Releases](https://github.com/FoldingAtHome/fah-client-osx-uninstaller/releases)


## Building without signing

You will need Xcode from the Apple Mac App Store.

You will need SCons

    pip3 install scons --user

Make sure `scons` is in your `PATH`.

Then use commands

    git clone https://github.com/FoldingAtHome/fah-client-osx-uninstaller.git
    cd fah-client-osx-uninstaller
    git submodule update --init --recursive
    scons package
