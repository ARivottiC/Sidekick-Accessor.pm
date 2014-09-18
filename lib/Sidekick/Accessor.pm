#!/usr/bin/perl
package Sidekick::Accessor;

use v5.10;

use strict;
use warnings;

use Log::Log4perl qw(:nowarn);
use Module::Pluggable::Object ();

my %Plugin;
my $logger = Log::Log4perl->get_logger;

sub new {
    my $self = shift;
    my %arg  = @_;
    my $data = delete $arg{'data'}
        || $logger->logcroak(q{required parameter 'data'});

    if ( my $class = $Plugin{ ref( $data ) } ) {
        return $class->new( %arg, 'data' => $data );
    }

    return $data;
}

# dinamically add is_* methods based on plugins
my $finder = Module::Pluggable::Object->new(
        'package' => __PACKAGE__, 'require' => 1,
    );

{
    no strict 'refs';
    for my $plugin ( $finder->plugins ) {
        my $name = join( '::', ( split '::', $plugin )[3,] );
        $logger->trace('mapped ', $plugin, ' as ', $name);
        $Plugin{ $name } = $plugin;
    }
}

1;
# ABSTRACT: we'll get there
# vim:ts=4:sw=4:syn=perl
