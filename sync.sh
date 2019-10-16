#!/bin/sh


while [ 1 ]
do
  echo "watching  ScratchingSwift"
  fswatch -1 -d  /Users/psksvp/MyCode/ScratchingSwift/Sources 
  echo "syncing  ScratchingSwift to haneda"
  rsync -az --delete -v -e ssh /Users/psksvp/MyCode/ScratchingSwift/Sources pi@haneda.local:/home/pi/workspace/ScratchingSwift
	scp Package.swift pi@haneda.local:/home/pi/workspace/ScratchingSwift/.
done




