fx_version 'adamant'
game 'gta5'

data_file 'DLC_ITYP_REQUEST' 'stream/patoche_cyber_list.ytyp'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    '1-Vagos/server/server.lua',
    '2-Ballas/server/server.lua',
    '3-Bloods/server/server.lua',
    '5-Families/server/server.lua',
    '4-Crips/server/server.lua',
    '6-Marabunta/server/server.lua',
}
-- 1-Vagos
client_scripts {
    '@es_extended/locale.lua',
    '1-Vagos/client/**.lua',
    '1-Vagos/shared/config.lua',
}
-- 2-Ballas
client_scripts {
    '2-Ballas/client/**.lua',
    '2-Ballas/shared/config.lua',
}
-- Bloods
client_scripts {
    '3-Bloods/client/**.lua',
    '3-Bloods/shared/config.lua',
}
-- Families
client_scripts {
    '5-Families/client/**.lua',
    '5-Families/shared/config.lua',
}
-- Crips
client_scripts {
    '4-Crips/client/**.lua',
    '4-Crips/shared/config.lua',
}
-- Marabunta
client_scripts {
    '6-Marabunta/client/**.lua',
    '6-Marabunta/shared/config.lua',
}

dependencies {
    'es_extended'
}