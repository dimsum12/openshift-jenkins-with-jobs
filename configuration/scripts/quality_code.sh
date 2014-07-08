#!/bin/bash

if [[ $# > 0 ]]
then
	if [[ $1 != "DEBUG" ]]
	then
		echo "Perltidy sur le fichier $1"
		perltidy -b $1
		rm -f $1.bak
		perlcritic $1 --severity 1 --profile perlcritic --statistics --verbose 9
	else
		echo "Mode DEBUG enclenche"
		if [[ $2 != "1" && $2 != "2" && $2 != "3" && $2 != "4" && $2 != "5" ]]
		then
			GREPPING="violations."
		else
			GREPPING="severity "$2" violations."
		fi

		for FILE in `find -path "./lib/*.pm" -o -wholename "./src/main/scripts/*.pl"`
        	do
			echo "PerlCritic sur le fichier $FILE"
			perlcritic $FILE --severity 1 --profile perlcritic --statistics --verbose 9 | grep "$GREPPING"
		done
	fi
else
	LIST=""
	for FILE in `find -path "./lib/*.pm" -o -wholename "./src/main/scripts/*.pl"`
	do
		echo "Perltidy sur le fichier $FILE"
		perltidy -b $FILE
		rm -f $FILE.bak
		LIST=$LIST" "$FILE
	done

	perlcritic$LIST --severity 1 --profile perlcritic --statistics-only
fi
