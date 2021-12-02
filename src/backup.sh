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

sleepDelay="$1"
zipBackups="$2"
maxBackupCount="$3"

####################
# Functions
####################

printConfig () {
	echo ""
	echo "Auto-Backup started."
	echo "  Sleep delay:       $sleepDelay"
	echo "  Zip backups:       $zipBackups"
	echo "  Max backup count:  $maxBackupCount"
}

setDate () {
	date=$(date +"%Y-%m-%d_%H-%M-%S")
}

deleteOldBackups () {
	counter=0

	# shellcheck disable=SC2207
	backupList=( $(ls -1b "$backupPath") )
	backupCount=${#backupList[@]}

	deleteCount=$((backupCount - maxBackupCount))

	if [[ $deleteCount -lt 1 ]]; then
		echo "No backups to delete."
		return
	fi

	while [[ $counter -lt $deleteCount ]]; do
		echo "Deleting backup ${backupList[$counter]}..."
		# shellcheck disable=SC2115
		rm -rf "$backupPath/${backupList[$counter]}"
		counter=$((counter + 1))
	done
}

isTrue () {
	if [[ $1 == "true" || $1 == "1" || $1 == "yes" ]]; then
		return 0
	fi
	return 1
}

doBackup () {
	# shellcheck disable=SC2207
	fileList=( $(ls -1b "$sourcePath") )
	if [[ "${#fileList[@]}" == "0" ]]; then
		echo "No files to backup."
		return
	fi

	if isTrue "$zipBackups"; then
		echo "Creating zip..."
		zip -r "$backupPath/$date.zip" ./*
	else
		echo "Copy files..."
		cp -r "$sourcePath" "$backupPath/$date"
	fi
}

####################
# Content
####################

cd "$sourcePath" || exit

printConfig

while true; do
	
	setDate

	echo ""
	echo "###  $date  ###"
	echo ""

	echo "Creating backup..."
	
	doBackup

	echo "Backup created."
	echo "Looking for old backups..."
	
	deleteOldBackups

	echo "Completed."

	sleep "$sleepDelay"

done

