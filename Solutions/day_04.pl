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
use List::Util qw(sum);

my $VERSION = '0.21.04';

my $result = 0;

my @bingo_data = read_lined_table $main::puzzle_data_file;
sub read_card {
    my ($card_table, $card_id, $locations) = @_;
    my $card_marks = {
        Diagonal => 0,
        Slash => 0,
        Total => 0,
        InPlay => 1,
    };
    for my $rank (0..$#{$card_table}) {
        $card_marks->{"Rank:$rank"} = 0;
        for my $file (0..$#{$card_table->[$rank]}) {
            $card_marks->{"File:$file"} = 0 if 0 == $rank;
            if ( defined $locations->{$card_table->[$rank][$file]} ) {
                push @{$locations->{$card_table->[$rank][$file]}}, join ':', $card_id, $rank, $file;
            } else {
                $locations->{$card_table->[$rank][$file]} = [join ':', $card_id, $rank, $file];
            }
            $card_marks->{"Total"} += $card_table->[$rank][$file];
        }
    }
    return $card_marks;
}


# Part 1
my @draws = split /,/, $bingo_data[0]->[0][0];
my %locations;
my $card_marks = {};
for my $card_id (1..$#bingo_data) {
    $card_marks->{$card_id} = read_card($bingo_data[$card_id], $card_id, \%locations);
}
my ($draw, $drawing, $winner) = (0) x 3;
while (! $winner) {
    $draw = $draws[$drawing];
    for ($locations{$draw}) {
        for (@$_) {
            my ($c_id, $r_id, $f_id) = split /:/, $_;
            $card_marks->{$c_id}{"Total"} -= $draw;
            $card_marks->{$c_id}{"Rank:".$r_id}++;
            $winner = $c_id if ($card_marks->{$c_id}{"Rank:".$r_id} > $#{$bingo_data[1]->[0]});
            $card_marks->{$c_id}{"File:".$f_id}++;
            $winner = $c_id if ($card_marks->{$c_id}{"File:".$f_id} > $#{$bingo_data[1]->[0]});
            $card_marks->{$c_id}{"Diagonal"}++ if $r_id == $f_id;
#           $winner = $c_id if ($card_marks->{$c_id}{"Diagonal"} > $#{$bingo_data[1]->[0]});
            $card_marks->{$c_id}{"Slash"}++ if ($r_id + $f_id) == $#{$bingo_data[1]->[0]};
#           $winner = $c_id if ($card_marks->{$c_id}{"Slash"} > $#{$bingo_data[1]->[0]});
        }
    }
    if (++$drawing > $#draws) {
        $winner = -1;
    }
}
$result = $card_marks->{$winner}{"Total"} * $draw;
report_number(1, $result);

exit unless $main::do_part_2;
# Part 2

$card_marks = {};
%locations = ();
for my $card_id (1..$#bingo_data) {
    $card_marks->{$card_id} = read_card($bingo_data[$card_id], $card_id, \%locations);
}
my @winner_list = (1);
for (keys %$card_marks) {
    $winner_list[$_] = 1;
}
$winner = 0;
$result = 0;
($draw, $drawing, $winner) = (0) x 3;
while ( 1 < sum(@winner_list) ) {
    $draw = $draws[$drawing];
    for ($locations{$draw}) {
        for (@$_) {
            my ($c_id, $r_id, $f_id) = split /:/, $_;
            if (1 == $card_marks->{$c_id}{"InPlay"}) {
                $card_marks->{$c_id}{"Total"} -= $draw;
                $card_marks->{$c_id}{"Rank:".$r_id}++;
                $winner = $c_id if ($card_marks->{$c_id}{"Rank:".$r_id} > $#{$bingo_data[1]->[0]});
                $card_marks->{$c_id}{"File:".$f_id}++;
                $winner = $c_id if ($card_marks->{$c_id}{"File:".$f_id} > $#{$bingo_data[1]->[0]});
                $card_marks->{$c_id}{"Diagonal"}++ if $r_id == $f_id;
#               $winner = $c_id if ($card_marks->{$c_id}{"Diagonal"} > $#{$bingo_data[1]->[0]});
                $card_marks->{$c_id}{"Slash"}++ if ($r_id + $f_id) == $#{$bingo_data[1]->[0]};
#               $winner = $c_id if ($card_marks->{$c_id}{"Slash"} > $#{$bingo_data[1]->[0]});
                if ($winner) {
                    $result = $card_marks->{$c_id}{"Total"} * $draw;
                    $card_marks->{$c_id}{"InPlay"} = 0;
                    $winner_list[$winner] = 0;
                    $winner = 0;
                }
            }
        }
    }
    ++$drawing;
}
report_number(2, $result);

1;
