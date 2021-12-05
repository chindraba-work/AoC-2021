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
use List::Util qw/min max/;
use Data::Dumper;
my $VERSION = '0.21.05';

my $result = 0;

my @puzzle_data = read_lines $main::puzzle_data_file;
sub map_vents {
    my $vents1 = {};
    my $vents2 = {};
    for (@_) {
        my ($x1,$y1,$x2,$y2) = map {split /,/}(split / -> /);
        if ($x1 == $x2) {
            for (min($y1,$y2)..max($y1,$y2)) {
                $vents1->{$x1}{$_} += 1;
                $vents2->{$x1}{$_} += 1;
            }
        } elsif ($y1 == $y2) {
            for (min($x1,$x2)..max($x1,$x2)) {
                $vents1->{$_}{$y1} += 1;
                $vents2->{$_}{$y1} += 1;
            }
        } else {
            my @x = (min($x1,$x2)..max($x1,$x2));
            @x = reverse @x if ($x1 > $x2);
            my @y = (min($y1,$y2)..max($y1,$y2));
            @y = reverse @y if ($y1 > $y2);
            for (0..$#x) {
                $vents2->{$x[$_]}{$y[$_]} += 1;
            }
        }
    }
    return wantarray? ($vents2,$vents1) : $vents1;
}

        

# Part 1
my $vent_map = map_vents(@puzzle_data);
for my $x (keys %$vent_map) {
    for my $y (keys %{$vent_map->{$x}}) {
        $result++ if 1 < $vent_map->{$x}{$y};
    }
}

report_number(1, $result);

exit unless $main::do_part_2;
# Part 2
$result = 0;
my @vent_maps = map_vents(@puzzle_data);
$vent_map = $vent_maps[0];
for my $x (keys %$vent_map) {
    for my $y (keys %{$vent_map->{$x}}) {
        $result++ if 1 < $vent_map->{$x}{$y};
    }
}
report_number(2, $result);

    
1;
