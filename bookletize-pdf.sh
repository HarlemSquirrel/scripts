#!/bin/bash

###############################################################################
# Reorder pages in a PDF document for printing as booklet
# using duplex printing.
#
# The first page is assumed to be the front cover and
# the last page the back cover.
#
# mutool is required.
# https://mupdf.com/docs/index.html
###############################################################################

# Load helper functions
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
source $SCRIPTPATH/helper_functions.sh

function join_by {
	local IFS="$1"; shift; echo "$*";
}

if [ ! $# -eq 2 ]; then
	colorprintf red "Please supply source and target file names.\n"
	printf "Ex:\n  $0 source.pdf target.pdf \n\n"
	exit 1
fi

docname=$1
newdocname=$2
numpages=$(mutool info $docname | grep "Pages: " | cut -d ":" -f2 | xargs)

printf "Number of pages is $numpages\n"

reordering=("60,1")
endnum=$(($numpages/2))
for pagenum in $(seq 2 $endnum); do
	reordering+=("$pagenum,$(($numpages + 1 - $pagenum))")
done

printf "New page order:\n$(join_by , ${reordering[@]})\n"

mutool merge -o $newdocname $docname "$(join_by , ${reordering[@]})"
