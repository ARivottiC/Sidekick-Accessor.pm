#!/usr/bin/perl
package Sidekick::Data;

use strict;
use warnings;

use Hash::Util::FieldHash ();

Hash::Util::FieldHash::fieldhash my %Hash;

use overload
    '%{}'      => sub { return { %{ $Hash{ shift() } } } },
    'fallback' => 1;

sub new {
    my $class = shift;
    my %arg   = @_;

    my $self  = bless \( my $o ), ref $class || $class;

    $Hash{ $self } = { %arg };

    return $self;
}

1;
# ABSTRACT: we'll get there
# vim:ts=4:sw=4:syn=perl
