package MooseX::StrictConstructor;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose;
use MooseX::Object::StrictConstructor;


sub import
{
    my $caller = caller();

    return if $caller eq 'main';

    Moose::init_meta( $caller, 'MooseX::Object::StrictConstructor', 'Moose::Meta::Class' );

    Moose->import( { into => $caller } );

    return;
}



1;

__END__

=pod

=head1 NAME

MooseX::StrictConstructor - The fantastic new MooseX::StrictConstructor!

=head1 SYNOPSIS

XXX - change this!

    use MooseX::StrictConstructor;

    my $foo = MooseX::StrictConstructor->new();

    ...

=head1 DESCRIPTION

=head1 METHODS

This class provides the following methods

=head1 AUTHOR

Dave Rolsky, C<< <autarch@urth.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-strictconstructor@rt.cpan.org>,
or through the web interface at L<http://rt.cpan.org>.  I will be
notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
