#!/bin/bash

# uninstall fah 6

# quit System Preferences and remove folding pref pane
if [ -d "/Library/PreferencePanes/Folding@home.prefPane" ]; then
    killall -TERM "System Preferences" >/dev/null 2>&1
    rm -rf "/Library/PreferencePanes/Folding@home.prefPane"
fi

# remove pref pane helper
launchctl unload -w \
    /Library/LaunchDaemons/edu.stanford.folding.prefpane.plist >/dev/null 2>&1
rm -f /Library/LaunchDaemons/edu.stanford.folding.prefpane.plist \
    >/dev/null 2>&1
rm -f /Library/PrivilegedHelperTools/edu.stanford.folding.prefpane \
    >/dev/null 2>&1
rm -f /var/run/edu.stanford.folding.prefpane.socket >/dev/null 2>&1

# stop folding and remove launchd plist
F="/Library/LaunchDaemons/Folding@home.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F" >/dev/null 2>&1
    rm -f "$F"
fi

# don't kill all fah6, because anything still running probably belongs to a
# third-party tool or was launched manually

# future: kill any true orphan cores and mpiexec, by checking parent process,
# ideally after at least 1 minute
# there can be other mpiexec, so never kill that unless it's parent to a fahcore
# don't kill cores running under fah 7

# remove fah6 client executables
rm -rf /usr/local/fah/ >/dev/null 2>&1

# remove old fake app, which only contained older executables
if [ -x "/Applications/Folding@home.app/fah6" ]; then
    rm -rf "/Applications/Folding@home.app"
fi

# remove osx 10.6+ package receipts
pkgutil --force --forget edu.stanford.folding.foldinghome6241.root.pkg
pkgutil --force --forget edu.stanford.folding

# remove pre-10.6 package receipts
# old fah6 pref pane installers made root.pkg
F="/Library/Receipts/root.pkg"
if [ -f "$F/Contents/Info.plist" ]; then
    BID=`defaults read "$F/Contents/Info" CFBundleIdentifier`
    # goofy comparison, but it's backwards compatible with old sh
    if [ "$(echo $BID | cut -c1-13)" == "edu.stanford." ] ; then
        rm -rf "$F"
    fi
fi
# these two are theoretical
rm -rf /Library/Receipts/edu.stanford.folding.foldinghome6241.root.pkg \
    >/dev/null 2>&1
rm -rf /Library/Receipts/edu.stanford.folding.pkg >/dev/null 2>&1

exit 0
