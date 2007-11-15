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

__END__

=pod

=head1 NAME

MooseX::Object::StrictConstructor - Implements strict constructors as a Moose::Object subclass

=head1 DESCRIPTION

This class has no external interface. When you use
C<MooseX::StrictConstructor>, your objects will subclass this class
rather than Moose::Object.

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
