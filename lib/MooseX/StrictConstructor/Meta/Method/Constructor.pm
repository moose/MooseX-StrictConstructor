package MooseX::StrictConstructor::Meta::Method::Constructor;

use strict;
use warnings;

use Carp ();
use Moose;

extends 'Moose::Meta::Method::Constructor';

override '_generate_BUILDALL' => sub
{
    my $self = shift;

    my $source = super();
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

no Moose;


1;

__END__

=pod

=head1 NAME

MooseX::StrictConstructor::Meta::Method::Constructor - A meta class to make immutable constructors strict

=head1 SYNOPSIS

  use MooseX::StrictConstructor;

=head1 DESCRIPTION

This class simply overrides C<_generate_BUILDALL()> in
C<Moose::Meta::Method::Constructor> so that classes that are made
immutable have a strict constructor.

You should never have to use this class directly.

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

