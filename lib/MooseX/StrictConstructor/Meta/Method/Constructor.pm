package MooseX::StrictConstructor::Meta::Method::Constructor;

use strict;
use warnings;

use Carp ();
use Moose;

extends 'Moose::Meta::Method::Constructor';

# using 
sub _generate_BUILDALL ## no critic RequireArgUnpacking
{
    my $self = shift;

    my $source = $self->SUPER::_generate_BUILDALL(@_);
    $source .= ";\n" if $source;

    my @attrs = map { $_->name() . ' => 1,' } @{ $self->attributes() };

    $source .= <<"EOF";
my \%attrs = (@attrs);

my \@bad = sort grep { ! \$attrs{\$_} }  keys \%params;

if (\@bad) {
    Carp::confess "Found unknown attribute(s) passed to the constructor: \@bad";
}
EOF

    return $source;
};


1;
