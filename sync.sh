#!/bin/bash

if [ -n "$1" ]; then
	echo ''
	echo 'Start synchronizing...'
	git config remote.origin.url "git@github.com:librae8226/vimwiki.git"
	DATE=$(date)
	echo $DATE
	echo ''
	if [ $1 == "push" ]; then
		echo 'copy vimrc, bashrc and vimscheme file here.'
		cp ~/.bashrc ./bashrc_bak
		cp ~/.vimrc ./vimrc_bak
		echo 'pushing...'
		git add .
		git commit
		git push origin master
		git push --tags
		echo 'copying to /opt/lampp/htdocs..'
		rm -rf /opt/lampp/htdocs/vimwiki_html
		cp -r ~/vimwiki/vimwiki_html /opt/lampp/htdocs
	elif [ $1 == "pull" ]; then
		echo "pulling..."
		git pull origin master
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
