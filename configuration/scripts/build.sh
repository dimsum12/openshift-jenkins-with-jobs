# Initialisation des variables
export PATH=$PATH":/usr/local/bin"

WORKSPACE=$1
PRJ=$2
VERSION=$3

OUT="/DATA/pkg/"$PRJ
TMP="/tmp/build-"$PRJ


# Packaging des scripts
mkdir -p $OUT
rm -rf $TMP
mkdir -p $TMP

# Config Qualif
mkdir -p $TMP"/QUALIF-MIDDLE-"$PRJ"-"$VERSION"/src/main/config"
cp -r $WORKSPACE"/src/main/config/qualif" $TMP"/QUALIF-MIDDLE-"$PRJ"-"$VERSION"/src/main/config/local"
cd $TMP"/QUALIF-MIDDLE-"$PRJ"-"$VERSION""
tar -czf $OUT"/QUALIF-MIDDLE-"$PRJ"-"$VERSION".tar.gz" "."
rm -rf $TMP"/QUALIF-MIDDLE-"$PRJ"-"$VERSION

# Config Preprod
mkdir -p $TMP"/PREPROD-MIDDLE-"$PRJ"-"$VERSION"/src/main/config"
cp -r $WORKSPACE"/src/main/config/preprod" $TMP"/PREPROD-MIDDLE-"$PRJ"-"$VERSION"/src/main/config/local"
cd $TMP"/PREPROD-MIDDLE-"$PRJ"-"$VERSION""
tar -czf $OUT"/PREPROD-MIDDLE-"$PRJ"-"$VERSION".tar.gz" "."
rm -rf $TMP"/PREPROD-MIDDLE-"$PRJ"-"$VERSION

# Config Prod
mkdir -p $TMP"/PROD-MIDDLE-"$PRJ"-"$VERSION"/src/main/config"
cp -r $WORKSPACE"/src/main/config/prod" $TMP"/PROD-MIDDLE-"$PRJ"-"$VERSION"/src/main/config/local"
cd $TMP"/PROD-MIDDLE-"$PRJ"-"$VERSION""
tar -czf $OUT"/PROD-MIDDLE-"$PRJ"-"$VERSION".tar.gz" "."
rm -rf $TMP"/PROD-MIDDLE-"$PRJ"-"$VERSION

# Config Prod EMAP
mkdir -p $TMP"/PROD-MIDDLE-emap-"$VERSION"/src/main/config"
cp -r $WORKSPACE"/src/main/config/prod" $TMP"/PROD-MIDDLE-emap-"$VERSION"/src/main/config/local"
cd $TMP"/PROD-MIDDLE-emap-"$VERSION""
tar -czf $OUT"/PROD-MIDDLE-emap-"$VERSION".tar.gz" "."
rm -rf $TMP"/PROD-MIDDLE-emap-"$VERSION

# package MIDDLE
mkdir -p $TMP"/MIDDLE-"$PRJ"-"$VERSION"/src/main"
cp -r $WORKSPACE/lib $TMP"/MIDDLE-"$PRJ"-"$VERSION"/"
cp -r $WORKSPACE/Exec.sh $TMP"/MIDDLE-"$PRJ"-"$VERSION"/"
cp -r $WORKSPACE/src/main/scripts $TMP"/MIDDLE-"$PRJ"-"$VERSION"/src/main/"
cp -r $WORKSPACE/src/main/resources $TMP"/MIDDLE-"$PRJ"-"$VERSION"/src/main/"
cd $TMP"/MIDDLE-"$PRJ"-"$VERSION""
tar -czf $OUT"/MIDDLE-"$PRJ"-"$VERSION".tar.gz" "."
rm -rf $TMP"/MIDDLE-"$PRJ"-"$VERSION

# Package MIDDLE-EMAP
mkdir -p $TMP"/MIDDLE-emap-"$VERSION"/src/main/scripts"
mkdir -p $TMP"/MIDDLE-emap-"$VERSION"/src/main/resources"
cp -r $WORKSPACE/lib $TMP"/MIDDLE-emap-"$VERSION"/"
cp -r $WORKSPACE/Exec.sh $TMP"/MIDDLE-emap-"$VERSION"/"
cp -r $WORKSPACE/src/main/scripts/fr/geoportail/entrepot/scripts/emap/* $TMP"/MIDDLE-emap-"$VERSION"/src/main/scripts/"
cp -r $WORKSPACE/src/main/resources/emap/* $TMP"/MIDDLE-emap-"$VERSION"/src/main/resources/"
cd $TMP"/MIDDLE-emap-"$VERSION""
tar -czf $OUT"/MIDDLE-emap-"$VERSION".tar.gz" "."
rm -rf $TMP"/MIDDLE-emap-"$VERSION

# Execution des tests
rm -rf $WORKSPACE/src/main/config/local
cp -r $WORKSPACE/src/main/config/dev $WORKSPACE/src/main/config/local
rm -rf $WORKSPACE/src/test/config/local
cp -r $WORKSPACE/src/test/config/dev $WORKSPACE/src/test/config/local
cd $WORKSPACE
perl $WORKSPACE/build.pl

# Qualité du code perl
bash $WORKSPACE"/quality_code.sh"

# Generation de la doc PERL
bash $WORKSPACE"/create_perldoc.sh"

# Création des rapports surefire pour les quality plans
bash $WORKSPACE"/create-surefire-reports.sh"

if [ $? -ne 0 ]
then
	exit 1;
fi
