# Default settings used in configuration options below
default["pnp4nagios"]["version"] = "0.6.12-1~bpo60+1"
default["pnp4nagios"]["config"]["rrdbase"] = "/var/lib/pnp4nagios/perfdata/"
default["rrdcached"]["config"]["socket"] = "unix:/var/run/rrdcached.sock"
default["rrdcached"]["version"] = "1.4.3-1"
default["icinga"]["version"] = "1.7.1-3~bpo60+1"
default["icinga"]["user"] = "nagios"
default["icinga"]["group"] = "nagios"
default["icinga"]["htpasswd"]["file"] = "/etc/icinga/htpasswd.users"
default["check_mk"]["url"] = "http://mathias-kettner.de/download"
default["check_mk"]["version"] = '1.2.1i3'
default["check_mk"]["deb"]["release"] = '2'
default["check_mk"]["rpm"]["release"] = '1'
default["check_mk"]["agent"]["rpm"]["checksum"] = "70aa6f170cde31ada985b7f3892acd4a1c78ef99dc4b10f3a08944f7eaca5f9d"
default["check_mk"]["logwatch"]["rpm"]["checksum"] = "ffa67f28afd84702df44a95f4ee4699ef3afeb75f2b31d4f206af5f242952ba3"
default["check_mk"]["agent"]["deb"]["checksum"] = "357cac4a378ce92c74df55cdf8e4a23c9e2b80467a80de7a00fcf18c0df78ac5"
default["check_mk"]["logwatch"]["deb"]["checksum"] = "4633e3cad98584e2f2b2abb77e3d9247ded6f9d796408df19c75dfc03ac524e9"
default["check_mk"]["source"]["tar"]["checksum"] = "845b3bf16480d8e267b77e88cd1bd3c93b39d15bb0e534b62d12a4086e817045"
default["check_mk"]["groups"] = ["check-mk-admin"]

# Check_mk settings
default["check_mk"]["setup"]["bindir"] = '/usr/bin'
default["check_mk"]["setup"]["confdir"] = '/etc/check_mk'
default["check_mk"]["setup"]["sharedir"] = '/usr/share/check_mk'
default["check_mk"]["setup"]["docdir"] = '/usr/share/doc/check_mk'
default["check_mk"]["setup"]["checkmandir"] = '/usr/share/doc/check_mk/checks'
default["check_mk"]["setup"]["vardir"] = '/var/lib/check_mk'
default["check_mk"]["setup"]["agentslibdir"] = '/usr/lib/check_mk_agent'
default["check_mk"]["setup"]["agentsconfdir"] = '/etc/check_mk'
default["check_mk"]["setup"]["nagiosuser"] = 'nagios'
default["check_mk"]["setup"]["wwwuser"] = 'www-data'
default["check_mk"]["setup"]["wwwgroup"] = 'nagios'
default["check_mk"]["setup"]["nagios_binary"] = '/usr/sbin/icinga'
default["check_mk"]["setup"]["nagios_config_file"] = '/etc/icinga/icinga.cfg'
default["check_mk"]["setup"]["nagconfdir"] = '/etc/icinga/objects'
default["check_mk"]["setup"]["nagios_startscript"] = '/etc/init.d/icinga'
default["check_mk"]["setup"]["nagpipe"] = '/var/lib/icinga/rw/icinga.cmd'
default["check_mk"]["setup"]["check_result_path"] = '/var/lib/icinga/spool/checkresults'
default["check_mk"]["setup"]["nagios_status_file"] = '/var/lib/icinga/status.dat'
default["check_mk"]["setup"]["check_icmp_path"] = '/usr/lib/nagios/plugins/check_icmp'
default["check_mk"]["setup"]["url_prefix"] = '/'
default["check_mk"]["setup"]["apache_config_dir"] = '/etc/apache2/conf.d'
default["check_mk"]["setup"]["htpasswd_file"] = node["icinga"]["htpasswd"]["file"]
default["check_mk"]["setup"]["nagios_auth_name"] = 'Icinga Access'
default["check_mk"]["setup"]["pnptemplates"] = '/usr/share/pnp4nagios/html/templates'
default["check_mk"]["setup"]["enable_livestatus"] = 'yes'
default["check_mk"]["setup"]["libdir"] = '/usr/lib/check_mk'
default["check_mk"]["setup"]["livesock"] = '/var/lib/icinga/rw/live'
default["check_mk"]["setup"]["livebackendsdir"] = '/usr/share/check_mk/livestatus'
default["check_mk"]["setup"]["multisite"]["config"]["file"] = "/etc/check_mk/multisite.mk"
default["check_mk"]["setup"]["multisite"]["config"]["nagvis_base_url"] = "/nagvis"
default["check_mk"]["module"]["file"] = "#{node["check_mk"]["setup"]["libdir"]}/livestatus.o"
default["check_mk"]["legacy"]["checks"] = {
    "apache2" => {
        "name" => "check-http",
        "alias" => "Legacy_HTTP",
        "perfdata" => "True",
        "opts" => "-p 80"
    },
    "apache2::mod_ssl" => {
        "name" => "check-http",
        "alias" => "Legcay_HTTPs",
        "perfdata" => "True",
        "opts" => "-p 443 -S"
    },
    "jetty" => {
        "name" => "check-http",
        "alias" => "Legcay_Jetty",
        "perfdata" => "True",
        "opts" => "-p 8080"
    },
    "memcached" => {
        "name" => "check-tcp",
        "alias" => "Legcay_Memcached",
        "perfdata" => "True",
        "opts" => "-p 11211"
    }
}
default["check_mk"]["legacy"]["commands"] = {
    "check-http" => {
        "name" => "check-http",
        "line" => "$USER1$/check_http -I $HOSTADDRESS$ $ARG1$"
    },
    "check-tcp" => {
        "name" => "check-tcp",
        "line" => "$USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$"
    }
}

