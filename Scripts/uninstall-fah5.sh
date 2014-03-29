#!/bin/bash

# uninstall fah 5

# although fah5 is PPC only, cruft may exist on new machines due to Migration
# Assistant or disk cloning

# stop folding app
killall -TERM "Folding@home" >/dev/null 2>&1

# do not stop nor delete CLI client fah5, as that is assumed to be under manual
# or third-party control

# assume fah screen saver is neither selected nor running
# it would probably have to be a ppc mac, 
# and it is unlikely someone would activate screen saver while uninstaller is
# running

# remove fah5 app
# note that this could have been placed anywhere by user; we'll assume they put
# it in /Apps in the future, we should find and delete all instances on boot
# volume don't delete fake fah6 app
if [ ! -f "/Applications/Folding@home.app/fah6" ]; then
    rm -rf "/Applications/Folding@home.app" >/dev/null 2>&1
fi

# remove screen saver and package receipts

# screen saver used same pkg id (edu.stanford.folding) as later used by fah6
# so only remove 10.6 pkg receipt if saver exists in standard location
# note that it was allowed to install the saver under a user's home; we'll
# ignore that
# in the future, we should find and delete all instances on boot volume
F="/Library/Screen Savers/Folding@home.saver"
if [ -d "$F" ]; then
    # remove screen saver
    rm -rf "$F"
    # remove osx 10.6+ package receipts
    OS_MAJOR="`/usr/bin/uname -r | cut -f1 -d.`"
    if [ "$OS_MAJOR" -ge 10 ]; then
        # We have Snow Leopard or higher.
        pkgutil --force --forget edu.stanford.folding
    fi
fi

# remove pre-10.6 package receipts
rm -rf /Library/Receipts/OSX-SS-5.02.pkg >/dev/null 2>&1

exit 0
