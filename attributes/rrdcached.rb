# rrdcached
default["rrdcached"]["config"]["socket"] = "unix:/var/run/rrdcached.sock"
default["rrdcached"]["version"] = "1.4.3-1"
default["rrdcached"]["setup"]["config"]["write_time"] = "1800"
default["rrdcached"]["setup"]["config"]["write_delay"] = "1800"
default["rrdcached"]["setup"]["config"]["socket_group"] = "nagios"
default["rrdcached"]["setup"]["config"]["rrdcached"]["DISABLE"] = "0"
default["rrdcached"]["setup"]["config"]["rrdcached"]["MAXWAIT"] = "30"
default["rrdcached"]["setup"]["config"]["rrdcached"]["ENABLE_COREFILES"] = "0"
