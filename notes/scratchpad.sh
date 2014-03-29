#!/bin/bash

exit 1

# notes and experiments for future inclusion in (un)install scripts

#if [ "$UID" -ne 0 ]; then
#    echo "error: you must run this script as root"
#    echo "use"
#    echo "  sudo $0"
#    exit 1
#fi


# fah 5
# future: remove per-user app prefs, for all users
# is this safe? what if some user somehow has a space in their home folder name?
#/bin/rm -f /Users/*/Library/Preferences/edu.stanford.folding.plist >/dev/null 2>&1
#/bin/rm -f /Users/*/Library/Preferences/edu.stanford.folding.viewer.plist >/dev/null 2>&1
# is SUDO_UID set when run by Installer.app?
# we'd like to do this for every user anyway
#sudo -u '#'"$SUDO_UID"  defaults delete edu.stanford.folding
#sudo -u '#'"$SUDO_UID"  defaults delete edu.stanford.folding.viewer
# leave ~/Library/Folding@home alone, so future installs might be able to pick up user,team from client.cfg


# fah 6
# future: maybe kill all fah6, even if run by third-party apps
# or have optional specific detect-and-uninstall for InCrease, finstall, ...
# leave ~/Library/Folding@home alone, so future installs might be able to pick up user,team,passkey from client.cfg


# fah 7 not removed:
# fahclient work directories, data and config files
# global and per-user crash logs, caches
#   /Library/Logs/{CrashReporter,DiagnosticReports}/{FAHClient_,FahCore_}*
#   ~/Library/Logs/{CrashReporter,DiagnosticReports}/{FAHClient_,FahCore_,fahcontrol_}*
#   ~/Library/Caches/<bundle-id>/Cache.db
#   ~/Library/Application Support/CrashReporter/fahcontrol_*
# per-user fahcontrol/fahviewer config files
#   ~/Library/Application Support/FAHClient/FAHControl.db
#   ? where are fahviewer prefs ?


# future:
# stop any fahclient running as a LaunchAgent to fold GPU units
# note: this would not catch any per-user LaunchAgents nor LoginItems
# note: agent label and filename expected to differ from daemon
F="/Library/LaunchAgents/edu.stanford.folding.fahclient.agent.plist"
if [ -f "$F" ]; then
    /bin/launchctl unload -w "$F"
    # note: we should extract fahclient working directory before deleting plists, so we can avoid deleting data
    /bin/rm -f "$F"
fi


# get path to app by bundle id
# this gets one (first?) path, but also launches the app!
osascript -e 'the posix path of (path to application id "edu.stanford.folding.fahcontrol")'


# get all paths to apps with bundle id x
# lsregister works, also works on bundle id fragments due to grep
# NOTE: also can show dups, outdated stuff from cache, and non-app stuff

/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump | grep --before-context=2 "edu.stanford.folding.fahcontrol" | grep -v Volumes | grep path: | awk '{print $2}'

/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump | grep --before-context=2 "edu.stanford.folding" | grep -v Volumes | grep path: | awk '{print $2}'
# results of second example:
# /Applications/FAHControl.app
# /Users/kevin2/Applications/FAH/Folding@home.app
# /Applications/fahclient.app
# /Users/kevin2/.Trash/Folding@home
# /Users/kevin2/.Trash/Folding@home
# /Applications/fahviewer.app
# /Users/kevin2/.Trash/Folding@home


# for each user, do something
# this doesn't work if there are spaces in folder names
# folder name is also not guaranteed to be user name
USERS=`(cd /Users ; echo * )`
# on newer verions of osx, we could get user names via dscl
# dscl also gets all the hidden _* users, plus root daemon nobody; and uses w/o a home dir
#USERS=`dscl . list /users`
for SOME_USER in $USERS ; do
    if [ "$SOME_USER" != "Guest" ] && [ "$SOME_USER" != "Shared" ] ; then
        echo \"$SOME_USER\"
        # NOTE: must be root for this to work and folder name needs to be same as user name
        if [ -d "/Users/$SOME_USER/Library/Preferences" ] ; then
            sudo -u "$SOME_USER" defaults delete edu.stanford.folding.nonesuch
        fi
    fi
done


exit 0
