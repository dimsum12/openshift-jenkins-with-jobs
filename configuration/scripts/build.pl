use strict;
use warnings;
use Module::Build;

use lib 'lib';

my $class = Module::Build->subclass(
    class => 'Module::Build::Custom',
    code => <<'SUBCLASS' );

sub ACTION_junit_test {
    my $self = shift;

    $self->depends_on("build");
    # set junit mode
    $self->{JUNIT_MODE} = 1;
    $self->generic_test(type => 'default');
}

sub do_tests {
  my $self = shift;

  # if we are not running in junit mode, just execute normal test routine (parent)
  $self->{JUNIT_MODE}
    or return $self->SUPER::do_tests($self, @_);

  # We are in JUnit mode, use TAP::Harness::JUnit
  my $tests = $self->find_test_files;
  if(@$tests) {
    $self->run_tap_harness_JUnit($tests);
  } else {
    $self->log_info("No tests defined.\n");
  }
}

sub run_tap_harness_JUnit {
  my ($self, $tests) = @_;

  print "------ JUnit tap harness \n";
  require TAP::Harness::JUnit;

  my $harness = TAP::Harness::JUnit->new({
    xmlfile => 'surefire.tmp',
    merge => 1,
    lib => [@INC],
    verbosity => $self->{properties}{verbose},
    switches => [ $self->harness_switches ],
    namemangle => 'none',
    %{ $self->tap_harness_args },
  })->runtests(@$tests);

}

SUBCLASS

# here, instead of instantiating from Module::Build, we use our new class

my $builder = $class->new(
    dist_name		 => 'entrepot',
    dist_version	 => '1.0',
    license              => 'perl',
    dist_author          => 'Julien Perrot <julien.perrot@atos.net>',
    test_files           => 'src/test/scripts/**',
    recursive_test_files => 'true',
    test_file_exts       => [qw(.t)],
    build_requires => {
        'Test::Simple' => '0.98',
	'Test::More' => '0.10',
    },
);

$builder->create_build_script();
