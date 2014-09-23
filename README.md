# NAME

Sidekick::Accessor - we'll get there

# VERSION

version 0.0.1

# SYNOPSIS

    my $hashref = Sidekick::Accessor->new( 'data' => { 'one' => 1, 'two' => 2 } );
    print $hashref->one     ; # same as $hashref->{'one'}
    print keys %{ $hashref };

    my $arrayref = Sidekick::Accessor->new( 'ro' => 1, 'data' => [ 1, 2, 3 ] );
    print $arrayref->item2; # same as $arrayref->[2]
    push @{ $arrayref }, 4; # will croak

# DESCRIPTION

`Sidekick::Accessor` provides a way to access HASH and ARRAY values as methods, while keeping the original Data Type and it's functionality.

# METHODS

## new

## attr ro

## attr data

# PLUGINS

# SEE ALSO

- [Sidekick::Accessor::Plugin::ARRAY](https://metacpan.org/pod/Sidekick::Accessor::Plugin::ARRAY)
- [Sidekick::Accessor::Plugin::HASH](https://metacpan.org/pod/Sidekick::Accessor::Plugin::HASH)

# AUTHOR

André Rivotti Casimiro <rivotti@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by André Rivotti Casimiro.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)
