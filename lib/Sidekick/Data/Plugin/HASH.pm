#!/usr/bin/perl
package Sidekick::Data::Plugin::HASH;

use strict;
use warnings;

use Sidekick::Data ();
use Hash::Util::FieldHash ();
use Log::Log4perl qw(:nowarn);

Hash::Util::FieldHash::fieldhashes \my( %Data, %Sub );

use overload
    '%{}'      => sub {
        my $self = shift;
        my $sub  = $Sub{ $self };
        return $self->$sub;
    },
    'fallback' => 1;

my $logger = Log::Log4perl->get_logger;

# For internal functions
my ($rw, $ro);

sub new {
    my $class = shift;
    my %arg   = @_;
    my $data  = delete $arg{'data'};

    $logger->logcroak('data must be an HASH ref')
        unless ref $data eq 'HASH';

    my $self  = bless \( my $o ), ref $class || $class;

    for my $key ( keys %{ $data } ) {
        $data->{ $key } = Sidekick::Data->new( %arg, 'data' => $data->{ $key } );
    }

    $Sub{  $self } = $arg{'ro'} ? $ro : $rw;
    $Data{ $self } = $data;

    return $self;
}

$rw = sub { return $Data{ shift() } };
$ro = sub { return { %{ $Data{ shift() } } } };

sub AUTOLOAD {
    my $self  = shift;
    my ($key) = ( our $AUTOLOAD =~ /([^:]+)$/ );

    return if $key eq 'DESTROY';

    return $Data{ $self }{ $key };
}

1;
# ABSTRACT: we'll get there
# vim:ts=4:sw=4:syn=perl
