package MooseX::StrictConstructor::Trait::Class;

use Moose::Role;

use namespace::autoclean;

use B ();

around '_inline_BUILDALL' => sub {
    my $orig = shift;
    my $self = shift;

    my @source = $self->$orig();

    my @attrs = (
        '__INSTANCE__ => 1,',
        map { B::perlstring($_) . ' => 1,' }
        grep {defined}
        map  { $_->init_arg() } $self->get_all_attributes()
    );

    return (
        @source,
        'my %attrs = (' . ( join ' ', @attrs ) . ');',
        'my @bad = sort grep { !$attrs{$_} } keys %{ $params };',
        'if (@bad) {',
            'Moose->throw_error("Found unknown attribute(s) passed to the constructor: @bad");',
        '}',
    );
};

1;

# ABSTRACT: A role to make immutable constructors strict

__END__

=pod

=head1 DESCRIPTION

This role simply wraps C<_inline_BUILDALL()> (from
C<Moose::Meta::Class>) so that immutable classes have a
strict constructor.

=cut
