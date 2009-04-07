package Device::iMON::Constants;

use strict;
use warnings;

no warnings 'portable'; # FIXME

use constant {
    COMMAND_DISPLAY_BYTE => 0x8800000000000000,
    COMMAND_ALARM_BYTE   => 0x8a00000000000000,
};

use constant {
    COMMAND_SET_ICONS    => 0x0100000000000000,
    COMMAND_SET_CONTRAST => 0x03ffffff00580a00,
    COMMAND_DISPLAY      => 0x0000000000000000 | COMMAND_DISPLAY_BYTE,
    COMMAND_SHUTDOWN     => 0x0000000000000008 | COMMAND_DISPLAY_BYTE,
    COMMAND_DISPLAY_ON   => 0x0000000000000040 | COMMAND_DISPLAY_BYTE,
    COMMAND_CLEAR_ALARM  => 0x0000000000000000 | COMMAND_ALARM_BYTE,
    COMMAND_SET_LINES0   => 0x1000000000000000,
    COMMAND_SET_LINES1   => 0x1100000000000000,
    COMMAND_SET_LINES2   => 0x1200000000000000,

    # top line
    ICON_TOPIC_MUSIC   => 0x80,
    ICON_TOPIC_MOVIE   => 0x40,
    ICON_TOPIC_PHOTO   => 0x20,
    ICON_TOPIC_DISC    => 0x10,
    ICON_TOPIC_TV      => 0x08,
    ICON_TOPIC_WEB     => 0x04,
    ICON_TOPIC_WEATHER => 0x02,

    # upper right
    ICON_CHANNEL_L     => 0x01,
    ICON_CHANNEL_C     => (0x80 << 8),
    ICON_CHANNEL_R     => (0x40 << 8),
    ICON_CHANNEL_SL    => (0x20 << 8),
    ICON_CHANNEL_LFE   => (0x10 << 8),
    ICON_CHANNEL_SR    => (0x08 << 8),
    ICON_CHANNEL_RL    => (0x04 << 8),
    ICON_CHANNEL_SPDIF => (0x02 << 8),
    ICON_CHANNEL_RR    => (0x01 << 8),

    # disc icon, upper left
    ICON_DISC_NE     => (0x01 << 40),
    ICON_DISC_E      => (0x02 << 40),
    ICON_DISC_SE     => (0x04 << 40),
    ICON_DISC_S      => (0x08 << 40),
    ICON_DISC_SW     => (0x10 << 40),
    ICON_DISC_W      => (0x20 << 40),
    ICON_DISC_NW     => (0x40 << 40),
    ICON_DISC_N      => (0x80 << 40),
    ICON_DISC_BORDER => (0x80 << 48),

    # left side, below disc
    ICON_REP   => (0x20 << 32),
    ICON_SFL   => (0x10 << 32),
    ICON_ALARM => (0x08 << 32),
    ICON_REC   => (0x04 << 32),
    ICON_VOL   => (0x02 << 32),
    ICON_TIME  => (0x01 << 32),

    # signal sources, lower right
    ICON_SOURCE_SRC  => (0x80 << 16),
    ICON_SOURCE_FIT  => (0x40 << 16),
    ICON_SOURCE_TV   => (0x20 << 16),
    ICON_SOURCE_HDTV => (0x10 << 16),
    ICON_SOURCE_SRC1 => (0x08 << 16),
    ICON_SOURCE_SRC2 => (0x04 << 16),

    # bottom left
    ICON_FORMAT_LEFT_MPG  => (0x02 << 16),
    ICON_FORMAT_LEFT_DIVX => (0x01 << 16),
    ICON_FORMAT_LEFT_XVID => (0x80 << 24),
    ICON_FORMAT_LEFT_WMV  => (0x40 << 24),

    # bottom, center
    ICON_FORMAT_MIDDLE_MPG => (0x20 << 24),
    ICON_FORMAT_MIDDLE_AC3 => (0x10 << 24),
    ICON_FORMAT_MIDDLE_DTS => (0x08 << 24),
    ICON_FORMAT_MIDDLE_WMA => (0x04 << 24),

    # bottom, right
    ICON_FORMAT_RIGHT_MP3 => (0x02 << 24),
    ICON_FORMAT_RIGHT_OGG => (0x01 << 24),
    ICON_FORMAT_RIGHT_WMA => (0x80 << 32),
    ICON_FORMAT_RIGHT_WAV => (0x40 << 32),
};

use Class::MOP;

my @exports;
BEGIN {
    my $meta = Class::MOP::class_of(__PACKAGE__) || Class::MOP::Class->initialize(__PACKAGE__);
    @exports = grep { $_ eq uc $_ } keys %{ $meta->get_all_package_symbols('CODE') };
}

use Sub::Exporter -setup => {
    exports => \@exports,
    groups  => { all => \@exports },
};

1;
