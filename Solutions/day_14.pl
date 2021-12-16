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
use Data::Dumper;

my $VERSION = '0.21.14';

my $result = 0;

my @puzzle_data = read_lines $main::puzzle_data_file;
my $template = shift @puzzle_data;
shift @puzzle_data;
my $element;
my $rule = {map{my($a,$b,$c)=$_=~/(.)(.)\s-\>\s(.)/;$$element{$c}=0;"$a$b"=>["$a$c","$c$b",$c];}(@puzzle_data)};
my $key;
while ($template =~ /(.)(?=(.))/g) {
    $$key{"$1$2"}++;
    $$element{$1}++;
}
$$element{substr($template,-1,1)}++;

sub insertion {
    my ($rule, $element, $key, $made) = @_;
    map {$$element{$$rule{$_}->[2]} += $$key{$_}; my $k = $_; map {$$made{$$rule{$k}->[$_]} += $$key{$k}}(0..1)}(keys %$key);
    return $made;
}


# Part 1

$key = insertion($rule, $element, $key) for (1..10);
my ($min,$max) = (sort {$$element{$a}<=>$$element{$b}} (keys %$element))[0,-1];
$result = $$element{$max} - $$element{$min};
report_number(1, $result);

exit unless $main::do_part_2;
# Part 2

report_number(2, $result);


1;
