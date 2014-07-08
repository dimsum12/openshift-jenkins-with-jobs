#/bin/bash

WORKSPACE=$(cd $(dirname $0) && pwd)
cd $WORKSPACE


PERL_COMMAND="perl"


PERLCODE="BEGIN { push @INC, \"lib\"; }; use Cwd; use Config::Simple;  our \$config = Config::Simple->new( \"$WORKSPACE/src/main/config/local/config_perl.ini\" ) or croak Config::Simple->error() ;  use Classpath; Classpath->load(); require '"$1".pl'; exit $1("
shift

while [ ! -z "$1" ]
do
	PERLCODE=$PERLCODE"\""$1"\""
	
	if [ ! -z "$2" ]
	then
		PERLCODE=$PERLCODE", "
	fi
	
	shift
done

PERLCODE=$PERLCODE");"


#echo "Execution de $PERLCODE en perl"
$PERL_COMMAND -e "$PERLCODE"
RETURNVALUE=$?

exit $RETURNVALUE
