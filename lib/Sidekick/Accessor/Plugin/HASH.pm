#!/usr/bin/perl
package Sidekick::Accessor::Plugin::HASH;

use strict;
use warnings;

use Sidekick::Accessor ();
use Hash::Util::FieldHash ();

Hash::Util::FieldHash::fieldhash my %Data;

use overload
    '%{}'      => sub { $Data{ shift() } },
    'fallback' => 1;

my $logger = Log::Log4perl->get_logger;

sub new {
    my $class = shift;
    my %arg   = @_;
    my $data  = delete $arg{'data'};

    croak 'data must be an HASH ref'
        unless ref $data eq 'HASH';

    my $self  = bless \( my $o ), ref $class || $class;

    for my $key ( keys %{ $data } ) {
        $data->{ $key } = Sidekick::Accessor->new(
            %arg, 'data' => $data->{ $key }
        );
    }

    if ( $arg{'ro'} ) {
        Internals::SvREADONLY %{ $data }, 1;

        for my $value ( values %{ $data } ) {
            Internals::SvREADONLY $value, 1;
        }
    }
    $Data{ $self } = $data;

    return $self;
}

sub AUTOLOAD {
    my $self  = shift;
    my ($key) = ( our $AUTOLOAD =~ /([^:]+)$/ );

    return if $key eq 'DESTROY';

    return $Data{ $self }{ $key };
}

1;
# ABSTRACT: we'll get there
# vim:ts=4:sw=4:syn=perl
