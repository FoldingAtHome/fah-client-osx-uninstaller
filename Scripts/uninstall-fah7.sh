#!/bin/bash

# uninstall fah 7

# terminate FAHControl and FAHViewer if running; also terminate by old exe names
killall -TERM FAHControl FAHViewer fahcontrol FAHClientGUI >/dev/null 2>&1

# stop folding service; old plist name
F="/Library/LaunchDaemons/FAHClient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    # note: we should extract fahclient working directory before deleting
    # plists, so we can avoid deleting data
    rm -f "$F"
fi

# stop folding service
F="/Library/LaunchDaemons/edu.stanford.folding.fahclient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    rm -f "$F"
else
    # try to unload job, even if user manually deleted plist
    launchctl remove edu.stanford.folding.fahclient >/dev/null 2>&1
fi

# stop folding service
F="/Library/LaunchDaemons/org.foldingathome.fahclient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    rm -f "$F"
else
    # try to unload job, even if user manually deleted plist
    launchctl remove org.foldingathome.fahclient >/dev/null 2>&1
fi

# future: stop any fahclient running as root or per-user LaunchAgent, or
# per-user LoginItem to fold GPU units, or per-user via SpawnApps

# kill any FAHClient still running
if ps auxwww | grep "FAHClient" | grep -v 'grep' >/dev/null 2>&1; then
    # wait a second for client to stop on its own, then TERM any still running
    sleep 1
    killall -TERM FAHClient >/dev/null 2>&1
fi

# trust that all cores and corewrappers will quit normally

# remove scripts, symlinks, executables
rm -f /usr/bin/FAHControl >/dev/null 2>&1
rm -f /usr/bin/FAHViewer >/dev/null 2>&1
rm -f /usr/bin/FAH{Client,CoreWrapper} >/dev/null 2>&1
rm -f /usr/local/bin/FAH{Client,CoreWrapper} >/dev/null 2>&1

# remove apps, by old and new names
# future: also find and delete any moved copies of the apps
rm -rf /Applications/FAHClientGUI.app >/dev/null 2>&1
rm -rf /Applications/Folding\@home\ Client.app >/dev/null 2>&1

rm -rf /Applications/fahclient.app >/dev/null 2>&1
rm -rf /Applications/fahviewer.app >/dev/null 2>&1

rm -rf /Applications/FAHControl.app >/dev/null 2>&1
rm -rf /Applications/FAHViewer.app >/dev/null 2>&1
rm -f /Applications/FAHClient.url >/dev/null 2>&1

rm -rf /Applications/Folding\@home/FAHControl.app >/dev/null 2>&1
rm -rf /Applications/Folding\@home/FAHViewer.app >/dev/null 2>&1
rm -f /Applications/Folding\@home/FAHClient.url >/dev/null 2>&1
rm -f /Applications/Folding\@home/Web\ Control.url >/dev/null 2>&1

rm -rf /Applications/Folding\@home/FAHControl/FAHControl.app >/dev/null 2>&1
rm -rf /Applications/Folding\@home/FAHViewer/FAHViewer.app >/dev/null 2>&1

# remove osx 10.6+ package receipts
OS_MAJOR="`uname -r | cut -f1 -d.`"
if [ "$OS_MAJOR" -ge 10 ]; then
    # We have Snow Leopard or higher.
    pkgutil --force --forget edu.stanford.folding.fahclient.pkg
    pkgutil --force --forget edu.stanford.folding.fahcontrol.pkg
    pkgutil --force --forget edu.stanford.folding.fahviewer.pkg
    pkgutil --force --forget org.foldingathome.fahclient.pkg
    pkgutil --force --forget org.foldingathome.fahcontrol.pkg
    pkgutil --force --forget org.foldingathome.fahviewer.pkg
fi

# remove pre-10.6 package receipts
rm -rf /Library/Receipts/edu.stanford.folding.fahclient.pkg \
    >/dev/null 2>&1
rm -rf /Library/Receipts/edu.stanford.folding.fahcontrol.pkg \
    >/dev/null 2>&1
rm -rf /Library/Receipts/edu.stanford.folding.fahviewer.pkg \
    >/dev/null 2>&1
# on 10.4, I get these
rm -rf /Library/Receipts/fahclient.pkg >/dev/null 2>&1
rm -rf /Library/Receipts/fahcontrol.pkg >/dev/null 2>&1
rm -rf /Library/Receipts/fahviewer.pkg >/dev/null 2>&1

exit 0
