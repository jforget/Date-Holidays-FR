package Date::Holidays::FR;

use strict;
use warnings;
use Time::Local;
use Date::Easter;
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(is_fr_holiday);
our $VERSION = '0.01';

sub is_fr_holiday {
	my ($year, $month, $day) = @_;

	if ($day == 1 and $month == 1) { return "Nouvel an"; }
	elsif ($day == 1 and $month == 5) { return "Fête du travail"; }
	elsif ($day == 8 and $month == 5) { return "Armistice 39-45"; }
	elsif ($day == 14 and $month == 7) { return "Fête nationale"; }
	elsif ($day == 15 and $month == 8) { return "Assomption"; }
	elsif ($day == 1 and $month == 11) { return "Toussaint"; }
	elsif ($day == 11 and $month == 11) { return "Armistice 14-18"; }
	elsif ($day == 25 and $month == 12) { return "Noël"; }
	else {
		my ($easter_month, $easter_day) = Date::Easter::easter($year);
		my $easter_date = Time::Local::timelocal(0, 0, 1, $easter_day, $easter_month - 1, $year - 1900);
		my ($ascension_month, $ascension_day) = (localtime($easter_date + 39 * 86400))[4, 3];
		$ascension_month++;
		my ($pentecost_month, $pentecost_day) = (localtime($easter_date + 50 * 86400))[4, 3];
		$pentecost_month++;
		if ($day == ($easter_day + 1) and $month == $easter_month) { return "Lundi de pâques"; }
		elsif ($day == $ascension_day and $month == $ascension_month) { return "Ascension"; }
		elsif ($day == $pentecost_day and $month == $pentecost_month) { return "Pentecôte"; }
	}
}

1;

__END__

=head1 NAME

Date::Holidays::FR - Determine French holidays

=head1 SYNOPSIS

  use Date::Holidays::FR;
  my ($year, $month, $day) = (localtime)[5, 4, 3];
  $year  += 1900;
  $month += 1;
  print "Woohoo" if is_fr_holiday($year, $month, $day);

=head1 DESCRIPTION

is_fr_holiday method return true value when the day is holiday.

There is 11 holidays in France:

=over 4

=item * 1er janvier : Nouvel an

=item * Lundi de Pâques

=item * 1er mai : Fête du travail

=item * 8 mai : Armistice 39-45

=item * Ascension

=item * Pentecôte

=item * 14 juillet : Fête nationale

=item * 15 août : Assomption

=item * 1er novembre : Toussaint

=item * 11 novembre : Armistice 14-18

=item * 25 décembre : Noël

=back

Easter is computed with Date::Easter module.

Ascension is 39 days after easter.

Pentecost is 50 days after easter.

=head1 SUBROUTINES

=head2 is_fr_holiday($year, $month, $day)

Returns the name of the holiday in french that falls on the given day, or undef
if there is none.

=head1 REQUESTS & BUGS

Please report any requests, suggestions or bugs via the RT bug-tracking system 
at http://rt.cpan.org/ or email to bug-Date-Holidays-FR\@rt.cpan.org. 

http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays-FR is the RT queue for Date::Holidays::FR.
Please check to see if your bug has already been reported. 

=head1 COPYRIGHT

Copyright 2004

Fabien Potencier, fabpot@cpan.org

This software may be freely copied and distributed under the same
terms and conditions as Perl.

=head1 SEE ALSO

perl(1), Date::Holidays::UK, Date::Holidays::DE.

=cut
