#!/bin/bash

# uninstall fah 8

# stop folding service
F="/Library/LaunchDaemons/org.foldingathome.fahclient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    rm -f "$F"
else
    # try to unload job, even if user manually deleted plist
    launchctl remove org.foldingathome.fahclient >/dev/null 2>&1
fi

# kill any fah-client still running
if ps auxwww | grep "fah-client" | grep -v 'grep' >/dev/null 2>&1; then
    # wait a second for client to stop on its own, then TERM any still running
    sleep 1
    killall -TERM fah-client >/dev/null 2>&1
fi

# trust that all cores will quit normally

# remove scripts, symlinks, executables, extras
rm -f /usr/local/bin/fah-client >/dev/null 2>&1
rm -f /Applications/Folding\@home/fahclient.url >/dev/null 2>&1
rm -f /Applications/Folding\@home/uninstall.url >/dev/null 2>&1

# remove osx 10.6+ package receipts
pkgutil --force --forget org.foldingathome.fahclient.pkg

exit 0
