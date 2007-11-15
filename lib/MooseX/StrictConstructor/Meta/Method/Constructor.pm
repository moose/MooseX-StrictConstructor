package MooseX::StrictConstructor::Meta::Method::Constructor;

use strict;
use warnings;

use Moose;

extends 'Moose::Meta::Method::Constructor';

sub _generate_BUILDALL ## no critic RequireArgUnpacking
{
    my $self = shift;

    my $calls = $self->SUPER::_generate_BUILDALL(@_);

    $calls .= <<'EOF';
    my %attrs = map { $_->name() => 1 } $self->meta()->compute_all_applicable_attributes();

    my @bad = sort grep { ! $attrs{$_} }  keys %params;

    if (@bad)
    {
        confess "Found unknown attribute(s) passed to the constructor: @bad";
    }
EOF

    return $calls;
};


1;
