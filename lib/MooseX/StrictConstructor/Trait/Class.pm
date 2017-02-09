package MooseX::StrictConstructor::Trait::Class;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.20';

use Moose::Role;

use B ();

around new_object => sub {
    my $orig     = shift;
    my $self     = shift;
    my $params   = @_ == 1 ? $_[0] : {@_};
    my $instance = $self->$orig(@_);

    my %attrs = (
        __INSTANCE__ => 1,
        (
            map { $_ => 1 }
            grep {defined}
            map  { $_->init_arg() } $self->get_all_attributes()
        )
    );

    my @bad = sort grep { !$attrs{$_} } keys %$params;

    if (@bad) {
        $self->throw_error(
            "Found unknown attribute(s) init_arg passed to the constructor: @bad"
        );
    }

    return $instance;
};

around _inline_BUILDALL => sub {
    my $orig = shift;
    my $self = shift;

    my @source = $self->$orig();

    my @attrs = (
        '__INSTANCE__ => 1,',
        map      { B::perlstring($_) . ' => 1,' }
            grep {defined}
            map  { $_->init_arg() } $self->get_all_attributes()
    );

    return (
        @source,
        'my @bad = sort grep { !$allowed_attrs{$_} } keys %{ $params };',
        'if (@bad) {',
        'Moose->throw_error("Found unknown attribute(s) passed to the constructor: @bad");',
        '}',
    );
    }
    if $Moose::VERSION >= 1.9900;

around _eval_environment => sub {
    my $orig = shift;
    my $self = shift;

    my $env = $self->$orig();

    my %attrs = map { $_ => 1 }
        grep {defined}
        map  { $_->init_arg() } $self->get_all_attributes();

    $attrs{__INSTANCE__} = 1;

    $env->{'%allowed_attrs'} = \%attrs;

    return $env;
    }
    if $Moose::VERSION >= 1.9900;

1;

# ABSTRACT: A role to make immutable constructors strict

__END__

=pod

=head1 DESCRIPTION

This role simply wraps C<_inline_BUILDALL()> (from
C<Moose::Meta::Class>) so that immutable classes have a
strict constructor.

=cut
