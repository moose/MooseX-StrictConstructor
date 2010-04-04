use strict;
use warnings;

use Test::Exception;
use Test::Moose qw( with_immutable );
use Test::More;

{
    package Standard;

    use Moose;

    has 'thing' => ( is => 'rw' );
}

{
    package Stricter;

    use Moose;
    use MooseX::StrictConstructor;

    has 'thing' => ( is => 'rw' );
}

{
    package Subclass;

    use Moose;
    use MooseX::StrictConstructor;

    extends 'Stricter';

    has 'size' => ( is => 'rw' );
}

{
    package Tricky;

    use Moose;
    use MooseX::StrictConstructor;

    has 'thing' => ( is => 'rw' );

    sub BUILD {
        my $self   = shift;
        my $params = shift;

        delete $params->{spy};
    }
}

{
    package InitArg;

    use Moose;
    use MooseX::StrictConstructor;

    has 'thing' => ( is => 'rw', 'init_arg' => 'other' );
    has 'size'  => ( is => 'rw', 'init_arg' => undef );
}

my @classes = qw( Standard Stricter Subclass Tricky InitArg );

with_immutable {
    lives_ok { Standard->new( thing => 1, bad => 99 ) }
    'standard Moose class ignores unknown params';

    throws_ok { Stricter->new( thing => 1, bad => 99 ) }
    qr/unknown attribute.+: bad/,
        'strict constructor blows up on unknown params';

    lives_ok { Subclass->new( thing => 1, size => 'large' ) }
    'subclass constructor handles known attributes correctly';

    throws_ok { Subclass->new( thing => 1, bad => 99 ) }
    qr/unknown attribute.+: bad/,
        'subclass correctly recognizes bad attribute';

    lives_ok { Tricky->new( thing => 1, spy => 99 ) }
    'can work around strict constructor by deleting params in BUILD()';

    throws_ok { Tricky->new( thing => 1, agent => 99 ) }
    qr/unknown attribute.+: agent/,
        'Tricky still blows up on unknown params other than spy';

    throws_ok { Subclass->new( thing => 1, bad => 99 ) }
    qr/unknown attribute.+: bad/,
        'subclass constructor blows up on unknown params';

    throws_ok { InitArg->new( thing => 1 ) }
    qr/unknown attribute.+: thing/,
        'InitArg blows up with attribute name';

    throws_ok { InitArg->new( size => 1 ) }
    qr/unknown attribute.+: size/,
        'InitArg blows up when given attribute with undef init_arg';

    lives_ok { InitArg->new( other => 1 ) }
    'InitArg works when given proper init_arg';
} @classes;

done_testing();
