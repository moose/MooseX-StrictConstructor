package MooseX::StrictConstructor::Trait::Method::Constructor;

use Moose::Role;

use namespace::autoclean;

use B ();

around _generate_BUILDALL => sub {
    my $orig = shift;
    my $self = shift;

    my $source = $self->$orig();
    $source .= ";\n" if $source;

    my @attrs = ('__INSTANCE__ => 1,','__no_BUILD__ => 1,');
    push @attrs, map { B::perlstring($_) . ' => 1,' }
        grep { defined }
        map  { $_->init_arg() } @{ $self->_attributes() };

    $source .= <<"EOF";
my \%attrs = (@attrs);

my \@bad = sort grep { ! \$attrs{\$_} }  keys \%{ \$params };

if (\@bad) {
    Moose->throw_error("Found unknown attribute(s) passed to the constructor: \@bad");
}
EOF

    return $source;
} if $Moose::VERSION < 1.9900;

1;

# ABSTRACT: A role to make immutable constructors strict

__END__

=pod

=head1 DESCRIPTION

This role simply wraps C<_generate_BUILDALL()> (from
C<Moose::Meta::Method::Constructor>) so that immutable classes have a
strict constructor.

=cut

