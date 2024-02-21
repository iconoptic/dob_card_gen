#!/bin/bash

# Check for card name
if [[ $# -ne 1 ]]; then
	echo "Enter name as argument."
	exit 10
fi
thisName="$1"

# Ensure that the folder exists
thisDir="$(find ~/OneDrive/Documents\ -\ Simulation\ Scenarios/ -maxdepth 2 -mindepth 2 -type d | grep -Ev 'Attendance'\|'FRCC' | grep "$thisName")"
if [[ $(echo $thisDir | wc -l) -lt 1 ]]; then
	echo "The Scenario was not found."
	exit 20
fi

# Find allergy name
thisNLN="$(ls -t "$thisDir" | grep docx$ | grep -i NLN | head -1)"
thisAllergy="$(pandoc "$thisDir/$thisNLN" | grep -io "allergies.*" | sed "s/<[^>]*>//g;s/Allergies: //g;s/Immunizations.*//g;s/(required a//g")"

#Restore template to original state
cp orig_template.tex template.tex

echo "$thisName"

sed "s/ScenName/$thisName/g" -i template.tex
sed "s/AllergyName/$thisAllergy/g" -i template.tex

touch input.txt
OUTPUT_FILE="$thisName DOB Card.pdf"
# Create the PDF document
pandoc input.txt -o "$OUTPUT_FILE" \
  --template=template.tex \
  --metadata title="DOB Cards"
rm input.txt



