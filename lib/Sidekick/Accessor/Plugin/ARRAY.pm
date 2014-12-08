#!/usr/bin/perl
package Sidekick::Accessor::Plugin::ARRAY;

use strict;
use warnings;

use Sidekick::Accessor ();
use Hash::Util::FieldHash ();

Hash::Util::FieldHash::fieldhash my %Data;

use overload
    '@{}'      => sub { $Data{ shift() } },
    'fallback' => 1;

my $logger = Log::Log4perl->get_logger;

sub new {
    my $class = shift;
    my %arg   = @_;
    my $data  = delete $arg{'data'};

    croak 'data must be an ARRAY ref'
        unless ref $data eq 'ARRAY';

    my $self  = bless \( my $o ), ref $class || $class;

    for my $value ( @{ $data } ) {
        $value = Sidekick::Accessor->new( %arg, 'data' => $value );
    }

    if ( $arg{'ro'} ) {
        Internals::SvREADONLY @{ $data }, 1;

        for my $value ( values @{ $data } ) {
            Internals::SvREADONLY $value, 1;
        }
    }
    $Data{ $self } = $data;

    return $self;
}

sub AUTOLOAD {
    my $self  = shift;

    if ( my ($index) = ( our $AUTOLOAD =~ /(\d+)$/ ) ) {
        return $Data{ $self }[ $index ];
    }

    return ;
}

1;
# ABSTRACT: we'll get there
# vim:ts=4:sw=4:syn=perl
