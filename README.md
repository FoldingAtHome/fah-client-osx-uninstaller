# Folding@home Desktop Client OSX Uninstaller

A package to uninstall Folding@home versions 5 through 8
for macOS 10.5+, all architectures.

Pre-built packages are available at
[Releases](https://github.com/FoldingAtHome/fah-client-osx-uninstaller/releases)


## Building without signing

Build requires
- macOS 10.15.4 or later
- Xcode 12.2 or later from the Apple Mac App Store

Run commands

```
python3 -m venv ~/.venv/build-uninstaller
source ~/.venv/build-uninstaller/bin/activate
pip3 install --upgrade pip scons

mkdir -p ~/build && cd ~/build

git clone https://github.com/cauldrondevelopmentllc/cbang
git clone https://github.com/FoldingAtHome/fah-client-osx-uninstaller.git
export CBANG_HOME="$PWD/cbang"
scons -C fah-client-osx-uninstaller package
```
