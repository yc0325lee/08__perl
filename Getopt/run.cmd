:: vim: ft=dosbatch ts=4 sw=4 tw=999 expandtab
@echo off
perl GetOpt_Long.pl --all --lib lib/stdlib --lib lib/extlib
perl GetOpt_Long.pl --width 5
perl GetOpt_Long.pl --length 3.14
perl GetOpt_Long.pl --lib /user/lib/stdlib --lib /user/lib/site/extlib
perl GetOpt_Long.pl --define OS=linux --define VENDOR=redhat
