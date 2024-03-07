#!/bin/bash

# uninstall fah 8

# only continue on macOS 10.13+
OS_MAJOR="`sw_vers -productVersion | cut -f1 -d.`"
OS_MINOR="`sw_vers -productVersion | cut -f2 -d.`"
if [ "$OS_MAJOR" -eq 10 -a "$OS_MINOR" -lt 13 ]; then exit 0; fi

# stop folding service
F="/Library/LaunchDaemons/org.foldingathome.fahclient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    rm -f "$F"
else
    # try to unload job, even if user manually deleted plist
    launchctl remove org.foldingathome.fahclient
fi

# kill any fah-client still running
if ps auxwww | grep "fah-client" | grep -v 'grep' >/dev/null 2>&1; then
    # wait a second for client to stop on its own, then TERM any still running
    sleep 1
    killall -TERM fah-client 2>/dev/null
fi

# trust that all cores will quit normally

# remove scripts, symlinks, executables, extras
rm -f /usr/local/bin/fah-client 2>/dev/null
rm -f /Applications/Folding\@home/{fahclient,uninstall}.url 2>/dev/null
rm -f /Applications/Folding\@home/Folding\@home.url 2>/dev/null

# remove re-downloadable files
DATA="/Library/Application Support/FAHClient"
rm -f "$DATA/"{GPUs.txt,gpus.json} 2>/dev/null
rm -rf "$DATA/"{cores,fah-web-control} 2>/dev/null

# remove osx 10.6+ package receipts
pkgutil --force --forget org.foldingathome.fahclient.pkg

exit 0
