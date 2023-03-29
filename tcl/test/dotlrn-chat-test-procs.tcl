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

aa_register_case -procs {
        dotlrn_chat::add_applet
        dotlrn_chat::add_portlet
        dotlrn_chat::remove_portlet
        dotlrn_chat::remove_applet
        portal::exists_p
    } -cats {
        api
    } dotlrn_chat__applet_portlet {
        Test add/remove applet/portlet procs.
} {
    #
    # Helper proc to check portal elements
    #
    proc portal_elements {portal_id} {
        return [db_string elements {
            select count(1)
            from portal_element_map pem,
                 portal_pages pp
           where pp.portal_id = :portal_id
             and pp.page_id = pem.page_id
        }]
    }
    #
    # Start the tests
    #
    aa_run_with_teardown -rollback -test_code {
        #
        # Create test user
        #
        # As this is running in a transaction, it should be cleaned up
        # automatically.
        #
        set portal_user_id [db_nextval acs_object_id_seq]
        set user_info [acs::test::user::create -user_id $portal_user_id]
        #
        # Create portal
        #
        set portal_id [portal::create $portal_user_id]
        if {[portal::exists_p $portal_id]} {
            aa_log "Portal created (portal_id: $portal_id)"
            if {[dotlrn_applet::get_applet_id_from_key -applet_key [dotlrn_chat::applet_key]] ne ""} {
                #
                # Remove the applet in advance, if it already exists
                #
                dotlrn_chat::remove_applet
                aa_log "Removed existing applet"
            }
            #
            # Add applet
            #
            dotlrn_chat::add_applet
            aa_true "Add applet" "[expr {[dotlrn_applet::get_applet_id_from_key -applet_key [dotlrn_chat::applet_key]] ne ""}]"
            #
            # Add portlet to portal
            #
            dotlrn_chat::add_portlet $portal_id
            aa_equals "Number of portal elements after addition" "[portal_elements $portal_id]" "1"
            #
            # Remove portlet from portal
            #
            set args [ns_set create]
            ns_set put $args package_id 0
            dotlrn_chat::remove_portlet $portal_id $args
            aa_equals "Number of portal elements after removal" "[portal_elements $portal_id]" "0"
        } else {
            aa_error "Portal creation failed"
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
