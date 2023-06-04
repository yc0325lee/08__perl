# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 160615_235836
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# 1. pack(),unpack()�Լ��� �̿��Ͽ� ���ڿ��� �� ���ھ� ó��          #
# ----------------------------------------------------------------------------
# ���ڿ��� �迭�� ��ȯ #
my $s = "MP3 Player"; # ���ڿ� ����

# ���ڿ��� 1���ھ� �����Ͽ� �迭�� �����
my @unpacked = unpack("C*", $s);

# �迭 ���� ���(1���ھ�)
foreach my $ch ( @unpacked )
{
    print chr($c), "-"; # M-P-3- -P-l-a-y-e-r-
}
print "\n\n"; # ���ǻ� �ٹٲ�

# �迭�� ���ڿ��� ��ȯ #
my $packed = pack("C*", @unpacked);

# ���ڿ� ���
print $packed, "\n"; # --> MP3 Player


# ----------------------------------------------------------------------------
# 2. pack() & unpack()�Լ��� �̿��Ͽ� �������ڿ�,����Array �����
# ----------------------------------------------------------------------------
# ���� ���ڿ� ����� #
my @bytes = ( 0x00, 0x01, 0x02, 0xFF ); # ���� ����Ʈ �迭 �����
my $bin_str = pack("C*", @bytes); # ���� �迭�� ���� ���ڿ��� ��ġ��

## ���� ���ڿ��� ���� ����ϱ� #
my @bin_array = unpack "C*", $bin_str; # �������ڿ���, �����迭�� �и�

foreach my $bin ( @bin_array )
{
    printf("0x%02X ", $bin);
} # --> 0x00 0x01 0x02 0xFF


# ----------------------------------------------------------------------------
# aero���� note
# ----------------------------------------------------------------------------
pack(),unpack(),vec() �� Perl������ ���� �� �˷��� ���� �ʰ� ����� �ʿ�
���ϴ� ��� �����̴�. perldoc�� �ڼ��� ����� �������� �ֱ� ������ �ʹ� ��
Ȳ�ϰų� ���� �˵��ϸ鼭�� �� �𸣰ڰ� �򰥸� ��찡 ������ Perldoc�� ����
�߿��� �̷� �������� ����. ������ �� �������� �� ���ٴ� ���� �ƴϰ� ó��
���ϴ� ������� ģ�������� �ʴٴ� ���̴�. �׷����� ��������� ���ع������
�����ؼ� �⺻�� �������� perldoc�� �о�°� ����. �׷��� ��������� ����
������� pack,unpack,vec �� ���ؼ� �����غô�. �� ������ pack,unpack,vec��
���ΰ� �ƴϰ� perldoc���� ���� ������� �����ϸ� ���� �ٿ��� �� �ֵ���
���ʸ� �����ִ� ������ ����ϱ�.. (���ٰ� Ʋ�� �� ������ ��Ŭ ȯ��)

# -----------------------
# 1. pack(TEMPLATE, LIST)
--> ����Ʈ�� TEMPLATE�� �����ؼ� �ϳ��� �������� ����Ʈ �����ͷ� ����� �Լ�

(Perldoc������ ���ڿ��� ����ٰ� �ϳ� ������ �������� ����Ʈ(����) �����ͷ�
���� ���� �����ϴ�. �� ����Ʈ���� ������ 0x00~0xff�����̱� ������ ASCII����
�� ����⵵ �ϱ� �����̴�.)

���⼭ TEMPLATE�� LIST�� ������ ���ϴ°��� �ǹ���

�������� ����Ʈ������ ���� <- TEMPLATE <- TEMPLATE�� ������ ������ �ڷ���� ����Ʈ

# -------------------------
# 2. unpack(TEMPLATE, EXPR)
--> EXPR�� �������� ����Ʈ�����͸� ���ϴ� �����͵��� ����Ʈ�� ����� �Լ�

���⼭ TEMPLATE�� EXPR�� ���� ����Ʈ�������� Ư���κ��� � �����Ͱ� �� ��
�ΰ��� �ǹ���

TEMPLATE�� ������ ������ ������ ����Ʈ <- TEMPLATE <- �������� ����Ʈ ������ ����
 

# -----------
# 3. TEMPLATE
* �ڼ��� ���ø� ���ǹ��ڴ� http://perldoc.perl.org/functions/pack.html�� ����

pack, unpack�� TEMPLATE���� Ư�� �Ӽ��� ��Ÿ���� ���ø����� ���ڰ� ���ö�����
������ ������ �ȴ�.

