# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# npcd
default["npcd"]["setup"]["config"]["file"] = "/etc/pnp4nagios/npcd.cfg"
default["npcd"]["setup"]["config"]["run"] = "yes"
default["npcd"]["setup"]["config"]["options"] = "-d"
default["npcd"]["module"]["file"] = "/usr/lib/pnp4nagios/npcdmod.o"

# pnp4nagios
default["pnp4nagios"]["version"] = "0.6.12-1~bpo60+1"
default["pnp4nagios"]["config"]["rrdbase"] = "/var/lib/pnp4nagios/perfdata/"
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
default["pnp4nagios"]["setup"]["config"]["config_php"]["template_dirs"]["one"] = "/etc/pnp4nagios/templates"
default["pnp4nagios"]["setup"]["config"]["config_php"]["template_dirs"]["two"] = "/usr/share/pnp4nagios/html/templates.dist"
default["pnp4nagios"]["setup"]["config"]["config_php"]["template_dirs"]["three"] = "/usr/share/check_mk/pnp-templates"
default["pnp4nagios"]["setup"]["config"]["config_php"]["special_template_dir"] = "/etc/pnp4nagios/templates.special"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["TIMEOUT"] = "60"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["USE_RRDs"] = "1"
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
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["STATS_DIR"] = "/var/log/pnp4nagios/stats"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["PREFORK"] = "1"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["GEARMAN_HOST"] = "localhost:4730"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["REQUESTS_PER_CHILD"] = "10000"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["ENCRYPTION"] = "1"
default["pnp4nagios"]["setup"]["config"]["process_perfdata"]["KEY"] = "should_be_changed"
