fx_version "cerulean"

description "S1nScripts Carry and Hide in Trunk"
author "S1nScripts"
version '1.0.0'

use_experimental_fxv2_oal 'yes'
lua54 'yes'

game "gta5"

client_scripts {
    "languages/english.lua",
    "client/main.lua"
}

shared_script '@ox_lib/init.lua'

server_scripts {
    "server/main.lua"
}

dependencies {
    '/onesync',
}

escrow_ignore {
    "**.*",
}