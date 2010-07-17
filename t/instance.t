use strict;
use warnings;

use Test::More;
use Test::Moose qw( with_immutable );

{
    package Foo;
    use Moose;
    use MooseX::StrictConstructor;
}

with_immutable {
    eval { Foo->new( __INSTANCE__ => Foo->new ); };
    ok( !$@, '__INSTANCE__ is ignored when passed to ->new' );

    eval { Foo->meta->new_object( __INSTANCE__ => Foo->new ); };
    ok( !$@, '__INSTANCE__ is ignored when passed to ->new_object' );
}
'Foo';

done_testing();
