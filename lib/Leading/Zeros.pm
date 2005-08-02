package Leading::Zeros;

use version; $VERSION = qv('0.0.2');

use warnings;
use strict;
use Carp;
use overload;

sub import {
    my ($package, @flags) = @_;
    my $converting_to_decimals = !grep { m/\A -warning \z /xms } @flags;
    overload::constant (
        binary => sub {
            my ($raw, $cooked) = @_;
            my ($octal_flag, $digits) = $raw =~ m/\A (0+) (\d+) \z/xms
                or return $cooked;  # since it must have been a hexadecimal

            return 0+$digits if $converting_to_decimals;
                
            carp qq{Warning: octal constant $raw (decimal value: $cooked) used};
            return $cooked;
        },
    );
}

sub unimport {
    overload::constant (
        binary => sub {
            my ($raw, $cooked) = @_;
            return $cooked if $raw !~ m/\A 0 \d+/xms;
            croak qq{Can't use octal constant ($raw) },
                  qq{while 'no Leading::Zeros' in effect\nError};
        },
    );
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Leading::Zeros - Defuse Perl's octal number representation


=head1 VERSION

This document describes Leading::Zeros version 0.0.2


=head1 SYNOPSIS

    no Leading::Zeros;

    my $answer = 042;       # dies

  
=head1 DESCRIPTION

This module offers some control over Perl's insidious
"leading-zero-means-octal" notation.


=head1 INTERFACE 

If the module is loaded via a C<no>:

    no Leading::Zeros;

then any subsequent attempt to use an integer constant with a leading
zero, causes an exception to be thrown. The intention is to prevent you
from doing so by accident.

If the module is loaded via a C<use>, like so:

    use Leading::Zeros;

then it silently pretends that any octal value (say, 042) was really a decimal
value (i.e. 42).

If the module is loaded with the special C<-warning> flag:

    use Leading::Zeros -warning;

then octal numbers are treated as usual (i.e. as octals), but a warning is
issued. See below.


=head1 DIAGNOSTICS

=over

=item Warning: octal constant %s (decimal value: %s) used

Under C<use Leading::Zeros -warning> you used an octal constant. It was left
as an octal value, but this is the warning you asked for.

=back


=head1 CONFIGURATION AND ENVIRONMENT

Leading::Zeros requires no configuration files or environment variables.


=head1 DEPENDENCIES

None.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-leading-zeros@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Damian Conway  C<< <DCONWAY@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005, Damian Conway C<< <DCONWAY@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
