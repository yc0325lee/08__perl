# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# non-captureing parenthesis -> (?:pattern)
# positive  lookahead        -> (?=pattern)
# negative  lookahead        -> (?!pattern)
# positive lookbehind        -> (?<=pattern)
# positive lookbehind        -> (?<!pattern)
# ----------------------------------------------------------------------------
use strict;
use warnings;

# reading all input strings
my @array;
while( <DATA> )
{
    chomp;
    push(@array, $_);
}

my $str;

printf("\n# solution-1\n");
for(my $i = 0; $i < @array; $i++)
{
    $str = $array[$i];
    $str =~ s/(?<=\d)(?=(?:\d\d\d)+\b)/,/g;
    #          -----  ---------------
    #          |      |
    #          |     2nd(look-ahead)
    #          |
    #         1st(look-behind)

    print $str, "\n";
}

printf("\n# solution-2\n");
for(my $i = 0; $i < @array; $i++)
{
    $str = $array[$i];
    $str =~ s/(?<=\d)(?=(?:\d\d\d)+(?!\d))/,/g;
    #          -----  -------------------
    #          |      |
    #          |     2nd(look-ahead)
    #          |
    #         1st(look-behind)

    print $str, "\n";
}


# ----------------------------------------------------------------------------
# # solution-1
# 1
# 12
# 123
# 1,234
# 12,345
# 123,456
# 1,234,567
# 12,345,678
# 123,456,789
# 1,234,567,891
# 12,345,678,912
# 123,456,789,123
# 1,234,567,891,234
# 12,345,678,912,345
# 123,456,789,123,456
# 1,234,567,891,234,567
# 12,345,678,912,345,678
# 123,456,789,123,456,789
# 
# # solution-2
# 1
# 12
# 123
# 1,234
# 12,345
# 123,456
# 1,234,567
# 12,345,678
# 123,456,789
# 1,234,567,891
# 12,345,678,912
# 123,456,789,123
# 1,234,567,891,234
# 12,345,678,912,345
# 123,456,789,123,456
# 1,234,567,891,234,567
# 12,345,678,912,345,678
# 123,456,789,123,456,789
# ----------------------------------------------------------------------------

__END__
1
12
123
1234
12345
123456
1234567
12345678
123456789
1234567891
12345678912
123456789123
1234567891234
12345678912345
123456789123456
1234567891234567
12345678912345678
123456789123456789
