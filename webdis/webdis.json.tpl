{
	"redis_host":	"127.0.0.1",
	"redis_port":	6379,
	"redis_auth":	null,

	"http_host":	"0.0.0.0",
	"http_port":	7379,
	"threads":	4,

	"daemonize":	false,
	"websockets":	true,

	"database":	0,

	"acl": [
		{
			"disabled":	["*"]
		},

		{
			"http_basic_auth":	"{{ REDIS_USER }}:{{ REDIS_PASSWORD }}",
			"enabled":		["SET"]
		}
	],

        "verbosity": 3,
        "logfile": "/var/log/webdis.log"
}
