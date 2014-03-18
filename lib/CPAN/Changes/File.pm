package CPAN::Changes::File;

use Moo;
use File::Slurp;
use Carp;

use CPAN::Changes::File::Release;

has string   => (is => 'rw');
has path     => (is => 'rw');
has preamble => (is => 'rw');
has title    => (is => 'rw');
has releases => (is => 'rw');

sub BUILD
{
    my $self = shift;

    if ($self->string) {
        $self->_parse_changes_string($self->string);
    }
    elsif ($self->path) {
        my $string = read_file($self->path);
        $self->_parse_changes_string($string);
        $self->string($string);
    }
    else {
        croak "you must provide a string or path";
    }
}

sub _parse_changes_string
{
    my $self      = shift;
    my $string    = shift;
    my $inheader  = 1;
    my $inrelease = 0;
    my $body;
    my $title;
    my $line;
    my @header;
    my @releases;
    my ($version, $date, $note);
    local $_;

    LINE:
    for (split(/\n/, $string)) {

        if (/^[0-9]/) {

            if ($inheader) {
                my $preamble = join('', @header);
                $self->preamble($preamble) if $preamble =~ /\S/ms;
                $self->title($title) if defined($title);
                $inheader = 0;
            }

            if ($inrelease) {
                my @args = (version => $version);

                push(@args, date => $date) if defined($date);
                push(@args, note => $note) if defined($note);
                push(@args, body => $body) if $body =~ /\S/ms;

                push(@releases, CPAN::Changes::File::Release->new(@args));
            }

            ($version, $date, $note) = $self->_parse_release_header($_);
            $body = '';
            $inrelease = 1;

            next LINE;
        }

        if ($inheader) {
            if (/^(change|revision history)/i && !defined($title)) {
                $title = $_;
            }
            else {
                push(@header, "$_\n");
            }
            next LINE;
        }

        $body .= "$_\n" if $inrelease;

    }

    my @args = (version => $version);
    push(@args, date => $date) if defined($date);
    push(@args, note => $note) if defined($note);
    push(@args, body => $body) if $body =~ /\S/ms;
    push(@releases, CPAN::Changes::File::Release->new(@args));

    $self->releases([@releases]);

}

sub _parse_release_header
{
    my ($self, $line) = @_;
    my ($version, $date, $note);

    if ($line =~ /^([0-9]\S*)\s*(.*)$/) {
        $version = $1;
        $line    = $2;
    }

    if ($line =~ /^(\d\d\d\d-\d\d-\d\d)\s*(.*)$/) {
        $date = $1;
        $line = $2;
    }

    return ($version, $date, $note);
}

1;

