#!/bin/bash

# uninstall fah 7

# terminate FAHControl and FAHViewer if running; also terminate by old exe names
killall -TERM FAHControl FAHViewer fahcontrol FAHClientGUI 2>/dev/null

# stop folding service; old plist names
F="/Library/LaunchDaemons/FAHClient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    rm -f "$F"
fi

F="/Library/LaunchDaemons/edu.stanford.folding.fahclient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    rm -f "$F"
else
    launchctl remove edu.stanford.folding.fahclient
fi

# stop folding service
F="/Library/LaunchDaemons/org.foldingathome.fahclient.plist"
if [ -f "$F" ]; then
    launchctl unload -w "$F"
    rm -f "$F"
else
    # try to unload job, even if user manually deleted plist
    launchctl remove org.foldingathome.fahclient
fi

# kill any FAHClient still running
if ps auxwww | grep "FAHClient" | grep -v 'grep' >/dev/null 2>&1; then
    # wait a second for client to stop on its own, then TERM any still running
    sleep 1
    killall -TERM FAHClient 2>/dev/null
fi

# trust that all cores and corewrappers will quit normally

# remove scripts, symlinks, executables
rm -f /usr/bin/FAH{Client,CoreWrapper,Control,Viewer} 2>/dev/null
rm -f /usr/local/bin/FAH{Client,CoreWrapper} 2>/dev/null

# remove apps, by old and new names
rm -rf /Applications/FAHClientGUI.app 2>/dev/null
rm -rf /Applications/Folding\@home\ Client.app 2>/dev/null

rm -rf /Applications/fah{client,viewer}.app 2>/dev/null

rm -rf /Applications/FAH{Control,Viewer}.app 2>/dev/null
rm -f /Applications/FAHClient.url 2>/dev/null

rm -rf /Applications/Folding\@home/FAH{Control,Viewer}.app 2>/dev/null
rm -f /Applications/Folding\@home/FAHClient.url 2>/dev/null
rm -f /Applications/Folding\@home/Web\ Control.url 2>/dev/null

rm -rf /Applications/Folding\@home/FAHControl/FAHControl.app 2>/dev/null
rm -rf /Applications/Folding\@home/FAHViewer/FAHViewer.app 2>/dev/null

# remove osx 10.6+ package receipts
pkgutil --force --forget edu.stanford.folding.fahclient.pkg
pkgutil --force --forget edu.stanford.folding.fahcontrol.pkg
pkgutil --force --forget edu.stanford.folding.fahviewer.pkg
pkgutil --force --forget org.foldingathome.fahclient.pkg
pkgutil --force --forget org.foldingathome.fahcontrol.pkg
pkgutil --force --forget org.foldingathome.fahviewer.pkg

# remove pre-10.6 package receipts
rm -rf /Library/Receipts/edu.stanford.folding.fah{client,control,viewer}.pkg \
  2>/dev/null

exit 0
