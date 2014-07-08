#!/bin/bash


DIROUT="./target"
mkdir $DIROUT
HTMLOUT=$DIROUT"/Documentation-entrepot-scripts.html"


echo "<HTML>" > $HTMLOUT
echo "<HEAD>" >> $HTMLOUT
echo "<TITLE>Documentation entrepot-scripts</TITLE>" >> $HTMLOUT
echo "</HEAD>" >> $HTMLOUT
echo "<BODY>" >> $HTMLOUT
echo "<H1>"Documentation entrepot-scripts"</H1>" >> $HTMLOUT

LIST=""
for FILE in `find -path "./lib/*.pm" -o -wholename "./src/main/scripts/*.pl"`
do
	I="0"
	for LINE in `grep -n "################################" $FILE | sed -e 's/^\([0-9]\+\).*$/\1/g'`
	do
		if [[ "$I" == "0" ]]
		then
			FIRSTLINE=$LINE;
		else
			if [[ "$I" == "1" ]]
			then
				LASTLINE=$LINE;
			fi
		fi
		
		I=$((I+1))
	done


	echo "Extraction de $FIRSTLINE a $LASTLINE pour le fichier $FILE"

	echo "<H3>`echo $FILE | sed -e 's#\./src/main/scripts/##g' | sed -e 's#\./lib/##g' | sed -e 's#/#.#g'`</H3>" >> $HTMLOUT
	echo "`head -$((LASTLINE-1)) $FILE | tail -$((LASTLINE-FIRSTLINE-1)) | sed -e 's/$/<BR>/g' | sed -e 's/#//g'`" >> $HTMLOUT
	echo "<BR><BR>" >> $HTMLOUT
done

echo "</BODY>" >> $HTMLOUT
echo "</HTML>" >> $HTMLOUT

