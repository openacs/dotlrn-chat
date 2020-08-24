ad_library {

        Automated tests for the dotlrn-chat package.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10

}

aa_register_case \
    -cats {api smoke production_safe} \
    -procs {
        dotlrn_chat::package_key
        dotlrn_chat::my_package_key
        dotlrn_chat::applet_key
    } \
    dotlrn_chat__keys {

        Simple test for the various dotlrn_chat::..._key procs.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10
} {
    aa_equals "Package key" "[dotlrn_chat::package_key]" "chat"
    aa_equals "My Package key" "[dotlrn_chat::my_package_key]" "dotlrn-chat"
    aa_equals "Applet key" "[dotlrn_chat::applet_key]" "dotlrn_chat"
}

aa_register_case -procs {
        dotlrn_chat::get_pretty_name
    } -cats {
        api
        production_safe
    } dotlrn_chat__names {
        Test diverse name procs.
} {
    aa_equals "Pretty name" "[dotlrn_chat::get_pretty_name]" "[_ dotlrn-chat.pretty_name]"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
