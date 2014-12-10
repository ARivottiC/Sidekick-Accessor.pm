#!/usr/bin/perl
package Sidekick::Accessor;

use v5.10;

use strict;
use warnings;

use Carp ();
use Module::Pluggable::Object ();

my %Plugin;

sub new {
    my $self = shift;
    my %arg  = @_;
    my $data = delete $arg{'data'}
        || Carp::croak q{required parameter 'data'};

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
        $Plugin{ $name } = $plugin;
    }
}

1;
# ABSTRACT: Access HASH and ARRAY values as methods
# vim:ts=4:sw=4:syn=perl
__END__
=pod

=for :Travis
=for markdown [![Build Status](https://travis-ci.org/ARivottiC/Sidekick-Accessor.pm.svg)](https://travis-ci.org/ARivottiC/Sidekick-Accessor.pm)

=head1 SYNOPSIS

    my $hashref = Sidekick::Accessor->new(
        'data' => { 'one' => 1, 'two' => 2 }
    );
    print $hashref->one     ; # same as $hashref->{'one'}
    print keys %{ $hashref };

    my $arrayref = Sidekick::Accessor->new(
        'ro' => 1, 'data' => [ 1, 2, 3 ]
    );
    print $arrayref->item2; # same as $arrayref->[2]
    push @{ $arrayref }, 4; # will croak


=head1 DESCRIPTION

C<Sidekick::Accessor> provides a way to access HASH and ARRAY values as
methods, while keeping the original Data Type and it's functionality.

=method new

=head1 PLUGINS

=head1 SEE ALSO

=for :list
* L<Sidekick::Accessor::Plugin::ARRAY>
* L<Sidekick::Accessor::Plugin::HASH>

=cut
