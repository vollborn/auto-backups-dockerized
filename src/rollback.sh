#!/bin/bash

########################################
# Backup Service
#   by Oliver Vollborn
########################################

####################
# Variables
####################

sourcePath="/source"
backupPath="/backup"

rollbackPath="/rollback"

backupName="$1"

####################
# Functions
####################

printConfig() {
	echo ""
	echo "Auto Backup Rollback"
	echo "  Backup name: $backupName"
}

checkBackupName() {
	if [[ "$backupName" == "" ]]; then
		echo "Please pass a backup name."
		exit
	fi

	if [[ ! -f "$backupPath/$backupName" ]]; then
		echo "The backup $backupName does not exist."
		exit
	fi
}

rollbackZip () {
	if [[ -d "$rollbackPath" ]]; then
		rm -rf "$rollbackPath"
	fi

	echo "Creating rollback directory..."
	mkdir "$rollbackPath"
	cd "$rollbackPath" || exit
	
	echo "Copy backup file..."
	cp "$backupPath/$backupName" .

	echo "Extract rollback file..."
	unzip "$backupName"
	
	echo "Delete backup copy..."
	rm "$backupName"

	echo "Delete source directory contents..."
	rm -rf "$sourcePath:?/*"

	echo "Move files..."
	mv $rollbackPath/* "$sourcePath"
}

rollbackDirectory () {
	echo "Delete source directory contents..."
	rm -rf "$sourcePath:?/*"

	echo "Copying rollback files..."
	cp -r $backupPath/"$backupName"/* "$sourcePath"
}

####################
# Content
####################

checkBackupName

printConfig

echo ""
echo "Rolling back..."
echo ""

if [[ $backupName == *.zip ]]; then
	rollbackZip
else
	rollbackDirectory
fi

echo ""
echo "Rolled back."
echo ""

