# !/usr/bin/perl

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 5;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Logger;
use Execute;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $tmp_path = $config->param("resources.tmp.path");


require  "packaging.pl";

my $test_packaging_source = $tmp_path . "/test_packaging_source";
system("mkdir " . $test_packaging_source);
system("touch " . $test_packaging_source . "/file1");
system("touch " . $test_packaging_source . "/file2");
system("touch " . $test_packaging_source . "/file3");

my $test_packaging_target = $tmp_path . "/test_packaging_target";




ok(packaging() == 255, "testWithoutParameters");	


ok(packaging( $test_packaging_source, $test_packaging_target, "mon_zip", 1) == 0, "testPackagingOk");
system("rm -f " . $test_packaging_target . "/mon_zip.7z*");


{
	local *create_md5 = sub { return 1; };
	ok(packaging( $test_packaging_source, $test_packaging_target, "mon_zip", 1) == 1, "testErrorCalculatingInternMd5");
	system("rm -f " . $test_packaging_target . "/mon_zip.7z*");
}


{
	local *zip_folder = sub { return 1; };
	ok(packaging( $test_packaging_source, $test_packaging_target, "mon_zip", 1) == 2, "testErrorCompression7z");
	system("rm -f " . $test_packaging_target . "/mon_zip.7z*");
}


{
	our $mocked_value = -1;
	local *create_md5 = sub { $mocked_value = $mocked_value + 1; return $mocked_value; };
	ok(packaging( $test_packaging_source, $test_packaging_target, "mon_zip", 1) == 3, "testErrorCalculatingExternMd5");	
	system("rm -f " . $test_packaging_target . "/mon_zip.7z*");
}

