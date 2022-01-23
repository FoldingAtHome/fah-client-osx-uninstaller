#!/bin/bash

# uninstaller cleanup

# We must do a delayed cleanup, so we can remove the uninstaller receipts,
# which are written AFTER all postflights.
# Metapkg postflight is actually run before the component postflights.
if [ "$1" != "--delayed-cleanup" ]; then
  "$0" --delayed-cleanup "$@" &
  exit 0
fi
shift

# Wait up to 1 minute for Installer.app to quit
I=0
while $(ps axww|grep -v grep|grep Installer.app >/dev/null 2>&1); do
  sleep 1
  let I+=1
  if [ $I -ge 60 ]; then break; fi
done

if [ $I -lt 1 ]; then sleep 1; fi

# remove uninstaller package receipts
# edu.stanford.folding.uninstaller.pkg
# edu.stanford.folding.uninstall.fah{5,6,7}.pkg
# edu.stanford.folding.uninstall.cleanup.pkg
# org.foldingathome.uninstall*

# derived from vmware uninstaller script
# remove osx 10.6+ package receipts
OS_MAJOR="`/usr/bin/uname -r | cut -f1 -d.`"
if [ "$OS_MAJOR" -ge 10 ]; then
   # Assume Snow Leopard or higher.
   PACKAGES=`pkgutil --pkgs='edu\.stanford\.folding\.uninstall.*'`
   PACKAGES2=`pkgutil --pkgs='org\.foldingathome\.uninstall.*'`
   OLD_IFS="$IFS"
   IFS=$'\n'
   # Discard the existing package receipt data including any old pkg ID(s).
   for pkg in $PACKAGES $PACKAGES2 ; do
      pkgutil --force --forget $pkg
   done
   IFS="$OLD_IFS"
   # We don't use pkgutil --unlink to remove the installed package contents
   # because it does not remove the directories. We fall back to removing
   # the files manually below. If pkgutil is ever updated to remove the
   # directories, we should use it instead, and remove any install/runtime
   # created files here.
fi

# remove pre-10.6 package receipts
rm -rf /Library/Receipts/edu.stanford.folding.uninstall* >/dev/null 2>&1

# finally, remove uninstaller pkg, from which we may have been run
# Installer.app may move or delete this early on its own
rm -rf "/Applications/Folding@home/Uninstall Folding@home.pkg" >/dev/null 2>&1
0
# remove all .DS_Store
DIR="/Applications/Folding@home"
[ -d "$DIR" ] && find "$DIR" -type f -name .DS_Store -delete

# remove directories if empty
rmdir "$DIR/FAHControl" >/dev/null 2>&1
rmdir "$DIR/FAHViewer" >/dev/null 2>&1
rmdir "$DIR" >/dev/null 2>&1

exit 0
