date

echo "COMMIT des modifications locales"
hg commit -A -u entrepot -m "Commit automatique du referentiel statique"

echo "PULL du repository central"
hg pull

echo "MERGE avec les modifications exterieures"
hg merge

echo "COMMIT du merge"
hg commit -A -u entrepot -m "Merge automatique du referentiel statique"

echo "PUSH sur le repository central"
hg push

echo ""