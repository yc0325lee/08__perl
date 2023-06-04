# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# File : algorithm-jenkins_hash32_pure_perl.pl
# Description : 
# Author : yc0325lee
# Created : 2018-12-27 23:36:07 by yc0325lee
# Modified : 2018-12-28 00:22:37 by yc0325lee
# Source
#  - https://www.perlmonks.org/?node_id=1203588
# References
#  - http://www.perlmonks.org/?node_id=315881
#  - http://burtleburtle.net/bob/c/lookup2.c
#  - http://burtleburtle.net/bob/hash/doobs.html
#  - http://search.cpan.org/~shlomif/Digest-JHash/lib/Digest/JHash.pm
#  - http://cpansearch.perl.org/src/SHLOMIF/Digest-JHash-0.10/JHash.xs */ 
# ----------------------------------------------------------------------------
use strict;
use warnings;
use Carp;
use Data::Dumper; $Data::Dumper::Indent = 1;
use FindBin; use lib $FindBin::Bin;

{ # for use integer/bytes 
use integer;
use bytes; 

use constant GOLDEN_RATIO => 0x9e3779b9;

use constant A        => 0;
use constant B        => 1;
use constant C        => 2;
use constant FFFFFFFF => 0xffffffff; 
use constant KEY      => 0;
use constant INITHASH => 1;

sub mix4 ($$$) {
    # ---------------------------------------------
    # 32bit version 
    # per http://www.perlmonks.org/?node_id=1203705
    # this is a revised 32bit under 'use integer'; 
    # ---------------------------------------------
    $_[A] -= $_[B]; $_[A] -= $_[C]; { no integer; $_[A] ^= ($_[C]>>13); }
    $_[B] -= $_[C]; $_[B] -= $_[A]; { no integer; $_[B] ^= ($_[A]<< 8); }
    $_[C] -= $_[A]; $_[C] -= $_[B]; { no integer; $_[C] ^= ($_[B]>>13); }
    $_[A] -= $_[B]; $_[A] -= $_[C]; { no integer; $_[A] ^= ($_[C]>>12); }
    $_[B] -= $_[C]; $_[B] -= $_[A]; { no integer; $_[B] ^= ($_[A]<<16); }
    $_[C] -= $_[A]; $_[C] -= $_[B]; { no integer; $_[C] ^= ($_[B]>> 5); }
    $_[A] -= $_[B]; $_[A] -= $_[C]; { no integer; $_[A] ^= ($_[C]>> 3); }
    $_[B] -= $_[C]; $_[B] -= $_[A]; { no integer; $_[B] ^= ($_[A]<<10); }
    $_[C] -= $_[A]; $_[C] -= $_[B]; { no integer; $_[C] ^= ($_[B]>>15); }
}

sub mix4x ($$$) {
    # ---------------------------------------------
    # 32bit version 
    # per http://www.perlmonks.org/?node_id=1203705
    # this is wrong, not used
    # ---------------------------------------------
    $_[A] -= $_[B]; $_[A] -= $_[C]; $_[A] ^= ($_[C]>>13);
    $_[B] -= $_[C]; $_[B] -= $_[A]; $_[B] ^= ($_[A]<< 8);
    $_[C] -= $_[A]; $_[C] -= $_[B]; $_[C] ^= ($_[B]>>13);
    $_[A] -= $_[B]; $_[A] -= $_[C]; $_[A] ^= ($_[C]>>12);
    $_[B] -= $_[C]; $_[B] -= $_[A]; $_[B] ^= ($_[A]<<16);
    $_[C] -= $_[A]; $_[C] -= $_[B]; $_[C] ^= ($_[B]>> 5);
    $_[A] -= $_[B]; $_[A] -= $_[C]; $_[A] ^= ($_[C]>> 3);
    $_[B] -= $_[C]; $_[B] -= $_[A]; $_[B] ^= ($_[A]<<10);
    $_[C] -= $_[A]; $_[C] -= $_[B]; $_[C] ^= ($_[B]>>15);
}


sub mix8 ($$$) {
    # ---------------------------------------------
    # 64bit version 
    # ---------------------------------------------
    $_[A] &= FFFFFFFF; 
    $_[B] &= FFFFFFFF; 
    $_[C] &= FFFFFFFF; 
    $_[A] -= $_[B]; $_[A] -= $_[C]; $_[A] = ( $_[A] ^ ($_[C]>>13) ) & FFFFFFFF;
    $_[B] -= $_[C]; $_[B] -= $_[A]; $_[B] = ( $_[B] ^ ($_[A]<< 8) ) & FFFFFFFF;
    $_[C] -= $_[A]; $_[C] -= $_[B]; $_[C] = ( $_[C] ^ ($_[B]>>13) ) & FFFFFFFF;
    $_[A] -= $_[B]; $_[A] -= $_[C]; $_[A] = ( $_[A] ^ ($_[C]>>12) ) & FFFFFFFF;
    $_[B] -= $_[C]; $_[B] -= $_[A]; $_[B] = ( $_[B] ^ ($_[A]<<16) ) & FFFFFFFF;
    $_[C] -= $_[A]; $_[C] -= $_[B]; $_[C] = ( $_[C] ^ ($_[B]>> 5) ) & FFFFFFFF;
    $_[A] -= $_[B]; $_[A] -= $_[C]; $_[A] = ( $_[A] ^ ($_[C]>> 3) ) & FFFFFFFF;
    $_[B] -= $_[C]; $_[B] -= $_[A]; $_[B] = ( $_[B] ^ ($_[A]<<10) ) & FFFFFFFF;
    $_[C] -= $_[A]; $_[C] -= $_[B]; $_[C] = ( $_[C] ^ ($_[B]>>15) ) & FFFFFFFF;
}

sub jhash_pp_hex {
    my ($a, $b, $c) = ( GOLDEN_RATIO, GOLDEN_RATIO, $_[INITHASH] );
    my ($p, $length) = (0, length($_[KEY]));
    my $len = $length;
    my ($x, $y, $z);

    while( $len >= 12 ) {
        ($x, $y, $z) = unpack 'LLL', substr($_[KEY], $p, 12);
        $a += $x; $b += $y; $c += $z;  
        mix($a, $b, $c);
        $p += 12;
        $len -= 12; 
    }
    # even if len==0 we need another round to mix in the length 
    ($x, $y, $z) = unpack('LLL', substr($_[KEY] . (chr(0)x12), $p, 12));
    $z <<= 8;  # the first byte of c is reserved for the length
    $z += $length; 
    $a += $x; $b += $y; $c += $z;
    mix($a, $b, $c);

    my $hex = unpack("H*", pack("N", $c));

    return $hex;
} # jhash_pp_hex

sub jenkins_hval {
    @_==2 or die "";
    my $aref = shift;
    my $inithash = shift;

    my ($a, $b, $c) = ( GOLDEN_RATIO, GOLDEN_RATIO, $inithash );

    foreach my $str ( @{$aref} ) {
        my ($p, $length) = (0, length($str));
        my $len = $length;
        my ($x, $y, $z);

        while( $len >= 12 ) {
            ($x, $y, $z) = unpack 'LLL', substr($str, $p, 12);
            $a += $x; $b += $y; $c += $z;  
            mix($a, $b, $c);
            $p += 12;
            $len -= 12; 
        }
        # even if len==0 we need another round to mix in the length 
        ($x, $y, $z) = unpack('LLL', substr($str . (chr(0)x12), $p, 12));
        $z <<= 8;  # the first byte of c is reserved for the length
        $z += $length; 
        $a += $x; $b += $y; $c += $z;
        mix($a, $b, $c);
    }

    my $hex = unpack("H*", pack("N", $c));

    return $hex;
}

use Config; 
if ( $Config{ivsize} == 4 ) { *main::mix = *main::mix4; } # 32-bit
else                        { *main::mix = *main::mix8; } # 64-bit

} # has use integer/bytes  


