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
use Switch;
use Statistics::Basic qw( :all );

my $VERSION = '0.21.10';

my $result = 0;

my @puzzle_data = read_lines $main::puzzle_data_file;
my %values = qw/) 1 ] 2 } 3 > 4/;
my $score = 0;
my @bonuses;
for (@puzzle_data) {
    my $valid = 1;
    my $corrupt = 0;
    my @line = split //;
    my @stack;
    my $test;
    my $pos = 0;
    while (!$corrupt && $pos < @line) {
        switch ($line[$pos]) {
            case '('  { push @stack, ')'; }
            case ')'  {
                if (@stack) {
                    $test = pop @stack;
                    if (')' ne $test) {
                        $score += 3;
                        $corrupt = 1;
                    }
                }
            }
            case '['  { push @stack, ']'; }
            case ']'  {
                if (@stack) {
                    $test = pop @stack;
                    if (']' ne $test) {
                        $score += 57;
                        $corrupt = 1;
                    }
                }
            }
            case '{'  { push @stack, '}'; }
            case '}'  {
                if (@stack) {
                    $test = pop @stack;
                    if ('}' ne $test) {
                        $score += 1197;
                        $corrupt = 1;
                    }
                }
            }
            case '<'  { push @stack, '>'; }
            case '>'  {
                if (@stack) {
                    $test = pop @stack;
                    if ('>' ne $test) {
                        $score += 25137;
                        $corrupt = 1;
                    }
                }
            }
        }
        $pos++;
    }
    if (!$corrupt && 0 != @stack) {
        my $bonus = 0;
        for (reverse @stack) {
            $bonus = $bonus * 5 + $values{$_};
        }
        push @bonuses, $bonus;
    }
}




# Part 1
$result = $score;
report_number(1, $result);

exit unless $main::do_part_2;
# Part 2
$result = 0+median(sort{$a<=>$b}@bonuses);
#@bonuses = sort {$a<=>$b} @bonuses;

#$result = mode(@bonuses);
report_number(2, $result);


1;
