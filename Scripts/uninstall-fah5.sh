#!/bin/bash

# uninstall fah 5

# although fah5 is PPC only, cruft may exist on new machines due to Migration
# Assistant or disk cloning

# stop folding app
killall -TERM "Folding@home" 2>/dev/null

# do not stop nor delete CLI client fah5, as that is assumed to be under manual
# or third-party control

# assume fah screen saver is neither selected nor running
# it would probably have to be a ppc mac, 
# and it is unlikely someone would activate screen saver while uninstaller is
# running

# remove fah5 app; assume it is in /Applications
# don't delete fake fah6 app
if [ ! -f "/Applications/Folding@home.app/fah6" ]; then
    rm -rf "/Applications/Folding@home.app" 2>/dev/null
fi

# remove screen saver and package receipts

# screen saver used same pkg id (edu.stanford.folding) as later used by fah6
# so only remove 10.6 pkg receipt if saver exists in standard location
# note that it was allowed to install the saver under a user's home; we'll
# ignore that
F="/Library/Screen Savers/Folding@home.saver"
if [ -d "$F" ]; then
    # remove screen saver
    rm -rf "$F"
    # remove osx 10.6+ package receipts
    pkgutil --force --forget edu.stanford.folding
fi

# remove pre-10.6 package receipts
rm -rf /Library/Receipts/OSX-SS-5.02.pkg 2>/dev/null

exit 0
