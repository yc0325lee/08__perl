# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 160615_235836
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 1. pack(),unpack()함수를 이용하여 문자열을 한 글자씩 처리          #
# ----------------------------------------------------------------------------
# 문자열을 배열로 변환 #
my $s = "MP3 Player"; # 문자열 정의

# 문자열을 1글자씩 분해하여 배열로 만들기
my @unpacked = unpack("C*", $s);

# 배열 내용 출력(1글자씩)
foreach my $ch ( @unpacked )
{
    print chr($c), "-"; # M-P-3- -P-l-a-y-e-r-
}
print "\n\n"; # 편의상 줄바꿈

# 배열을 문자열로 변환 #
my $packed = pack("C*", @unpacked);

# 문자열 출력
print $packed, "\n"; # --> MP3 Player


# ----------------------------------------------------------------------------
# 2. pack() & unpack()함수를 이용하여 이진문자열,이진Array 만들기
# ----------------------------------------------------------------------------
# 이진 문자열 만들기 #
my @bytes = ( 0x00, 0x01, 0x02, 0xFF ); # 이진 바이트 배열 만들기
my $bin_str = pack("C*", @bytes); # 이진 배열을 이진 문자열로 합치기

## 이진 문자열을 헥사로 출력하기 #
my @bin_array = unpack "C*", $bin_str; # 이진문자열을, 이진배열로 분리

foreach my $bin ( @bin_array )
{
    printf("0x%02X ", $bin);
} # --> 0x00 0x01 0x02 0xFF


# ----------------------------------------------------------------------------
# aero님의 note
# ----------------------------------------------------------------------------
pack(),unpack(),vec() 은 Perl에서도 비교적 잘 알려져 있지 않고 어려운 쪽에
속하는 고급 주제이다. perldoc에 자세히 설명된 문서들이 있긴 하지만 너무 장
황하거나 보면 알듯하면서도 또 모르겠고 헷갈릴 경우가 많은데 Perldoc의 문서
중에는 이런 문서들이 많다. 하지만 그 문서들이 안 좋다는 것이 아니고 처음
접하는 사람에게 친절하지는 않다는 것이다. 그럴때는 나름대로의 이해방식으로
정리해서 기본을 익힌다음 perldoc을 읽어보는게 좋다. 그래서 나름대로의 이해
방식으로 pack,unpack,vec 에 대해서 정리해봤다. 이 문서는 pack,unpack,vec의
전부가 아니고 perldoc문서 보고 감을잡고 이해하며 살을 붙여갈 수 있도록
기초를 다져주는 것임을 명심하길.. (보다가 틀린 것 있으면 태클 환영)

# -----------------------
# 1. pack(TEMPLATE, LIST)
--> 리스트를 TEMPLATE를 적용해서 하나의 연속적인 바이트 데이터로 만드는 함수

(Perldoc에서는 문자열로 만든다고 하나 실제는 연속적인 바이트(옥텟) 데이터로
보는 것이 적절하다. 각 바이트들의 범위는 0x00~0xff까지이기 때문에 ASCII영역
을 벗어나기도 하기 때문이다.)

여기서 TEMPLATE는 LIST가 무엇을 뜻하는가를 의미함

연속적인 바이트데이터 형태 <- TEMPLATE <- TEMPLATE가 지정한 형태의 자료들의 리스트

# -------------------------
# 2. unpack(TEMPLATE, EXPR)
--> EXPR의 연속적인 바이트데이터를 원하는 데이터들의 리스트로 만드는 함수

여기서 TEMPLATE는 EXPR의 연속 바이트데이터의 특정부분이 어떤 데이터가 될 것
인가를 의미함

TEMPLATE가 지정한 형태의 데이터 리스트 <- TEMPLATE <- 연속적인 바이트 데이터 형태
 

# -----------
# 3. TEMPLATE
* 자세한 템플릿 정의문자는 http://perldoc.perl.org/functions/pack.html를 참고

pack, unpack은 TEMPLATE에서 특정 속성을 나타내는 템플릿정의 문자가 나올때마다
각각의 단위가 된다.

