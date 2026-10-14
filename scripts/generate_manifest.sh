#!/usr/bin/env bash

OUTPUT="logs/full_manifest.txt"

#Create logs directory if missing
mkdir -p logs

echo "Generating full manifest.txt..."

{
	echo "========================================================"
	echo "PROJECT DIRECTORY + FILE MANIFEST WITH MD5 CHECKSUMS"
	echo "Generated on: $(date)"
	echo "Working directory: $(pwd)"
	echo "========================================================"
	echo

	for dir in data raw_qc post_qc trimmed reports logs
	do
		if [ -d "$dir" ]; then
			echo "############################################"
			echo "DIRECTORY: $dir"
			echo "############################################"
			echo

			echo ">>> SUBDIRECTORIES"
			find "$dir" -type d | sort
			echo

			echo ">>> FILES + MD5 CHECKSUMS"
			# find "$dir" -type f -exec md5 -r {} \; | sort
			find "$dir" -type f -exec md5sum {} \; | sort
			echo

			echo "------------------------------------------------------------"
			echo
		else
			echo "WARNING: Directory '$dir' does not exist"
			echo

		fi
	done
} > "$OUTPUT"

echo "Manifest complete!"
echo "Saved to: $OUTPUT"
