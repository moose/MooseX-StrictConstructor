use strict;
use warnings;

require 5.008;

use Module::Build;

my $builder = Module::Build->new
    ( module_name        => 'MooseX::StrictConstructor',
      license            => 'perl',
      requires           => { 'Moose'      => '0.74',
                              'Test::More' => '0',
                            },
      create_makefile_pl => 'passthrough',
      create_readme      => 1,
      sign               => 1,
    );

$builder->create_build_script();
