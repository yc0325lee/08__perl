# vim: ft=perl ts=4 sw=4 tw=999 expandtab
# ----------------------------------------------------------------------------
# 160615_235836
# ----------------------------------------------------------------------------
use strict;
use warnings;

our $regex;

# 1. Date
	A. Format: dd/mm/yyyy

	Function:
	01/01/1900 through 31/12/2099
	Accepts dashes, spaces, forward slashes and dots as date separators
	Matches invalid dates such as February 31st

	Pattern:
	$regex = qr/(0[1-9]|[12][0-9]|3[01])[- \/.](0[1-9]|1[012])[- \/.](19|20)[0-9]{2}/;

	B. Format: mm/dd/yyyy

	Function:
	01/01/1900 through 12/31/2099
	Accepts dashes, spaces, forward slashes and dots as date separators
	Matches invalid dates such as February 31st

	Pattern:
	(0[1-9]|1[012])[- \/.](0[1-9]|[12][0-9]|3[01])[- \/.](19|20)[0-9]{2}

	C. Format: yyyy

	Function: Validate year from 1900 to 2999

	Pattern:
	^([1][9]\d\d|[2]\d\d\d)$

2. Numbers
	Function: Only allow number 0 - 9 to be entered, no other funny irrelevant symbols

	Pattern:
	^\d+$

3. Email
	Function: Validate Email Address

	Pattern:
	[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?

4. Website Address
	Function: Validate Website Address, domain name, and must be begin with http:// or https://

	Pattern:
	http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?¡±>


5. Characters and Numbers Only
	Function: only allow characters and numbers, no space or funny symbols. Suitable for Vehicle VIN Numbers

	Pattern:
	(\w(\d)?)+


6. Credit Card Numbers
	A. Format: 1111222233334444 (bare numbers)

	Function: Validate Non-grouped credit card numbers

	Pattern:
	^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$

	B. Format: 1111 2222 3333 4444 or 1111-2222-3333-4444 (grouped numbers)

	Function: Validate grouped credit card numbers

	Pattern:
	^(?:4\d{3}[ -]*\d{4}[ -]*\d{4}[ -]*\d(?:\d{3})?|5[1-5]\d{2}[ -]*\d{4}[ -]*\d{4}[ -]*\d{4}|6(?:011|5[0-9]{2})[ -]*\d{4}[ -]*\d{4}[ -]*\d{4}|3[47]\d{2}[ -]*\d{6}[ -]*\d{5}|3(?:0[0-5]|[68][0-9])\d[ -]*\d{6}[ -]*\d{4}|(?:2131|1800)[ -]*\d{6}[ -]*\d{5}|35\d{2}[ -]*\d{4}[ -]*\d{4}[ -]*\d{4})$


7. Phone Number:Function: Validate 10 digits phone number pattern. 3334445555, 333.444.5555, 333-444-5555, 333 444 5555, (333) 444 5555

Pattern:
\(?\b[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}\b

8. Words:Function: Match one of the words from the list ? replace word1 word2 word3 as you wish, it is ok to add more

Pattern:
\b(?:word1|word2|word3)\b

9. IP4 Address:Function: Matches 0.0.0.0 through 999.999.999.999

Pattern:
\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b

10. IP6 Address:Function: 6 hexadecimal words, followed by 4 decimal bytes, all with optional leading zeros

Pattern:
(?


11. Domain Name:Function: Allow internationalized domains using punycode notation, as well as regular domain names

Pattern:
\b((xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\b

12. US Social Security Numbers:Function: US Social Security Numbers 123121234 or 123-12-1234

Pattern:
\b(?!000)(?!666)(?:[0-6]\d{2}|7(?:[0-356]\d|7[012]))[- ](?!00)\d{2}[- ](?!0000)\d{4}\b

13. PasswordA. Format: Complex Password

Function: Consists of 6 or more characters. The input must contain at least one upper case letter, one lower case letter and one digit.

Pattern:
\A(?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9])\S{6,}\z

B. Format: Alphanumeric Password

Function: consists of 6 or more letters, digits, underscores and hyphens. Password must also contain at least one upper case letter, one lower case letter and one digit.

Pattern:
\A(?=[-_a-zA-Z0-9]*?[A-Z])(?=[-_a-zA-Z0-9]*?[a-z])(?=[-_a-zA-Z0-9]*?[0-9])[-_a-zA-Z0-9]{6,}\z


14. US Zip Code:Function: Validate US Zip Code

Pattern:
\b[0-9]{5}(?:-[0-9]{4})?\b


15.
/.*/ matches anything.
/colo(u|)r/ matches either "color" or "colour". (This can also be written /colou?r/.)
/(0|1|2|3|4|5|6|7|8|9)*(1|3|5|7|9)/ matches all odd positive integers. (Shorter written as /[0-9]*[13579]/. -- ChristofferHammarstrom)
/(1|)(0(0*)1)*(0*)/ matches all strings of 0s and 1s without two 1s in a row.
/0?[1-9]|[12][0-9]|3[01]/ matches all valid days of the months with 31 days.

16. Any number - integer or floating point number
my $regex = qr/[-+]?(?:[0-9]*[.])?[0-9]+(?:[eE][-+]?\d+)?/;
