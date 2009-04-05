package MooseX::StrictConstructor::Role::Object;

use strict;
use warnings;

use Moose::Role;


after 'BUILDALL' => sub
{
    my $self   = shift;
    my $params = shift;

    my %attrs =
        ( map { $_ => 1 }
          grep { defined }
          map { $_->init_arg() }
          $self->meta()->get_all_attributes()
        );

    my @bad = sort grep { ! $attrs{$_} }  keys %{ $params };

    if (@bad)
    {
        confess "Found unknown attribute(s) init_arg passed to the constructor: @bad";
    }

    return;
};

no Moose::Role;

1;

__END__

=pod

=head1 NAME

MooseX::StrictConstructor::Role::Object - A role which implements a strict constructor for Moose::Object

=head1 SYNOPSIS

  Moose::Util::MetaRole::apply_base_class_roles
      ( for_class => $caller,
        roles =>
        [ 'MooseX::StrictConstructor::Role::Object' ],
      );

=head1 DESCRIPTION

When you use C<MooseX::StrictConstructor>, your objects will have this
role applied to them. It provides a method modifier for C<BUILDALL()>
from C<Moose::Object> that implements strict argument checking for
your class.

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007-2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
