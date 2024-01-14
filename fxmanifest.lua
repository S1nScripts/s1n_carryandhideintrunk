fx_version "cerulean"

description "S1nScripts Carry and Hide in Trunk"
author "S1nScripts"
version '1.4.7'

use_experimental_fxv2_oal 'yes'
lua54 'yes'

game "gta5"

client_scripts {
    "config.lua",
    "client/main.lua"
}

shared_script '@ox_lib/init.lua'

server_scripts {
    "server/main.lua"
}

files {
    'locales/*.json'
}
dependencies {
    '/onesync',
}

escrow_ignore {
    "**.*",
}