# test-1
my @array = qw(
    a
    ab
    abc
    abcd
    abcde
    abcdef
    abcdefg
    abcdefgh
    abcdefghi
    abcdefghij
    abcdefghijk
    abcdefghijkl
    abcdefghijklm
    abcdefghijklmn
    abcdefghijklmno
    abcdefghijklmnop
    abcdefghijklmnopq
    abcdefghijklmnopqr
    abcdefghijklmnopqrs
    abcdefghijklmnopqrst
    abcdefghijklmnopqrstu
    abcdefghijklmnopqrstuv
    abcdefghijklmnopqrstuvw
    abcdefghijklmnopqrstuvwx
    abcdefghijklmnopqrstuvwxy
    abcdefghijklmnopqrstuvwxyz
    abcdefghijklmnopqrstuvwxyz1
    abcdefghijklmnopqrstuvwxyz12
    abcdefghijklmnopqrstuvwxyz123
    abcdefghijklmnopqrstuvwxyz1234
    abcdefghijklmnopqrstuvwxyz12345
    abcdefghijklmnopqrstuvwxyz123456
    abcdefghijklmnopqrstuvwxyz1234567
    abcdefghijklmnopqrstuvwxyz12345678
    abcdefghijklmnopqrstuvwxyz123456789
    abcdefghijklmnopqrstuvwxyz1234567890
);

