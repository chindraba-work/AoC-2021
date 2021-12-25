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

my $VERSION = '0.21.25';

my $result = 0;

my @cucumber_mass = read_grid $main::puzzle_data_file;
my $mass = \@cucumber_mass;
sub move_south {
    return unless defined wantarray;
    my $mass = shift;
    my $new_mass = [map { [ map { $_; }($_->@*) ] }($mass->@*)];
    my $movement = 0;
    for (0..$mass->$#*) {
        my $to = $mass->$#* - $_;
        my $from = $to - 1 ;
        $from = $mass->$#* if 0 == $to;
        for (0..$mass->[0]->$#*) {
            if ('v' eq $mass->[$from]->[$_] && '.' eq $mass->[$to]->[$_]) {
                $new_mass->[$to]->[$_] = 'v';
                $new_mass->[$from]->[$_] = '.';
                $movement++;
            }
        }
    }
    return wantarray? ($new_mass, $movement): $new_mass;
}
sub move_east {
    return unless defined wantarray;
    my $mass = shift;
    my $new_mass = [map { [ map { $_; }($_->@*) ] }($mass->@*)];
    my $movement = 0;
    for (0..$mass->[0]->$#*) {
        my $to = $mass->[0]->$#* - $_;
        my $from = $to - 1 ;
        $from = $mass->[0]->$#* if 0 == $to;
        for (0..$mass->$#*) {
            if ('>' eq $mass->[$_]->[$from] && '.' eq $mass->[$_]->[$to]) {
                $new_mass->[$_]->[$to] = '>';
                $new_mass->[$_]->[$from] = '.';
                $movement++;
            }
        }
    }
    return wantarray? ($new_mass, $movement): $new_mass;
}
sub show_grid {
    my $mass = shift;
    say join "\n", map { join $;, $_->@* }($mass->@*);
}
my $moved = 0;
do {
    my $east = 0;
    my $south = 0;
    ($mass, $east) = move_east $mass;
    ($mass, $south) = move_south $mass;
    $moved = (0 < $east || 0 < $south);
    $result++;
    say "Move $result had $east move east and $south move south.";
} while ($moved);

# Part 1

report_number(1, $result);

die 'Not running part 2 yet.' unless $main::do_part_2;
# Part 2

report_number(2, $result);


1;
