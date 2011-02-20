package Sid::Api::DebugMsg;
use strict;
use warnings;
use parent 'Sid::Api::Msg';
use Time::HiRes ();

sub new {
    my $class = shift;
    my $self = $class->SUPER::new( @_ );
    $self->{_start} = [Time::HiRes::gettimeofday];
    return $self;
}

sub start { $_[0]->{_start} }

sub _edit_preset_msg {
    my ($self, $msg) = @_;

    my $now = _now();
    my $elapsed = Time::HiRes::tv_interval($self->start, [Time::HiRes::gettimeofday]);

    return "[$now] $msg ( $elapsed sec )";
}

### copied from Log::Minimal
sub _now {
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);

    my $time = sprintf(
        "%04d-%02d-%02dT%02d:%02d:%02d",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );
}

1;