printf("\n# test-0\n");
foreach my $str ( @array ) {
    printf("%-*s ---> %s\n", 41, $str, jhash_pp_hex($str, 0));
}

printf("\n# test-1\n");
printf("%-*s ---> %s\n", 41, '@array', jenkins_hval(\@array, 0));


__END__

# test-0
a                                         ---> 29eec818
ab                                        ---> 9879ac41
abc                                       ---> 251e4793
abcd                                      ---> 5ae61fa5
abcde                                     ---> 03a96866
abcdef                                    ---> de922732
abcdefg                                   ---> b9e6762c
abcdefgh                                  ---> 053f775e
abcdefghi                                 ---> 3a7b0a5f
abcdefghij                                ---> c9cac242
abcdefghijk                               ---> e52b8e4c
abcdefghijkl                              ---> 0b1b3ea5
abcdefghijklm                             ---> 3122b031
abcdefghijklmn                            ---> fec330e0
abcdefghijklmno                           ---> 11dccf31
abcdefghijklmnop                          ---> fa1ecf51
abcdefghijklmnopq                         ---> 25dfecf2
abcdefghijklmnopqr                        ---> 6731df7e
abcdefghijklmnopqrs                       ---> 4b65a544
abcdefghijklmnopqrst                      ---> f2a2e1cf
abcdefghijklmnopqrstu                     ---> 30a943f8
abcdefghijklmnopqrstuv                    ---> bf6c0b42
abcdefghijklmnopqrstuvw                   ---> 68e5ff21
abcdefghijklmnopqrstuvwx                  ---> d6638b78
abcdefghijklmnopqrstuvwxy                 ---> 720b6730
abcdefghijklmnopqrstuvwxyz                ---> c52fcee8
abcdefghijklmnopqrstuvwxyz1               ---> e1730d7c
abcdefghijklmnopqrstuvwxyz12              ---> ca02eafe
abcdefghijklmnopqrstuvwxyz123             ---> 748dc3e6
abcdefghijklmnopqrstuvwxyz1234            ---> 932147af
abcdefghijklmnopqrstuvwxyz12345           ---> 5a751c1c
abcdefghijklmnopqrstuvwxyz123456          ---> 40fed751
abcdefghijklmnopqrstuvwxyz1234567         ---> f83eaf5b
abcdefghijklmnopqrstuvwxyz12345678        ---> 77e297c6
abcdefghijklmnopqrstuvwxyz123456789       ---> 87d01377
abcdefghijklmnopqrstuvwxyz1234567890      ---> 16ff28b0

# test-1
@array                                    ---> c3649ae6
