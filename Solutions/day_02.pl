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

my $VERSION = '0.21.02';

my $result;

my @puzzle_data = read_lines $main::puzzle_data_file;

# Part 1
my %position = (
    forward => 0,
    up => 0,
    down => 0,
);
foreach my $move (@puzzle_data) {
    my ($direction, $distance) = split ' ', $move;
    $position{$direction} += $distance;
}
$result = $position{'forward'} * ($position{'down'} - $position{'up'});
report_number(1, $result);

exit unless $main::do_part_2;
# Part 2

%position = (
    forward => 0,
    aim => 0,
    depth => 0,
);
foreach my $move (@puzzle_data) {
    my ($direction, $distance) = split ' ', $move;
    if ('forward' eq $direction) {
        $position{'forward'} += $distance;
        $position{'depth'} += $position{'aim'} * $distance;
    } else {
        $position{'aim'} += $distance * (('down' eq $direction)? 1 : -1); 
    }
}
$result = $position{'forward'} * $position{'depth'};
report_number(2, $result);

    
1;
