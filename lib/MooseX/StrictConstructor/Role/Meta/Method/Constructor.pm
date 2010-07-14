package MooseX::StrictConstructor::Role::Meta::Method::Constructor;

use strict;
use warnings;

use Carp ();

use Moose::Role;

around '_generate_BUILDALL' => sub {
    my $orig = shift;
    my $self = shift;

    my $source = $self->$orig();
    $source .= ";\n" if $source;

    my @attrs = (
        map  {"$_ => 1,"}
        grep {defined}
        map  { $_->init_arg() } @{ $self->_attributes() }
    );

    $source .= <<"EOF";
my \%attrs = (@attrs);

my \@bad = sort grep { ! \$attrs{\$_} }  keys \%{ \$params };

if (\@bad) {
    Carp::confess "Found unknown attribute(s) passed to the constructor: \@bad";
}
EOF

    return $source;
};

no Moose::Role;

1;

# ABSTRACT: A role to make immutable constructors strict

__END__

=pod

=head1 SYNOPSIS

  Moose::Util::MetaRole::apply_metaclass_roles
      ( for_class => $caller,
        constructor_class_roles =>
        ['MooseX::StrictConstructor::Role::Meta::Method::Constructor'],
      );

=head1 DESCRIPTION

This role simply wraps C<_generate_BUILDALL()> (from
C<Moose::Meta::Method::Constructor>) so that immutable classes have a
strict constructor.

=cut

