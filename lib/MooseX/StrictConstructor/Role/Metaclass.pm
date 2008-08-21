package MooseX::StrictConstructor::Role::Metaclass;

use strict;
use warnings;

use MooseX::StrictConstructor::Meta::Method::Constructor;

use Moose::Role;

has 'constructor_class' =>
    ( is         => 'ro',
      isa        => 'ClassName',
      lazy_build => 1,
    );

sub _build_constructor_class
{
    return
        Moose::Meta::Class->create_anon_class
            ( superclasses => [ 'Moose::Meta::Method::Constructor' ],
              roles        => [ 'MooseX::StrictConstructor::Role::Constructor' ],
              cache        => 1,
            )->name();
}

# If Moose::Meta::Class had a constructor_class attribute, this
# wrapper would not be necessary.
around 'make_immutable' => sub
{
    my $orig = shift;
    my $self = shift;

    return
        $self->$orig
            ( constructor_class => $self->constructor_class(),
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
