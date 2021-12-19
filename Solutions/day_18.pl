#! /usr/bin/env perl
# SPDX-License-Identifier: MIT

########################################################################
#                                                                      #
#  This file is part of the solution set for the programming puzzles   #
#  presented by the 2021 Advent of Code challenge.                     #
#  See: https://adventofcode.com/2021                                  #
#                                                                      #
#  Copyright © 2021  Chindraba (Ronald Lamoreaux)                      #
#                    <aoc@chindraba.work>                              #
#  - All Rights Reserved                                               #
#                                                                      #
#  Permission is hereby granted, free of charge, to any person         #
#  obtaining a copy of this software and associated documentation      #
#  files (the "Software"), to deal in the Software without             #
#  restriction, including without limitation the rights to use, copy,  #
#  modify, merge, publish, distribute, sublicense, and/or sell copies  #
#  of the Software, and to permit persons to whom the Software is      #
#  furnished to do so, subject to the following conditions:            #
#                                                                      #
#  The above copyright notice and this permission notice shall be      #
#  included in all copies or substantial portions of the Software.     #
#                                                                      #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,     #
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  #
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               #
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS #
#  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN  #
#  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   #
#  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE    #
#  SOFTWARE.                                                           #
#                                                                      #
########################################################################

use 5.030000;
use strict;
use warnings;
use Elves::GetData qw( :all );
use Elves::Reports qw( :all );

my $VERSION = '0.21.18';

my $result = 0;

my @snail_nums = read_lines $main::puzzle_data_file;

my ($snail_num, $sum);

sub exploded {
    my $copy = $snail_num;
    my $nibbler = qr/^(?<char>\d+|\[|\]|,)(?<snail_num>.*)$/;
    my $closer = qr/^(?<left>\d+),(?<right>\d+)\](?<rfill>\D+)(?:(?<post>\d+)(?<tail>.*))?$/;
    my ($level, $char, $head, $prior, $lfill);
    $level = 0;
    $char = $head = $lfill = '';
    $prior = -1;
    while (5 > $level && 0 < length($snail_num)) {
        $lfill .= $char;
        $snail_num =~ /$nibbler/;
        ($char,$snail_num) = ($+{'char'}, $+{'snail_num'});
        $level++ if '[' eq $char;
        $level-- if ']' eq $char;
        if ($char =~ /^\d+$/) {
            if ( -1 != $prior) {
                $head .= $prior;
            }
            $prior = $char;
            $head .= $lfill;
            $lfill = '';
            $char = '';
        }
    }
    if (5 == $level) {
        $snail_num =~ /$closer/;
        $snail_num = join '', (
            $head,
            (-1 !=$prior)? $prior + $+{'left'} : '',
            $lfill,
            0,
            $+{'rfill'},
            (defined $+{'post'})? $+{'post'} + $+{'right'} : '',
            (defined $+{'tail'})? $+{'tail'} : ''
        );
        return 1;#$snail_num;
    } else {
        $snail_num = $copy;
        return 0;
    }
}

# Part 1
for (@snail_nums) {
    if ($snail_num) {
        $snail_num = "[$snail_num,$_]";
    } else {
        $snail_num = $_;
    }
    while (exploded || $snail_num =~ s|(\d{2,})|'['.int($1/2).','.int($1/2+.5).']'|e ) {;}
}

$result = $snail_num;
while ($result =~ s/\[(?<left>\d+),(?<right>\d+)\]/3 * $+{'left'} + 2 * $+{'right'}/eg ) { ; }

report_number(1, $result);

die 'Not running part 2 yet.' unless $main::do_part_2;
# Part 2

report_number(2, $result);


1;