"C"  # unsigned char�� �ϳ�
"C2" �Ǵ� "C*"�� ����  # unsigned char���� ���ڸ�ŭ ���Ӱ� ������� ����
"C2C"  # unsigned char��2�� �����ϳ�, unsigned char�� �ϳ�
"CC"   # unsigned char�� 2��
 

# -------------------------
# 4. pack() & unpack() ����
  1) ����

# 65�� unsigned char ������ �����ϰ� ����Ʈ������ȭ �Ѵ�
print pack("C", 65), "\n";
# C -> An unsigned char(octet) value, ascii code 65 -> "A"
# result -> A
# �� ����� ����� ����Ʈ������ \x41 �� �ǰ� �̰��� ������
# �ش� �ƽ�Ű�ڵ� ���� A�� ����
 
# �޸𸮻� ����� "A"�� ���� ����Ʈ������(\x41)�� C�� ��Ÿ����
# ũ��(1����Ʈ)��ŭ �����ͼ� unsinged charȭ �Ѵ�.
print unpack("C", "A");  # �޸𸮻󿡴� "A"�� \x41 ����Ʈ�����ͷ� �� ����
# result -> 65

print pack("CC", 65, 66);
# result -> AB

print join(' ', unpack("CC","AB")), "\n";
# result -> 65 66

print pack("C*", 65, 66, 67), "\n";
# result -> ABC

print join(' ', unpack("C*", "ABC")), "\n";
# result -> 65 66 67

 

# * a,A,Z,b,B,h,H,@,.,x,X�� P �� ������ ���ø� ���� ���ڴ� pack�Լ�����
# ���ڳ� *�� �������� �����ϸ� LIST�� ������ ��������� ������δ�(globbing).

H -> A hex string (high nybble first). nybble�� 4bit�� ���� 16���� 0xAE���� A��E�� nybble.

print pack "H*", "41","42";      # H�� *�� �ᵵ "41"���� ����
A

print pack "H4", "41","42";      # ���������� H4�� "41"���� ����ȴ�. ���´ٰ� ���� ���� �������� �ʴ´�.

A

print pack "H*", "4142";
AB

"4142"�� nybble�� ����(H*)���� ���� 4��Ʈ�� ���ʴ�� pack�ϸ� \x41\x42 �� �Ǳ� ������ ������ AB�� ����.

�̰��� H*�� "4142"�� ���ؼ� ������ ���̹Ƿ� LIST�� ��Ұ� �������� �� ��������� �ٸ���.

���࿡ H* ��� h*�� �Ἥ

print pack "h*", "4142";

$

��� �ϸ� h��  A hex string (low nybble first)�� ���ϹǷ� \x14\x24 �� pack�ȴ�.

print pack "a4","abcde","X","Y","Z"; #  a  A string with arbitrary binary data, will be null padded.  "a4"�� ����Ʈ ù��° ��ҿ� ����Ǿ������.
abcd

print pack "a4","abc","X","Y","Z";  # ���´ٰ� ���� ���� �������� �ʴ´�.

abc

print pack "A4","abc","X","Y","Z";  # a�� null�� padding �ϰ� A�� �������� �е��Ѵ�.

abc  <- ���⼭�� c�ڿ� �����ϳ��� �ִ�.

print pack "aaaa","abcde","X","Y","Z";
aXYZ

 

print pack "C*", 65,66,67;     # C��*�� ���� LIST�� ��������� �������
ABC

print pack "C3", 65,66,67;    # C�����ڸ� ���� LIST�� ��������� �������

ABC

 

* a,A,Z,b,B,h,H,@,.,x,X�� P �� ������ ���ø� ���� ���ڴ� unpack���� ���ڳ� *�� ����ϸ� LIST�� ��ȯ�Ѵ�.

print join " ",unpack("H*", "ABC");  # �� �������� �Ѿ��.(�������� join������ ������ �ȵ����Ƿ�)
414243

print join " ",unpack "B*", pack "C",255;  # B  A bit string (descending bit order inside each byte)., �� �������� �Ѿ��
11111111

print join " ",unpack("H4","AB");   #���� �� �������� �Ѿ

4142
$hex=unpack("C*","ABC");print $hex;   # $hex�� ��Į�� ������ �Ѱ��� LIST�� ù ��° ���� ����.(����Ʈ�� �Ѿ���� �� �� �ִ�.)
65

@hex=unpack("C*","ABC");print "@hex";  # �迭�� �ϸ� �Ѱ��� ����Ʈ�� �� �޴´�.
65 66 67

print join " ",unpack("C3","ABC");  # ����Ʈ�� �Ѱ��ش�.

65 66 67

 

 

