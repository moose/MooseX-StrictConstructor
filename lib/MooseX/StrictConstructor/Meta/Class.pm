package MooseX::StrictConstructor::Meta::Class;

use strict;
use warnings;

use base 'Moose::Meta::Class';

use MooseX::StrictConstructor::Meta::Method::Constructor;


sub make_immutable { ## no critic RequireArgUnpacking
    my $self = shift;

    return
        $self->SUPER::make_immutable
            ( constructor_class => 'MooseX::StrictConstructor::Meta::Method::Constructor',
              @_
            );
}


1;
