use Test::More tests => 15;
BEGIN {
	use_ok('Date::Holidays::FR')
};

ok(!is_fr_holiday(2004, 1, 2));
ok(!is_fr_holiday(2004, 4, 11));
ok(!is_fr_holiday(2004, 12, 24));

ok(is_fr_holiday(2004, 4, 12));
like(is_fr_holiday(2004, 5, 31), qr/pentec/i);
like(is_fr_holiday(2004, 5, 20), qr/ascension/i);

my $year = (localtime)[5];
like(is_fr_holiday($year, 1, 1), qr/an/i);
like(is_fr_holiday($year, 5, 1), qr/travail/i);
like(is_fr_holiday($year, 5, 8), qr/armistice/i);
like(is_fr_holiday($year, 7, 14), qr/nationale/i);
like(is_fr_holiday($year, 8, 15), qr/assomption/i);
like(is_fr_holiday($year, 11, 1), qr/toussaint/i);
like(is_fr_holiday($year, 11, 11), qr/armistice/i);
like(is_fr_holiday($year, 12, 25), qr/no/i);
