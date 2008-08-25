package MooseX::StrictConstructor::Role::Meta::Method::Constructor;

use strict;
use warnings;

use Carp ();

use Moose::Role;

around '_generate_BUILDALL' => sub
{
    my $orig = shift;
    my $self = shift;

    my $source = $self->$orig();
    $source .= ";\n" if $source;

    my @attrs =
        ( map { "$_ => 1," }
          grep { defined }
          map { $_->init_arg() }
          @{ $self->attributes() }
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

__END__

=pod

=head1 NAME

MooseX::StrictConstructor::Role::Meta::Method::Constructor - A role to make immutable constructors strict

=head1 SYNOPSIS

  use MooseX::StrictConstructor;

=head1 DESCRIPTION

This role simply wraps C<_generate_BUILDALL()> (from
C<Moose::Meta::Method::Constructor>) so that immutable classes have a
strict constructor.

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007-2008 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

