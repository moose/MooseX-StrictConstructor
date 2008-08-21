package MooseX::StrictConstructor;

use strict;
use warnings;

our $VERSION = '0.06_01';
$VERSION = eval $VERSION;

use Class::MOP ();
use Moose ();
use Moose::Exporter;
use MooseX::StrictConstructor::Role::Object;
use MooseX::StrictConstructor::Role::Metaclass;

Moose::Exporter->setup_import_methods( also => 'Moose' );

sub init_meta
{
    shift;
    my %p = @_;

    Moose->init_meta(%p);

    my $caller = $p{for_class};

    my $metameta = $caller->meta()->meta();
    unless ( $metameta->can('does_role')
             && $metameta->does_role( 'MooseX::StrictConstructor::Role::Metaclass' ) )
    {
        my $new_meta =
            Moose::Meta::Class->create_anon_class
                ( superclasses => [ ref $caller->meta() ],
                  roles        => [ 'MooseX::StrictConstructor::Role::Metaclass' ],
                  cache        => 1,
                );

        Class::MOP::remove_metaclass_by_name($caller);

        $new_meta->name()->initialize($caller);
    }

    unless ( $caller->meta()->does_role('MooseX::StrictConstructor::Role::Object') )
    {
        my $new_base =
            Moose::Meta::Class->create_anon_class
                ( superclasses => [ $caller->meta()->superclasses() ],
                  roles        => [ 'MooseX::StrictConstructor::Role::Object' ],
                  cache        => 1,
                );

        $caller->meta()->superclasses( $new_base->name() );
    }

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

You may find yourself wanting to accept a parameter to the constructor
that is not the name of an attribute.

In that case, you'll probably be writing a C<BUILD()> method to deal
with it. Your C<BUILD()> method will receive two parameters, the new
object, and a hash reference of parameters passed to the constructor.

If you delete keys from this hash reference, then they will not be
seen when this class does its checking.

  sub BUILD {
      my $self   = shift;
      my $params = shift;

      if ( delete $params->{do_something} ) {
          ...
      }
  }

=head2 Caveats

Using this class replaces the default Moose meta class,
C<Moose::Meta::Class>, with its own,
C<MooseX::StrictConstructor::Meta::Class>. If you have your own meta
class, this distro will probably not work for you.

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-strictconstructor@rt.cpan.org>, or through the web
interface at L<http://rt.cpan.org>.  I will be notified, and then
you'll automatically be notified of progress on your bug as I make
changes.

=head1 COPYRIGHT & LICENSE

Copyright 2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
