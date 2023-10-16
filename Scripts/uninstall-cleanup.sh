#!/bin/bash

# uninstaller cleanup

# We must do a delayed cleanup, so we can remove the uninstaller receipts,
# which are written AFTER all postinstalls.
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
   for pkg in $PACKAGES $PACKAGES2 ; do
      pkgutil --force --forget "$pkg"
   done
   IFS="$OLD_IFS"
fi

# remove pre-10.6 package receipts
rm -rf /Library/Receipts/edu.stanford.folding.uninstall* 2>/dev/null

# finally, remove uninstaller pkg, from which we may have been run
# Installer.app may move or delete this early on its own
rm -rf "/Applications/Folding@home/Uninstall Folding@home.pkg" 2>/dev/null

# remove all .DS_Store
DIR="/Applications/Folding@home"
[ -d "$DIR" ] && find "$DIR" -type f -name .DS_Store -delete

# remove directories if empty
rmdir "$DIR/FAHControl" "$DIR/FAHViewer" "$DIR" 2>/dev/null

exit 0
