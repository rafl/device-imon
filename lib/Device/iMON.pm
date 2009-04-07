use MooseX::Declare;

class Device::iMON {
    use Device::iMON::Constants -all;
    use MooseX::AttributeHelpers;
    use MooseX::Method::Signatures;
    use MooseX::Types::Moose qw/Str CodeRef/;
    use MooseX::Types::Path::Class qw/File/;
    use AnyEvent;

    clean;

    has device => (
        is       => 'ro',
        isa      => File,
        required => 1,
        coerce   => 1,
        default  => '/dev/lcd/0',
    );

    has fh => (
        is      => 'ro',
        builder => '_build_fh',
    );

    has data_buf => (
        metaclass => 'String',
        is        => 'ro',
        isa       => Str,
        provides  => {
            append => 'send_bytes',
        },
        curries   => {
            substr => { get_data_chunk => sub { $_[1]->($_[0], 0, 8, '') } },
        },
    );

    has write_watcher => (
        is        => 'ro',
        lazy      => 1,
        builder   => '_build_write_watcher',
        predicate => 'has_write_watcher',
        clearer   => 'clear_write_watcher',
    );

    has on_empty_buffer => (
        is        => 'ro',
        isa       => CodeRef,
        predicate => 'has_on_empty_buffer',
    );

    method _build_fh {
        return $self->device->openw;
    }

    method _build_write_watcher {
        AnyEvent->io(
            fh   => $self->fh,
            poll => 'w',
            cb   => sub {
                my $len = $self->fh->syswrite($self->get_data_chunk, 8);
                confess 'command write failed' unless $len == 8;
                unless (length $self->data_buf) {
                    $self->clear_write_watcher;
                    $self->invoke_on_empty_buffer;
                }
            },
        );
    }

    method invoke_on_empty_buffer {
        return unless $self->has_on_empty_buffer;
        $self->on_empty_buffer->($self);
    }

    before send_bytes (Str $bytes where { length($_) == 8 }) {
        use Data::Dump qw/pp/;
        pp unpack('B*', $bytes);
        $self->write_watcher unless $self->has_write_watcher;
    }

    method send_data (Int $value) {
        my $data = join q{}, map chr, reverse map { ($value & (0xff << ($_ * 8))) >> ($_ * 8) } 0 .. 7;
        $self->send_bytes($data);
    }

    method send_command (Int $command) {
        my $data = join q{}, map chr, map { ($command >> ($_ * 8)) & 0xff } 0 .. 7;
        $self->send_bytes($data);
    }

    method turn_on {
        $self->send_command(COMMAND_DISPLAY_ON);
    }

    method clear_alarm {
        $self->send_command(COMMAND_CLEAR_ALARM);
    }

    method set_contrast (Int $percent = 25 where { $_ >= 0 && $_ <= 100 }) {
        # the hardware seems to understand 0 - 40. 25% seems to be a good value
        $self->send_command(COMMAND_SET_CONTRAST + $percent / 2.5);
    }
}

1;
