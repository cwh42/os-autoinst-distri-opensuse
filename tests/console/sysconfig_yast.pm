use base "consoletest";
use strict;
use testapi;

# Check value of PKGMGR_INSTALL_RECOMMENDED in /etc/sysconfig/yast2
sub run() {
    my $self = shift;
    
    script_run("grep '^PKGMGR_INSTALL_RECOMMENDED=' /etc/sysconfig/yast2 | tee /dev/$serialdev");

    if (get_var("NORECOMMENDS")) {
        wait_serial('PKGMGR_INSTALL_RECOMMENDED="no"', 10) || die "PKGMGR_INSTALL_RECOMMENDED should be 'no'";
    }
    else {
        wait_serial('PKGMGR_INSTALL_RECOMMENDED="yes"', 10) || die "PKGMGR_INSTALL_RECOMMENDED should be 'yes'";
    }
}

1;
# vim: set sw=4 et:
