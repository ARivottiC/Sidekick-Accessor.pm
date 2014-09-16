#!/usr/bin/perl
package Sidekick::Data::Plugin::ARRAY;

use strict;
use warnings;

use Sidekick::Data ();
use Hash::Util::FieldHash ();
use Log::Log4perl qw(:nowarn);

Hash::Util::FieldHash::fieldhashes \my( %Data, %Sub );

use overload
    '@{}'      => sub {
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
        unless ref $data eq 'ARRAY';

    my $self  = bless \( my $o ), ref $class || $class;

    for my $value ( @{ $data } ) {
        $value = Sidekick::Data->new( %arg, 'data' => $value );
    }

    $Sub{  $self } = $arg{'ro'} ? $ro : $rw;
    $Data{ $self } = $data;

    return $self;
}

$rw = sub { return $Data{ shift() } };
$ro = sub { return [ @{ $Data{ shift() } } ] };

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
