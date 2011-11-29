#!/bin/bash

if [ -n "$1" ]; then
	echo ''
	echo 'Start synchronizing...'
	#git config remote.origin.url "git@github.com:librae8226/vim_conf.git"
	DATE=$(date)
	echo $DATE
	echo ''
	if [ $1 == "push" ]; then
		echo 'copy vimrc, bashrc and vimscheme file here.'
		cp -af ~/.vimrc ./_vimrc
		cp -af ~/.vim/* ./_vim/
		echo 'pushing...'
		git add .
		git commit
		git push origin master
	elif [ $1 == "pull" ]; then
		echo "pulling..."
		git pull --all
	else
		echo "error arg."
		echo "USAGE: sync push|pull"
		exit
	fi
else
	echo "USAGE: sync push|pull"
	exit
fi

echo ''
echo 'Synchronize ok.'
echo ''
