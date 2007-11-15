package MooseX::Object::StrictConstructor;

use strict;
use warnings;

use Moose;

use Carp 'confess';

extends 'Moose::Object';

after 'BUILDALL' => sub
{
    my $self   = shift;
    my $params = shift;

    my %attrs = map { $_->name() => 1 } $self->meta()->compute_all_applicable_attributes();

    my @bad = grep { ! $attrs{$_} } keys %{ $params };

    if (@bad)
    {
        confess "Found unknown attribute(s) passed to the constructor: @bad";
    }

    return;
};


1;