# npcd
default["npcd"]["setup"]["config"]["file"] = "/etc/pnp4nagios/npcd.cfg"
default["npcd"]["setup"]["config"]["run"] = "yes"
default["npcd"]["setup"]["config"]["options"] = "-d -f #{node["npcd"]["setup"]["config"]["file"]}"
default["npcd"]["module"]["file"] = "/usr/lib/pnp4nagios/npcdmod.o"

# Icinga settings 
default["icinga"]["setup"]["config"]["log_file"] = "/var/log/icinga/icinga.log"
default["icinga"]["setup"]["config"]["cfg_file"]["commands"] = "/etc/icinga/commands.cfg"
default["icinga"]["setup"]["config"]["cfg_dir"]["nagios_plugins"] = "/etc/nagios-plugins/config"
default["icinga"]["setup"]["config"]["cfg_dir"]["objects"] = "/etc/icinga/objects/"
default["icinga"]["setup"]["config"]["cfg_dir"]["modules"] = "/etc/icinga/modules"
default["icinga"]["setup"]["config"]["object_cache_file"] = "/var/cache/icinga/objects.cache"
default["icinga"]["setup"]["config"]["precached_object_file"] = "/var/cache/icinga/objects.precache"
default["icinga"]["setup"]["config"]["resource_file"] = "/etc/icinga/resource.cfg"
default["icinga"]["setup"]["config"]["status_file"] = "/var/lib/icinga/status.dat"
default["icinga"]["setup"]["config"]["status_update_interval"] = "10"
default["icinga"]["setup"]["config"]["icinga_user"] = node["icinga"]["user"]
default["icinga"]["setup"]["config"]["icinga_group"] = node["icinga"]["group"]
default["icinga"]["setup"]["config"]["check_external_commands"] = "1"
default["icinga"]["setup"]["config"]["command_check_interval"] = "-1"
default["icinga"]["setup"]["config"]["command_file"] = "/var/lib/icinga/rw/icinga.cmd"
default["icinga"]["setup"]["config"]["external_command_buffer_slots"] = "4096"
default["icinga"]["setup"]["config"]["lock_file"] = "/var/run/icinga/icinga.pid"
default["icinga"]["setup"]["config"]["temp_file"] = "/var/cache/icinga/icinga.tmp"
default["icinga"]["setup"]["config"]["temp_path"] = "/tmp"
default["icinga"]["setup"]["config"]["event_broker_options"] = "-1"
default["icinga"]["setup"]["config"]["log_rotation_method"] = "d"
default["icinga"]["setup"]["config"]["log_archive_path"] = "/var/log/icinga/archives"
default["icinga"]["setup"]["config"]["use_daemon_log"] = "1"
default["icinga"]["setup"]["config"]["use_syslog"] = "0"
default["icinga"]["setup"]["config"]["use_syslog_local_facility"] = "0"
default["icinga"]["setup"]["config"]["syslog_local_facility"] = "5"
default["icinga"]["setup"]["config"]["log_notifications"] = "1"
default["icinga"]["setup"]["config"]["log_service_retries"] = "1"
default["icinga"]["setup"]["config"]["log_host_retries"] = "1"
default["icinga"]["setup"]["config"]["log_event_handlers"] = "1"
default["icinga"]["setup"]["config"]["log_initial_states"] = "1"
default["icinga"]["setup"]["config"]["log_current_states"] = "1"
default["icinga"]["setup"]["config"]["log_external_commands"] = "1"
default["icinga"]["setup"]["config"]["log_passive_checks"] = "0"
default["icinga"]["setup"]["config"]["log_long_plugin_output"] = "0"
default["icinga"]["setup"]["config"]["service_inter_check_delay_method"] = "s"
default["icinga"]["setup"]["config"]["max_service_check_spread"] = "30"
default["icinga"]["setup"]["config"]["service_interleave_factor"] = "s"
default["icinga"]["setup"]["config"]["host_inter_check_delay_method"] = "s"
default["icinga"]["setup"]["config"]["max_host_check_spread"] = "30"
default["icinga"]["setup"]["config"]["max_concurrent_checks"] = "0"
default["icinga"]["setup"]["config"]["check_result_reaper_frequency"] = "3"
default["icinga"]["setup"]["config"]["max_check_result_reaper_time"] = "30"
default["icinga"]["setup"]["config"]["check_result_path"] = "/var/lib/icinga/spool/checkresults"
default["icinga"]["setup"]["config"]["max_check_result_file_age"] = "3600"
default["icinga"]["setup"]["config"]["cached_host_check_horizon"] = "15"
default["icinga"]["setup"]["config"]["cached_service_check_horizon"] = "15"
default["icinga"]["setup"]["config"]["enable_predictive_host_dependency_checks"] = "1"
default["icinga"]["setup"]["config"]["enable_predictive_service_dependency_checks"] = "1"
default["icinga"]["setup"]["config"]["soft_state_dependencies"] = "0"
default["icinga"]["setup"]["config"]["auto_reschedule_checks"] = "0"
default["icinga"]["setup"]["config"]["auto_rescheduling_interval"] = "30"
default["icinga"]["setup"]["config"]["auto_rescheduling_window"] = "180"
default["icinga"]["setup"]["config"]["sleep_time"] = "0.25"
default["icinga"]["setup"]["config"]["service_check_timeout"] = "60"
default["icinga"]["setup"]["config"]["host_check_timeout"] = "30"
default["icinga"]["setup"]["config"]["event_handler_timeout"] = "30"
default["icinga"]["setup"]["config"]["notification_timeout"] = "30"
default["icinga"]["setup"]["config"]["ocsp_timeout"] = "5"
default["icinga"]["setup"]["config"]["perfdata_timeout"] = "5"
default["icinga"]["setup"]["config"]["retain_state_information"] = "1"
default["icinga"]["setup"]["config"]["state_retention_file"] = "/var/cache/icinga/retention.dat"
default["icinga"]["setup"]["config"]["retention_update_interval"] = "60"
default["icinga"]["setup"]["config"]["use_retained_program_state"] = "1"
default["icinga"]["setup"]["config"]["dump_retained_host_service_states_to_neb"] = "1"
default["icinga"]["setup"]["config"]["use_retained_scheduling_info"] = "1"
default["icinga"]["setup"]["config"]["retained_host_attribute_mask"] = "0"
default["icinga"]["setup"]["config"]["retained_service_attribute_mask"] = "0"
default["icinga"]["setup"]["config"]["retained_process_host_attribute_mask"] = "0"
default["icinga"]["setup"]["config"]["retained_process_service_attribute_mask"] = "0"
default["icinga"]["setup"]["config"]["retained_contact_host_attribute_mask"] = "0"
default["icinga"]["setup"]["config"]["retained_contact_service_attribute_mask"] = "0"
default["icinga"]["setup"]["config"]["interval_length"] = "60"
default["icinga"]["setup"]["config"]["use_aggressive_host_checking"] = "0"
default["icinga"]["setup"]["config"]["execute_service_checks"] = "1"
default["icinga"]["setup"]["config"]["accept_passive_service_checks"] = "1"
default["icinga"]["setup"]["config"]["execute_host_checks"] = "1"
default["icinga"]["setup"]["config"]["accept_passive_host_checks"] = "1"
default["icinga"]["setup"]["config"]["enable_notifications"] = "1"
default["icinga"]["setup"]["config"]["enable_event_handlers"] = "1"
default["icinga"]["setup"]["config"]["process_performance_data"] = "1"
default["icinga"]["setup"]["config"]["obsess_over_services"] = "0"
default["icinga"]["setup"]["config"]["obsess_over_hosts"] = "0"
default["icinga"]["setup"]["config"]["translate_passive_host_checks"] = "0"
default["icinga"]["setup"]["config"]["passive_host_checks_are_soft"] = "0"
default["icinga"]["setup"]["config"]["check_for_orphaned_services"] = "1"
default["icinga"]["setup"]["config"]["check_for_orphaned_hosts"] = "1"
default["icinga"]["setup"]["config"]["service_check_timeout_state"] = "u"
default["icinga"]["setup"]["config"]["check_service_freshness"] = "1"
default["icinga"]["setup"]["config"]["service_freshness_check_interval"] = "60"
default["icinga"]["setup"]["config"]["check_host_freshness"] = "0"
default["icinga"]["setup"]["config"]["host_freshness_check_interval"] = "60"
default["icinga"]["setup"]["config"]["additional_freshness_latency"] = "15"
default["icinga"]["setup"]["config"]["enable_flap_detection"] = "1"
default["icinga"]["setup"]["config"]["low_service_flap_threshold"] = "5.0"
default["icinga"]["setup"]["config"]["high_service_flap_threshold"] = "20.0"
default["icinga"]["setup"]["config"]["low_host_flap_threshold"] = "5.0"
default["icinga"]["setup"]["config"]["high_host_flap_threshold"] = "20.0"
default["icinga"]["setup"]["config"]["date_format"] = "iso8601"
default["icinga"]["setup"]["config"]["p1_file"] = "/usr/lib/icinga/p1.pl"
default["icinga"]["setup"]["config"]["enable_embedded_perl"] = "1"
default["icinga"]["setup"]["config"]["use_embedded_perl_implicitly"] = "1"
default["icinga"]["setup"]["config"]["stalking_event_handlers_for_hosts"] = "0"
default["icinga"]["setup"]["config"]["stalking_event_handlers_for_services"] = "0"
default["icinga"]["setup"]["config"]["stalking_notifications_for_hosts"] = "0"
default["icinga"]["setup"]["config"]["stalking_notifications_for_services"] = "0"
default["icinga"]["setup"]["config"]["illegal_object_name_chars"] = "=`~!$%^&*|'\"<>?,()"
default["icinga"]["setup"]["config"]["illegal_macro_output_chars"] = "`~$&|'\"<>"
default["icinga"]["setup"]["config"]["use_regexp_matching"] = "0"
default["icinga"]["setup"]["config"]["use_true_regexp_matching"] = "0"
default["icinga"]["setup"]["config"]["admin_email"] = "root@localhost"
default["icinga"]["setup"]["config"]["admin_pager"] = "pageroot@localhost"
default["icinga"]["setup"]["config"]["daemon_dumps_core"] = "0"
default["icinga"]["setup"]["config"]["use_large_installation_tweaks"] = "1"
default["icinga"]["setup"]["config"]["enable_environment_macros"] = "0"
default["icinga"]["setup"]["config"]["debug_level"] = "0"
default["icinga"]["setup"]["config"]["debug_verbosity"] = "2"
default["icinga"]["setup"]["config"]["debug_file"] = "/var/log/icinga/icinga.debug"
default["icinga"]["setup"]["config"]["max_debug_file_size"] = "100000000"
default["icinga"]["setup"]["config"]["event_profiling_enabled"] = "0"
default["icinga"]["setup"]["config"]["broker_module"]["livestatus"]["path"] = node["check_mk"]["module"]["file"]
default["icinga"]["setup"]["config"]["broker_module"]["livestatus"]["socket"] = node["check_mk"]["setup"]["livesock"]
default["icinga"]["setup"]["config"]["broker_module"]["livestatus"]["options"] = ""
default["icinga"]["setup"]["config"]["broker_module"]["npcd"]["path"] = node["npcd"]["module"]["file"]
default["icinga"]["setup"]["config"]["broker_module"]["npcd"]["config"] = node["npcd"]["setup"]["config"]["file"]
default["icinga"]["setup"]["config"]["htpasswd_file"] = node["icinga"]["htpasswd"]["file"]