"C"  # unsigned char값 하나
"C2" 또는 "C*"의 형태  # unsigned char값의 숫자만큼 연속과 계속적인 연속
"C2C"  # unsigned char값2개 묶음하나, unsigned char값 하나
"CC"   # unsigned char값 2개
 

# -------------------------
# 4. pack() & unpack() 예제
  1) 기초

# 65를 unsigned char 값으로 생각하고 바이트데이터화 한다
print pack("C", 65), "\n";
# C -> An unsigned char(octet) value, ascii code 65 -> "A"
# result -> A
# 위 명령의 결과로 바이트데이터 \x41 이 되고 이것을 찍으면
# 해당 아스키코드 문자 A가 찍힘
 
# 메모리상에 저장된 "A"에 대한 바이트데이터(\x41)를 C가 나타내는
# 크기(1바이트)만큼 가져와서 unsinged char화 한다.
print unpack("C", "A");  # 메모리상에는 "A"가 \x41 바이트데이터로 들어가 있음
# result -> 65

print pack("CC", 65, 66);
# result -> AB

print join(' ', unpack("CC","AB")), "\n";
# result -> 65 66

print pack("C*", 65, 66, 67), "\n";
# result -> ABC

print join(' ', unpack("C*", "ABC")), "\n";
# result -> 65 66 67

 

# * a,A,Z,b,B,h,H,@,.,x,X와 P 를 제외한 템플릿 정의 문자는 pack함수에서
# 숫자나 *로 복수개를 지정하면 LIST의 값들을 계속적으로 끌어들인다(globbing).

H -> A hex string (high nybble first). nybble은 4bit를 말함 16진수 0xAE에서 A와E가 nybble.

print pack "H*", "41","42";      # H에 *을 써도 "41"에만 적용
A

print pack "H4", "41","42";      # 마찬가지로 H4는 "41"에만 적용된다. 남는다고 뒷쪽 것을 가져오지 않는다.

A

print pack "H*", "4142";
AB

"4142"를 nybble의 연속(H*)으로 보고 4비트씩 차례대로 pack하면 \x41\x42 가 되기 때문에 찍으면 AB가 나옴.

이경우는 H*가 "4142"에 대해서 동작한 것이므로 LIST의 요소가 여러개인 위 예제들과는 다르다.

만약에 H* 대신 h*를 써서

print pack "h*", "4142";

$

라고 하면 h는  A hex string (low nybble first)을 뜻하므로 \x14\x24 로 pack된다.

print pack "a4","abcde","X","Y","Z"; #  a  A string with arbitrary binary data, will be null padded.  "a4"가 리스트 첫번째 요소에 적용되어버린다.
abcd

print pack "a4","abc","X","Y","Z";  # 남는다고 뒷쪽 것을 가져오지 않는다.

abc

print pack "A4","abc","X","Y","Z";  # a는 null로 padding 하고 A는 공백으로 패딩한다.

abc  <- 여기서는 c뒤에 공백하나가 있다.

print pack "aaaa","abcde","X","Y","Z";
aXYZ

 

print pack "C*", 65,66,67;     # C에*을 쓰면 LIST를 계속적으로 끌어들임
ABC

print pack "C3", 65,66,67;    # C에숫자를 쓰면 LIST를 계속적으로 끌어들임

ABC

 

* a,A,Z,b,B,h,H,@,.,x,X와 P 를 제외한 템플릿 정의 문자는 unpack에서 숫자나 *를 사용하면 LIST를 반환한다.

print join " ",unpack("H*", "ABC");  # 한 묶음으로 넘어간다.(공백으로 join했으나 공백이 안들어갔으므로)
414243

print join " ",unpack "B*", pack "C",255;  # B  A bit string (descending bit order inside each byte)., 한 묶음으로 넘어옴
11111111

print join " ",unpack("H4","AB");   #역시 한 묶음으로 넘어감

4142
$hex=unpack("C*","ABC");print $hex;   # $hex가 스칼라 변수라서 넘겨준 LIST의 첫 번째 값만 들어갔다.(리스트가 넘어옴을 알 수 있다.)
65

@hex=unpack("C*","ABC");print "@hex";  # 배열로 하면 넘겨준 리스트를 다 받는다.
65 66 67

print join " ",unpack("C3","ABC");  # 리스트를 넘겨준다.

65 66 67

 

 

* 기타

print pack "H2","41"; 

A

print unpack "H2","A";

41

print pack "HH", "41";

@

왜 A가 아닐까? 첫H가 뒤 따르는 "41"과 매칭하여 동작하고 두번째 H는 매칭 대상이 없으므로 빈문자가 된다.

pack에서 템플릿정의문자로 이루어지는 각 단위는 최소 리스트 요소들에 최소 1:1 혹은 이상으로 대응되어 동작한다.

따라서 41에서 상위 nybble 4만가져와서 \x40에 대한 ASCII 문자 @를 찍었다.

print unpack "HH", "A";
4

unpack에서 템플릿정의문자로 이루어지는 각 단위는 최소 1바이트단위에 대해 동작한다.

"A"가 메모리상에 저장된 1바이트 \x41에서 상위 nybble 4만 가져와서 찍혔다. 두번째H는 적용대상이 없으므로 빈 문자가 된다.

print unpack "B2", pack "C",255;    # pack된 255(0b11111111)의 상위 2비트를 가져온다.
11

print unpack "BB", pack "C",255;
1

이건 왜 11이 아닐까? 바로 위"HH"경우를 떠올리면 답이나옴

 

print pack "H6","414243";

ABC

print join ' ', unpack "H6", "ABC";

414243 <- H6으로 ABC가 저장된 바이트데이터연속을 한덩어리로 unpack 됐다.(공백으로 join했는데 숫자중간에 공백이 없으므로)

print join ' ', unpack "H2H2H2", "ABC";

41 42 43 <- 한 바이트씩 리스트로 unpack

print join '|', unpack "HHHHHH", "ABC";

4|4|4|||

왜 4|1|4|2|4|3  이 아닐까? 위에서 unpack에서 템플릿정의문자로 이루어지는 각 단위는 최소 1바이트단위에 대해 동작한다. 라고

한 것을 떠올리면 처음 3개의 H가 각각 A,B,C에 대해 동작해서 상위 nybble 4만 가져오고 나머지는 적용대상이 없으므로

빈문자가 되었음을 알 수 있다.

my $var = pack "S",65535;   #  S  An unsigned short value,   65535 는 0xFFFF

$var 는 unsigned 16bit 값으로 메모리상의 연속적인 바이트데이터 "\xff\xff" 로 저장됨

 

메모리상의 연속적인바이트데이터 \xff\xff (16bit)를 16진수 형태로 unpack하려면

print unpack("H4",$var);

ffff

255(0xff)를 16bit 정수로 pack하고 16진수 형태로 unpack, 255는 8bit으로 나타낼 수 있지만 템플릿이 그 이상의 크기를 지정하면 나머지는 0로 패딩된다.

print unpack("H4", pack "S",255);

ff00 <- intel 머신이 little-endian 이므로 하위 바이트가 상위로 갔다.

