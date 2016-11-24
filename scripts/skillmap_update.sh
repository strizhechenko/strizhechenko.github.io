#!/bin/bash

readonly input=share/my-skills.gv
readonly books=share/books.gv

for format in png svg; do
	output=images/my-skills.$format
	sfdp -Goverlap=prism $input | \
		gvmap -e | \
		neato -Ecolor="#55555522" -n2 -T$format > $output
	if [ "$#" = '0' ]; then
		git add $output
	fi

	output=images/books.$format
	sfdp -Goverlap=prism $books | \
		gvmap -e | \
		neato -Ecolor="#55555522" -n2 -T$format > $output
	if [ "$#" = '0' ]; then
		git add $output
	fi
done
