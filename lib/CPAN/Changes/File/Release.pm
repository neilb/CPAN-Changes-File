package CPAN::Changes::File::Release;

use Moo;

has version => (is => 'ro');
has date    => (is => 'ro');
has note    => (is => 'ro');
has body    => (is => 'ro');
has bullets => (is => 'lazy');

# my @BULLET_CHARS = ( '*', '-', '+' );
my @BULLET_CHARS = qw/ * - + /;
my $BULLET_REGEXP = join('|', map { "\Q$_\E" } @BULLET_CHARS);

sub _build_bullets
{
    my $self     = shift;
    my $bullets  = [];
    my $inbullet = 0;
    my $current_bullet;
    my $current_indent;
    local $_;

    return undef unless $self->body;

    LINE:
    for (split(/\n/, $self->body)) {

        if (/^\s*?\t/) {
            # give up if we see a tab character
            return undef;
        }

        if (/^(\s*)($BULLET_REGEXP)\s+(.*)/) {
            push(@$bullets, $current_bullet) if $inbullet;
            $current_bullet = $3;
            $current_indent = $1;
            $inbullet       = 1;
            next LINE;
        }

        $current_bullet .= $_ if $inbullet;

    }
    push(@$bullets, $current_bullet) if $inbullet && $current_bullet =~ /\S/;

    return $bullets;
}

1;