* ��Ÿ

print pack "H2","41"; 

A

print unpack "H2","A";

41

print pack "HH", "41";

@

�� A�� �ƴұ�? ùH�� �� ������ "41"�� ��Ī�Ͽ� �����ϰ� �ι�° H�� ��Ī ����� �����Ƿ� ���ڰ� �ȴ�.

pack���� ���ø����ǹ��ڷ� �̷������ �� ������ �ּ� ����Ʈ ��ҵ鿡 �ּ� 1:1 Ȥ�� �̻����� �����Ǿ� �����Ѵ�.

���� 41���� ���� nybble 4�������ͼ� \x40�� ���� ASCII ���� @�� �����.

print unpack "HH", "A";
4

unpack���� ���ø����ǹ��ڷ� �̷������ �� ������ �ּ� 1����Ʈ������ ���� �����Ѵ�.

"A"�� �޸𸮻� ����� 1����Ʈ \x41���� ���� nybble 4�� �����ͼ� ������. �ι�°H�� �������� �����Ƿ� �� ���ڰ� �ȴ�.

print unpack "B2", pack "C",255;    # pack�� 255(0b11111111)�� ���� 2��Ʈ�� �����´�.
11

print unpack "BB", pack "C",255;
1

�̰� �� 11�� �ƴұ�? �ٷ� ��"HH"��츦 ���ø��� ���̳���

 

print pack "H6","414243";

ABC

print join ' ', unpack "H6", "ABC";

414243 <- H6���� ABC�� ����� ����Ʈ�����Ϳ����� �ѵ���� unpack �ƴ�.(�������� join�ߴµ� �����߰��� ������ �����Ƿ�)

print join ' ', unpack "H2H2H2", "ABC";

41 42 43 <- �� ����Ʈ�� ����Ʈ�� unpack

print join '|', unpack "HHHHHH", "ABC";

4|4|4|||

�� 4|1|4|2|4|3  �� �ƴұ�? ������ unpack���� ���ø����ǹ��ڷ� �̷������ �� ������ �ּ� 1����Ʈ������ ���� �����Ѵ�. ���

�� ���� ���ø��� ó�� 3���� H�� ���� A,B,C�� ���� �����ؼ� ���� nybble 4�� �������� �������� �������� �����Ƿ�

���ڰ� �Ǿ����� �� �� �ִ�.

my $var = pack "S",65535;   #  S  An unsigned short value,   65535 �� 0xFFFF

$var �� unsigned 16bit ������ �޸𸮻��� �������� ����Ʈ������ "\xff\xff" �� �����

 

�޸𸮻��� �������ι���Ʈ������ \xff\xff (16bit)�� 16���� ���·� unpack�Ϸ���

print unpack("H4",$var);

ffff

255(0xff)�� 16bit ������ pack�ϰ� 16���� ���·� unpack, 255�� 8bit���� ��Ÿ�� �� ������ ���ø��� �� �̻��� ũ�⸦ �����ϸ� �������� 0�� �е��ȴ�.

print unpack("H4", pack "S",255);

ff00 <- intel �ӽ��� little-endian �̹Ƿ� ���� ����Ʈ�� ������ ����.

