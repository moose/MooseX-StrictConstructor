package MooseX::StrictConstructor::Role::Metaclass;

use strict;
use warnings;

use MooseX::StrictConstructor::Meta::Method::Constructor;

use Moose::Role;


around 'make_immutable' => sub ## no critic RequireArgUnpacking
{
    my $orig = shift;
    my $self = shift;

    return
        $self->$orig
            ( constructor_class => 'MooseX::StrictConstructor::Meta::Method::Constructor',
              @_,
            );
};

no Moose::Role;


1;

__END__

=pod

=head1 NAME

MooseX::StrictConstructor::Meta::Class - A meta class for classes with strict constructors

=head1 SYNOPSIS

  use MooseX::StrictConstructor;

=head1 DESCRIPTION

This class simply overrides C<make_immutable()> in
C<Moose::Meta::Class> to use
C<MooseX::StrictConstructor::Meta::Method::Constructor> as the
constructor class.

You should never have to use this class directly.

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
