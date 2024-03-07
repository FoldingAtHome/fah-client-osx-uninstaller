#!/bin/bash

# uninstall fah 6

# remove folding pref pane
if [ -d "/Library/PreferencePanes/Folding@home.prefPane" ]; then
  rm -rf "/Library/PreferencePanes/Folding@home.prefPane"
fi

# remove pref pane helper
F="/Library/LaunchDaemons/edu.stanford.folding.prefpane.plist"
if [ -f "$F" ]; then
  launchctl unload -w /Library/LaunchDaemons/edu.stanford.folding.prefpane.plist
  rm -f "$F" /Library/PrivilegedHelperTools/edu.stanford.folding.prefpane \
    /var/run/edu.stanford.folding.prefpane.socket 2>/dev/null
fi

# stop folding and remove launchd plist
F="/Library/LaunchDaemons/Folding@home.plist"
if [ -f "$F" ]; then
  launchctl unload -w "$F"
  rm -f "$F"
fi

# don't kill all fah6, because anything still running probably belongs to a
# third-party tool or was launched manually
# don't kill any cores

# remove fah6 client executables
rm -rf /usr/local/fah/ 2>/dev/null

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
       /Library/Receipts/edu.stanford.folding.pkg 2>/dev/null

exit 0