(endian�� ���ؼ��� http://ko.wikipedia.org/wiki/%EC%97%94%EB%94%94%EC%96%B8 �� ���� )

�̰��� network byte order(big-endian)���� �ؼ� ��������

print unpack("H4", pack "n",255);  # n  An unsigned short (16-bit) in "network" (big-endian) order.

00ff

 

print unpack 'C',pack 'B*','10001000';  # B  A bit string (descending bit order inside each byte).

136

���⼭ H��h�� �޶��� ��ó�� B��b�� �ٸ��� �����Ѵ�. ����

print unpack 'C',pack 'b*','10001000';    # b  A bit string (ascending bit order inside each byte, like vec()).

17

ó�� "b*"�� pack�ϸ� 0b00010001�� �ǰ� �̰��� "C"�� unpack�ϸ� 17�� �Ǵ� ���̴�.

���� pack,unpack�� ����� ���� ���ø����� ���ڿ� ���� bit,nybble,byte�� � ������ ó���ϴ�����

big-endian, little-endian�� ����ؾ� �Ѵ�.

 

vec EXPR, OFFSET, BITS
EXPR�� ��Ʈ�� ������ ��Ʈ��Ʈ������ �����ϰ� BITS������ OFFSET��ŭ �̵���Ű��
$var = vec(...) �����̸� �ű⼭���� �����͸� ���� �� �ְ� lvalue�� ����Ͽ� vec(...)=1ó�� �ű⿡ ���� ���Խ�Ű�� �� ��ġ���� �����͸� �ٲ۴�.

�д� ���̳� ���Խ�Ű�� ���� BITS�� ������ bit���� ǥ���ǰų� ǥ���� �� �ִ� �������̴�.

 

�� ����Ʈ�� ��Ʈ������ little endian ������ ������(������ ��Ʈ�� ���� ���� ���´ٴ� ��)

BITS�� 1~32����(64bit perl�� 64����)�� 2�ǽ¼�(1,2,4,8,16,32)�̾�� �ȴ�.

 

<1bit������ 0��ŭ �̵��ؼ� �� ��(1bit)�� 0����>

>perl -e '$var = pack "C",255;vec($var,0,1)=0;print unpack "b*",$var;'  # 255 = 0xff = 0b11111111
01111111  <- little-endian����, vec�� little-endian�������� ��Ʈ�� �ٷ��� �� �� �ִ�.

>perl -e '$var = pack "C",255;vec($var,0,1)=0;print unpack "C",$var;'

254  <- �������δ� 0b11111110 �� �� ���� �������� 254�̴� �̰��� ���� ���� ������ ��Ʈ�� 0�� ������ �� �� �ִ�.

>perl -e '$var = pack "C",255;vec($var,0,1)=0;print unpack "B*",$var;'
11111110  <- big-endian�������� ����ؼ� �װ��� Ȯ��

<1bit������ 1��ŭ �̵��ؼ� �� ���� 0����>

perl -e '$var = pack "C",255;vec($var,1,1)=0;print unpack "b*",$var;'
10111111

<2bit������ 0��ŭ�̵��ؼ� �� ��(2bit)�� 0����>

>perl -e '$var = pack "C",255;vec($var,0,2)=0;print unpack "b*",$var;'
00111111

<BITS�� 2�� �¼��� �ƴϸ� ����>
>perl -e '$var = pack "C",255;vec($var,0,3)=0;print unpack "b*",$var;'
Illegal number of bits in vec at -e line 1.

<2bit������ 1��ŭ�̵��Ͽ� �� ���� 0����>

>perl -e '$var = pack "C",255;vec($var,1,2)=0;print unpack "b*",$var;'
11001111

 

<8bit ������ n��ŭ �̵��ؼ� �ش� ��ġ�� ��(8bit)�� �����ͼ� �ش� �ƽ�Ű�ڵ� ���ڸ� ����>

>perl -e '$str="Perl"; print chr(vec($str,0,8));'
P
>perl -e "$str="Perl"; print chr(vec($str,1,8));"
e
>perl -e "$str="Perl"; print chr(vec($str,2,8));"
r
>perl -e "$str="Perl"; print chr(vec($str,3,8));"
l

 

<�����ڵ�>

#! /usr/bin/perl
use strict;
use warnings;
use Devel::Peek;

print "\x50\x65\x72\x6C\n";
my $foo = '';
vec($foo, 0, 32) = 0x5065726C; #  $foo�� 32bit |50|65|72|6C|

print "$foo\n";
print unpack("H8", $foo),"\n";

my $foo2 = '';
vec($foo2, 0, 32) = unpack "N", pack "H8","5065726C";  # N  An unsigned long (32-bit) in "network" (big-endian) order.
print "$foo2\n";

 

<���>

Perl

Perl

5065726c

Perl

 

# ----------------------------------------------------------------------------
# ���� URL �� ��ȭ�н�
# ----------------------------------------------------------------------------
http://p3rl.org/pack
http://p3rl.org/unpack
http://p3rl.org/vec
http://p3rl.org/packtut
http://www.perlmonks.org/?node_id=224666 --> pack/unpack tutorial
(�Ϻ�����Ʈ ����)http://www.excite-webtl.jp/world/korean/web/?wb_url=http://mikeneko.creator.club.ne.jp/~lab/perl/numerical_transform/
(�Ϻ�����Ʈ ����)http://www.excite-webtl.jp/world/korean/web/?wb_url=http://www.rfs.jp/sb/perl/05/pack.html
(�Ϻ�����Ʈ ����)http://www.excite-webtl.jp/world/korean/web/?wb_url=http://perldoc.jp/docs/perl/5.8.8/perlpacktut.pod
http://cafe.naver.com/ArticleRead.nhn?clubid=14948090&articleid=143
http://cafe.naver.com/ArticleRead.nhn?clubid=14948090&articleid=142
http://www252.pair.com/comdog/mastering_perl/Chapters/16.bit_vectors.html
http://gypark.pe.kr/wiki/Perl/Pack
