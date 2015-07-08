#!/usr/bin/perl -w
use strict;
use base "y2logsstep";
use testapi;

sub enter_software_selection() {
    if (check_var('VIDEOMODE', 'text')) {
        send_key 'alt-c';
        assert_screen 'inst-overview-options', 3;
        send_key 'alt-s';
    }
    else {
        send_key_until_needlematch 'packages-section-selected', 'tab';
        send_key 'ret';
    }
}


sub run() {
    my $self = shift;

    # overview-generation
    # this is almost impossible to check for real
    assert_screen "inst-overview", 15;

    # Reduce installation size Install by leaving out recommended packages
    if (get_var("NORECOMMENDS")) {
        enter_software_selection;

        wait_idle 1;
        send_key 'alt-d'; # Details

        wait_idle 1;
        send_key 'alt-d'; # Dependencies

        # Check if checked
        if (check_screen("inst_recommended_packages_checked",1)) {
            send_key 'alt-r'; # Uncheck Install Recommended Packages
        }

        wait_idle 1;
        send_key 'alt-a'; # Accept

        wait_idle 1;
        # Changes dialog appears
        send_key 'alt-o'; # Continue
    }

    # preserve it for the video
    wait_idle 10;

    # check for dependency issues, if found, drill down to software selection, take a screenshot, then die
    if (check_screen("inst-overview-dep-warning",1)){
        record_soft_failure;
        enter_software_selection;
        assert_screen 'dependancy-issue'; #make sure the dependancy issue is actually showing

        if (get_var("WORKAROUND_DEPS")) {
            while ( check_screen 'dependancy-issue', 5 ) {
                if (check_var('VIDEOMODE', 'text')) {
                    send_key 'alt-s', 3;
                }
                else {
                    send_key 'alt-1', 3;
                }
                send_key 'spc', 3;
                send_key 'alt-o', 3;
            }
            send_key 'alt-a', 3;
            send_key 'alt-o', 3;
            assert_screen "inst-overview-after-depfix", 15; # Make sure you're back on the inst-overview before doing anything else
        }
        else {
            save_screenshot;
            die 'Dependancy Problems';
        }
    }
}

1;
# vim: set sw=4 et:
