resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
description "Garages et sauvegarde"

client_scripts {
    "warmenu.lua",
    "config.lua",
    "Tunnel.lua",
    "Proxy.lua",
    "client.lua",
}

server_scripts {
    "@vrp/lib/utils.lua",
    "config.lua",
    "server.lua",
       "pay.lua",
}