# rrdcached
default["rrdcached"]["setup"]["config"]["socket"] = node["rrdcached"]["config"]["socket"]
default["rrdcached"]["setup"]["config"]["write_time"] = "1800"
default["rrdcached"]["setup"]["config"]["write_delay"] = "1800"
default["rrdcached"]["setup"]["config"]["socket_group"] = "nagios"
default["rrdcached"]["setup"]["config"]["rrdcached"]["DISABLE"] = "0"
default["rrdcached"]["setup"]["config"]["rrdcached"]["OPTS"] = "-s #{node["rrdcached"]["setup"]["config"]["socket_group"]} -m 0660 -l #{node["rrdcached"]["config"]["socket"]} -F -b #{node["pnp4nagios"]["config"]["rrdbase"]} -B -w #{node["rrdcached"]["setup"]["config"]["write_time"]} -z #{node["rrdcached"]["setup"]["config"]["write_delay"]}"
default["rrdcached"]["setup"]["config"]["rrdcached"]["MAXWAIT"] = "30"
default["rrdcached"]["setup"]["config"]["rrdcached"]["ENABLE_COREFILES"] = "0"

# pnp4nagios
default["pnp4nagios"]["setup"]["config"]["vhost"]["alias_url"] = "/pnp4nagios"
default["pnp4nagios"]["setup"]["config"]["vhost"]["alias_path"] = "/usr/share/pnp4nagios/html"
default["pnp4nagios"]["setup"]["config"]["vhost"]["auth_name"] = "pnp4nagios Restricted Access"
default["pnp4nagios"]["setup"]["config"]["config_php"]["use_url_rewriting"] = "1"
default["pnp4nagios"]["setup"]["config"]["config_php"]["rrdtool"] = "/usr/bin/rrdtool"
default["pnp4nagios"]["setup"]["config"]["config_php"]["graph_width"] = "500"
default["pnp4nagios"]["setup"]["config"]["config_php"]["graph_height"] = "100"
default["pnp4nagios"]["setup"]["config"]["config_php"]["pdf_width"] = "675"
default["pnp4nagios"]["setup"]["config"]["config_php"]["pdf_height"] = "100"
default["pnp4nagios"]["setup"]["config"]["config_php"]["graph_opt"] = ""
default["pnp4nagios"]["setup"]["config"]["config_php"]["pdf_graph_opt"] = ""
default["pnp4nagios"]["setup"]["config"]["config_php"]["rrdbase"] = node["pnp4nagios"]["config"]["rrdbase"]
default["pnp4nagios"]["setup"]["config"]["config_php"]["page_dir"] = "/etc/pnp4nagios/pages/"
default["pnp4nagios"]["setup"]["config"]["config_php"]["refresh"] = "90"
default["pnp4nagios"]["setup"]["config"]["config_php"]["max_age"] = "60*60*6"
default["pnp4nagios"]["setup"]["config"]["config_php"]["temp"] = "/var/tmp"
default["pnp4nagios"]["setup"]["config"]["config_php"]["nagios_base"] = "/cgi-bin/nagios3"
default["pnp4nagios"]["setup"]["config"]["config_php"]["multisite_base_url"] = "/check_mk"
default["pnp4nagios"]["setup"]["config"]["config_php"]["multisite_site"] = ""
default["pnp4nagios"]["setup"]["config"]["config_php"]["auth_enabled"] = "FALSE"
default["pnp4nagios"]["setup"]["config"]["config_php"]["allowed_for_all_services"] = ""
default["pnp4nagios"]["setup"]["config"]["config_php"]["allowed_for_all_hosts"] = ""
default["pnp4nagios"]["setup"]["config"]["config_php"]["allowed_for_service_links"] = "EVERYONE"
default["pnp4nagios"]["setup"]["config"]["config_php"]["allowed_for_host_search"] = "EVERYONE"
default["pnp4nagios"]["setup"]["config"]["config_php"]["allowed_for_host_overview"] = "EVERYONE"
default["pnp4nagios"]["setup"]["config"]["config_php"]["allowed_for_pages"] = "EVERYONE"
default["pnp4nagios"]["setup"]["config"]["config_php"]["overview_range"] = "1"
default["pnp4nagios"]["setup"]["config"]["config_php"]["popup_width"] = "300px"
default["pnp4nagios"]["setup"]["config"]["config_php"]["ui_theme"] = "multisite"
default["pnp4nagios"]["setup"]["config"]["config_php"]["lang"] = "en_US"
default["pnp4nagios"]["setup"]["config"]["config_php"]["date_fmt"] = "d.m.y G:i"
default["pnp4nagios"]["setup"]["config"]["config_php"]["enable_recursive_template_search"] = "1"
default["pnp4nagios"]["setup"]["config"]["config_php"]["show_xml_icon"] = "1"
default["pnp4nagios"]["setup"]["config"]["config_php"]["use_fpdf"] = "1"
default["pnp4nagios"]["setup"]["config"]["config_php"]["background_pdf"] = "/etc/pnp4nagios/background.pdf"
default["pnp4nagios"]["setup"]["config"]["config_php"]["use_calendar"] = "1"
default["pnp4nagios"]["setup"]["config"]["config_php"]["RRD_DAEMON_OPTS"] = node["rrdcached"]["config"]["socket"]
default["pnp4nagios"]["setup"]["config"]["config_php"]["template_dirs"]["one"] = "/etc/pnp4nagios/templates"
default["pnp4nagios"]["setup"]["config"]["config_php"]["template_dirs"]["two"] = "/usr/share/pnp4nagios/html/templates.dist"
default["pnp4nagios"]["setup"]["config"]["config_php"]["template_dirs"]["three"] = "/usr/share/check_mk/pnp-templates"
default["pnp4nagios"]["setup"]["config"]["config_php"]["special_template_dir"] = "/etc/pnp4nagios/templates.special"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["TIMEOUT"] = "60"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["USE_RRDs"] = "1"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["RRDPATH"] = node["pnp4nagios"]["config"]["rrdbase"]
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["RRDTOOL"] = "/usr/bin/rrdtool"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["CFG_DIR"] = "/etc/pnp4nagios"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["RRD_STORAGE_TYPE"] = "SINGLE"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["RRD_HEARTBEAT"] = "8460"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["RRA_CFG"] = "/etc/pnp4nagios/rra.cfg"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["RRA_STEP"] = "60"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["LOG_FILE"] = "/var/log/pnp4nagios/perfdata.log"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["LOG_LEVEL"] = "0"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["XML_ENC"] = "UTF-8"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["XML_UPDATE_DELAY"] = "0"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["RRD_DAEMON_OPTS"] = node["rrdcached"]["config"]["socket"]
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["STATS_DIR"] = "/var/log/pnp4nagios/stats"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["PREFORK"] = "1"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["GEARMAN_HOST"] = "localhost:4730"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["REQUESTS_PER_CHILD"] = "10000"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["ENCRYPTION"] = "1"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["KEY"] = "should_be_changed"

