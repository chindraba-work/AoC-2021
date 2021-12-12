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

my $VERSION = '0.21.12';

my $result = 0;
my $part;
my $specials = 0;
my @puzzle_data = read_lines $main::puzzle_data_file;
#@puzzle_data = qw(dc-end HN-start start-kj dc-start dc-HN LN-dc HN-end kj-sa kj-HN kj-dc);
#@puzzle_data = qw(start-A start-b A-c A-b b-d A-end b-end);
my %tubes;
my %small_caves;
for (@puzzle_data) {
    my ($a, $b) = split /-/;
    $a = '<' if ('start' eq $a);
    $b = '<' if ('start' eq $b);
    $a = '}' if ('end' eq $a);
    $b = '}' if ('end' eq $b);
    push @{$tubes{$a}}, $b unless ('}' eq $b || '<' eq $a);
    push @{$tubes{$b}}, $a unless ('}' eq $a || '<' eq $b);
    $small_caves{$a} = 0 if ($a =~ /^[a-z]+$/);
    $small_caves{$b} = 0 if ($b =~ /^[a-z]+$/);
}

# Part 1

sub find_source {
    my ($cave, $tubes, $smalls, @routes) = @_;
    my @new_routes;
    my @possibles = @{$tubes{$cave}};
    for my $possible (@possibles) {
        if ($possible !~ /^[a-z]+$/ || 0 == $smalls->{$possible} ||
                (2 == $part && 0 == $specials && 1 == $smalls->{$possible})) {
            for (@routes) {
                $smalls->{$possible} += 1 if ($possible =~ /^[a-z]+$/);
                $specials = 1 if ($possible =~ /^[a-z]+$/ && 2 == $smalls->{$possible});
                my @temp = [($possible, @{$_})];
                my @new_temp;
                unless ('<' eq $possible) {
                    @new_temp = find_source($possible, $tubes, $smalls, @temp);
                    $specials = 0 if ($possible =~ /^[a-z]+$/ && 2 == $smalls->{$possible});
                    $smalls->{$possible} -= 1 if ($possible =~ /^[a-z]+$/);
                    push @new_routes, @new_temp;
                } else {
                    push @new_routes, @temp;
                }
            }
        }
    }
    return @new_routes;
}
my @routes;
$part = 1;
@routes = find_source('}', \%tubes, \%small_caves, (['}']));
$result = @routes;

report_number(1, $result);

exit unless $main::do_part_2;
# Part 2
$part = 2;
@routes = find_source('}', \%tubes, \%small_caves, (['}']));
$result = @routes;
report_number(2, $result);


1;
