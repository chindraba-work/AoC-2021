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
my $VERSION = '0.21.03';

my $result = 0;
my @puzzle_data = read_lines $main::puzzle_data_file;
my $bit_count = length $puzzle_data[0];
my @sums = (0) x $bit_count;
-- $bit_count;

sub sieve {
    my ($go_low, $list) = @_;
    my ($step) = (0);
    while (1 < @$list) {
        my ($filter, $aughts, $naughts);
        $filter = "^" . '.' x $step++ . '0';
        @$naughts = grep /$filter/, @$list;
        @$aughts = grep !/$filter/, @$list;
        if ( -1 == $aughts ) {
            $list = $naughts;
        } elsif ( -1 == $naughts ) {
            $list = $aughts;
        } elsif ( @$naughts == @$aughts ) {
            $list = ($go_low)? $naughts : $aughts;
        } else {
            $list = (@$naughts < @$aughts)? ($go_low) ? $naughts : $aughts : ($go_low)? $aughts : $naughts;
        }
    }
    return @$list[0];
}

# Part 1
for (@puzzle_data) {
    my @bits = split //, $_;
    for (0..$bit_count) {
        $sums[$_] += $bits[$_];
    }
}
for (@sums) {
    $_ = int($_ / @puzzle_data + .5);
}
my $val = eval("0b" . join '', @sums);
$result = $val * ($val ^ (2 ** @sums - 1));
report_number(1, $result);

exit unless $main::do_part_2;
# Part 2
$result = eval("0b".sieve(0, \@puzzle_data)) * eval("0b".sieve(1, \@puzzle_data));
report_number(2, $result);

    
1;
