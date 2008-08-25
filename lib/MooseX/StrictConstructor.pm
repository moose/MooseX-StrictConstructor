package MooseX::StrictConstructor;

use strict;
use warnings;

our $VERSION = '0.06_01';
$VERSION = eval $VERSION;

use Class::MOP ();
use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use MooseX::StrictConstructor::Role::Object;
use MooseX::StrictConstructor::Role::Meta::Method::Constructor;

Moose::Exporter->setup_import_methods( also => 'Moose' );

sub init_meta
{
    shift;
    my %p = @_;

    Moose->init_meta(%p);

    my $caller = $p{for_class};

    Moose::Util::MetaRole::apply_metaclass_roles
        ( for_class => $caller,
          constructor_class_roles =>
          ['MooseX::StrictConstructor::Role::Meta::Method::Constructor'],
        );

    Moose::Util::MetaRole::apply_base_class_roles
        ( for_class => $caller,
          roles =>
          [ 'MooseX::StrictConstructor::Role::Object' ],
        );

    return $caller->meta();
}

1;

__END__

=pod

=head1 NAME

MooseX::StrictConstructor - Make your object constructors blow up on unknown attributes

=head1 SYNOPSIS

    package My::Class;

    use MooseX::StrictConstructor; # instead of use Moose

    has 'size' => ...;

    # then later ...

    # this blows up because color is not a known attribute
    My::Class->new( size => 5, color => 'blue' );

=head1 DESCRIPTION

Using this class to load Moose instead of just loading using Moose
itself makes your constructors "strict". If your constructor is called
with an attribute init argument that your class does not declare, then
it calls "Carp::confess()". This is a great way to catch small typos.

=head2 Subverting Strictness

You may find yourself wanting to have your constructor accept a
parameter which does not correspond to an attribute.

In that case, you'll probably also be writing a C<BUILD()> or
C<BUILDARGS()> method to deal with that parameter. In a C<BUILDARGS()>
method, you can simply make sure that this parameter is not included
in the hash reference you return. Otherwise, in a C<BUILD()> method,
you can delete it from the hash reference of parameters.

  sub BUILD {
      my $self   = shift;
      my $params = shift;

      if ( delete $params->{do_something} ) {
          ...
      }
  }

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-strictconstructor@rt.cpan.org>, or through the web
interface at L<http://rt.cpan.org>.  I will be notified, and then
you'll automatically be notified of progress on your bug as I make
changes.

=head1 COPYRIGHT & LICENSE

Copyright 2007-2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