(endian에 대해서는 http://ko.wikipedia.org/wiki/%EC%97%94%EB%94%94%EC%96%B8 를 참고 )

이것을 network byte order(big-endian)으로 해서 찍으려면

print unpack("H4", pack "n",255);  # n  An unsigned short (16-bit) in "network" (big-endian) order.

00ff

 

print unpack 'C',pack 'B*','10001000';  # B  A bit string (descending bit order inside each byte).

136

여기서 H와h가 달랐던 것처럼 B와b도 다르게 동작한다. 만약

print unpack 'C',pack 'b*','10001000';    # b  A bit string (ascending bit order inside each byte, like vec()).

17

처럼 "b*"로 pack하면 0b00010001이 되고 이것을 "C"로 unpack하면 17이 되는 것이다.

따라서 pack,unpack을 사용할 때는 템플릿정의 문자에 따라 bit,nybble,byte를 어떤 순서로 처리하는지와

big-endian, little-endian을 고려해야 한다.

 

vec EXPR, OFFSET, BITS
EXPR을 비트의 연속인 비트스트링으로 간주하고 BITS단위로 OFFSET만큼 이동시키며
$var = vec(...) 형식이면 거기서부터 데이터를 읽을 수 있고 lvalue로 사용하여 vec(...)=1처럼 거기에 값을 대입시키면 그 위치부터 데이터를 바꾼다.

읽는 값이나 대입시키는 값은 BITS에 지정한 bit수로 표현되거나 표현할 수 있는 데이터이다.

 

단 바이트의 비트순서는 little endian 형식을 따르며(최하위 비트가 제일 먼저 나온다는 말)

BITS는 1~32까지(64bit perl은 64까지)의 2의승수(1,2,4,8,16,32)이어야 된다.

 

<1bit단위로 0만큼 이동해서 그 값(1bit)을 0으로>

>perl -e '$var = pack "C",255;vec($var,0,1)=0;print unpack "b*",$var;'  # 255 = 0xff = 0b11111111
01111111  <- little-endian형식, vec이 little-endian형식으로 비트를 다룸을 알 수 있다.

>perl -e '$var = pack "C",255;vec($var,0,1)=0;print unpack "C",$var;'

254  <- 이진수로는 0b11111110 인 이 값은 십진수로 254이다 이것을 보면 실제 최하위 비트가 0이 됐음을 알 수 있다.

>perl -e '$var = pack "C",255;vec($var,0,1)=0;print unpack "B*",$var;'
11111110  <- big-endian형식으로 출력해서 그것을 확인

<1bit단위로 1만큼 이동해서 그 값을 0으로>

perl -e '$var = pack "C",255;vec($var,1,1)=0;print unpack "b*",$var;'
10111111

<2bit단위로 0만큼이동해서 그 값(2bit)을 0으로>

>perl -e '$var = pack "C",255;vec($var,0,2)=0;print unpack "b*",$var;'
00111111

<BITS가 2의 승수가 아니면 에러>
>perl -e '$var = pack "C",255;vec($var,0,3)=0;print unpack "b*",$var;'
Illegal number of bits in vec at -e line 1.

<2bit단위로 1만큼이동하여 그 값을 0으로>

>perl -e '$var = pack "C",255;vec($var,1,2)=0;print unpack "b*",$var;'
11001111

 

<8bit 단위로 n만큼 이동해서 해당 위치의 값(8bit)을 가져와서 해당 아스키코드 문자를 찍어보자>

>perl -e '$str="Perl"; print chr(vec($str,0,8));'
P
>perl -e "$str="Perl"; print chr(vec($str,1,8));"
e
>perl -e "$str="Perl"; print chr(vec($str,2,8));"
r
>perl -e "$str="Perl"; print chr(vec($str,3,8));"
l

 

<예제코드>

#! /usr/bin/perl
use strict;
use warnings;
use Devel::Peek;

print "\x50\x65\x72\x6C\n";
my $foo = '';
vec($foo, 0, 32) = 0x5065726C; #  $foo는 32bit |50|65|72|6C|

print "$foo\n";
print unpack("H8", $foo),"\n";

my $foo2 = '';
vec($foo2, 0, 32) = unpack "N", pack "H8","5065726C";  # N  An unsigned long (32-bit) in "network" (big-endian) order.
print "$foo2\n";

 

<결과>

Perl

Perl

5065726c

Perl

 

# ----------------------------------------------------------------------------
# 참고 URL 및 심화학습
# ----------------------------------------------------------------------------
http://p3rl.org/pack
http://p3rl.org/unpack
http://p3rl.org/vec
http://p3rl.org/packtut
http://www.perlmonks.org/?node_id=224666 --> pack/unpack tutorial
(일본싸이트 번역)http://www.excite-webtl.jp/world/korean/web/?wb_url=http://mikeneko.creator.club.ne.jp/~lab/perl/numerical_transform/
(일본싸이트 번역)http://www.excite-webtl.jp/world/korean/web/?wb_url=http://www.rfs.jp/sb/perl/05/pack.html
(일본싸이트 번역)http://www.excite-webtl.jp/world/korean/web/?wb_url=http://perldoc.jp/docs/perl/5.8.8/perlpacktut.pod
http://cafe.naver.com/ArticleRead.nhn?clubid=14948090&articleid=143
http://cafe.naver.com/ArticleRead.nhn?clubid=14948090&articleid=142
http://www252.pair.com/comdog/mastering_perl/Chapters/16.bit_vectors.html
http://gypark.pe.kr/wiki/Perl/Pack
