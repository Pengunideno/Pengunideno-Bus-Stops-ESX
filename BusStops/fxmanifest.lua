fx_version 'adamant'

game 'gta5'

description 'Simple bus stop script' -- THIS IS A FREE SCRIPT DO NOT RESELL PLEASE!
author 'Pengunideno'

lua54 'yes'

shared_scripts {
"@ox_lib/init.lua", 
"@es_extended/imports.lua"
}

client_scripts {'client/client.lua'}
server_scripts {'server/server.lua'}

dependency 'ox_lib' -- Make sure this is started before this resource.

