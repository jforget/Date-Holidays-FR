# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
#     Perl module to compute the French holidays in a given year.
#     Copyright © 2004, 2019 Fabien Potencier and Jean Forget, all rights reserved
#
#     See the license in the embedded documentation below.
#
package Date::Holidays::FR;

use utf8;
use strict;
use warnings;
use Time::Local;
use Date::Easter;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(is_fr_holiday is_holiday holidays fr_holidays);

our $VERSION = '0.04';

sub get_easter {
        my ($year) = @_;

        return Date::Easter::easter($year);
}

sub get_ascension {
        my ($year) = @_;

        return _compute_date_from_easter($year, 39);
}

sub get_pentecost {
        my ($year) = @_;

        return _compute_date_from_easter($year, 50);
}

sub _compute_date_from_easter {
        my ($year, $delta) = @_;

        my ($easter_month, $easter_day) = get_easter($year);
        my $easter_date = Time::Local::timelocal(0, 0, 1, $easter_day, $easter_month - 1, $year - 1900);
        my ($date_month, $date_day) = (localtime($easter_date + $delta * 86400))[4, 3];
        $date_month++;

        return ($date_month, $date_day);
}

sub is_holiday {
    return is_fr_holiday(@_);
}

sub is_fr_holiday {
    my ($year, $month, $day) = @_;

    my $date = sprintf('%02d', $month) . sprintf('%02d', $day);
    my $dates = _get_dates($year);

    return $dates->{$date} || 0;
}

sub holidays {
    return fr_holidays(shift);
}

sub fr_holidays {
        my $year = shift;

        my $holidays = {};

        my $dates = _get_dates($year);

        foreach my $date (keys %{$dates}) {
            my ($month, $day) = $date =~ m/(\d{2})(\d{2})/;

            my $holiday = is_fr_holiday($year, $month, $day);

            if ($holiday) {
                $holidays->{$date} = $holiday;
            }
        };

        return $holidays;
}

sub _get_dates {
    my $year = shift;

    my $dates = {
        '0101' => 'Nouvel an',
        '0501' => 'Fête du travail',
        '0508' => 'Armistice 1939-1945',
        '0714' => 'Fête nationale',
        '0815' => 'Assomption',
        '1101' => 'Toussaint',
        '1111' => 'Armistice 1914-1918',
        '1225' => 'Noël',
    };

    my ($easter_month,    $easter_day)    = _compute_date_from_easter($year,  1);
    my ($ascension_month, $ascension_day) = _compute_date_from_easter($year, 39);
    my ($pentecost_month, $pentecost_day) = _compute_date_from_easter($year, 50);

    $dates->{sprintf('%02d', $easter_month) . sprintf('%02d', $easter_day)} = 'Lundi de Pâques';
    $dates->{sprintf('%02d', $ascension_month) . sprintf('%02d', $ascension_day)} = 'Ascension';
    $dates->{sprintf('%02d', $pentecost_month) . sprintf('%02d', $pentecost_day)} = 'Lundi de Pentecôte';

    return $dates;
}

# And instead of a plain, boring "1" to end the module source, let us
# celebrate the 14th of July, closely associated with the Bastille:

"-- À la Bastille on l'aime bien Nini Peau-d'chien,
    Elle est si douce et si gentille !
    On l'aime bien...
 -- QUI ÇA ?
 -- Nini Peau-d'chien...
 -- OÙ ÇA ?
 -- À la Basti-i-ille";

__END__

=encoding utf-8

=head1 NAME

Date::Holidays::FR - Determine French holidays

=head1 SYNOPSIS

  use Date::Holidays::FR;
  my ($year, $month, $day) = (localtime)[5, 4, 3];
  $year  += 1900;
  $month +=    1;
  print "Woohoo" if is_fr_holiday($year, $month, $day);

  my ($month, $day) = get_easter($year);
  my ($month, $day) = get_ascension($year);
  my ($month, $day) = get_pentecost($year);

=head1 DESCRIPTION

is_fr_holiday method return true value when the day is holiday.

There are 11 holidays in France:

=over 4

=item * 1er janvier : Nouvel an

=item * Lundi de Pâques

=item * 1er mai : Fête du travail

=item * 8 mai : Armistice 1939-1945

=item * Ascension

=item * Lundi de Pentecôte

=item * 14 juillet : Fête nationale

=item * 15 août : Assomption

=item * 1er novembre : Toussaint

=item * 11 novembre : Armistice 1914-1918

=item * 25 décembre : Noël

=back

Easter is computed with L<Date::Easter> module.

Ascension is 39 days after Easter.

Pentecost monday is 50 days after Easter.

=head1 SUBROUTINES

=head2 is_fr_holiday($year, $month, $day)

Returns the name of the holiday in french that falls on the given day,
or undef if there is none.

=head2 get_easter($year)

Returns the month and day of easter day for the given year.

=head2 get_ascension($year)

Returns the month and day of ascension day for the given year.

=head2 get_pentecost($year)

Returns the month and day of pentecost day for the given year.

=head1 SUPPORT

Please  report   any  requests,  suggestions   or  bugs  via   the  RT
bug-tracking   system   at   L<https://rt.cpan.org/>   or   email   to
bug-Date-Holidays-FR\@rt.cpan.org.

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays-FR>  is  the
RT queue for  Date::Holidays::FR. Please check to see if  your bug has
already been reported.

Or you  can go to  L<https://github.com/jforget/Date-Holidays-FR>, and
submit a pull request.

=head1 AUTHORS

Module creator: Fabien Potencier

Current maintainer: Jean Forget (JFORGET at cpan dot org)

=head1 LICENSE

Copyright ©  2004, 2019 Fabien  Potencier and Jean Forget.  All rights
reserved.  This program  is  free software;  you  can redistribute  it
and/or  modify it  under the  same terms  as Perl  itself: GNU  Public
License version 1 or later and Perl Artistic License.

The full text of the license can be found in the F<LICENSE> file
included with this module or at
L<https://dev.perl.org/licenses/artistic.html>
and L<https://www.gnu.org/licenses/gpl-1.0.html>.

Here is the summary of GPL:

This program is  free software; you can redistribute  it and/or modify
it under the  terms of the GNU General Public  License as published by
the Free  Software Foundation; either  version 1, or (at  your option)
any later version.

This program  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.

You should  have received  a copy  of the  GNU General  Public License
along with this program;  if not, see L<https://www.gnu.org/licenses/>
or contact the Free Software Foundation, Inc., L<https://fsf.org>.

=head1 SEE ALSO

perl(1), L<Date::Holidays::UK>, L<Date::Holidays::DE>.

=cut
