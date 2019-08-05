resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
--resource_repository 'https://github.com/FiveM-Scripts/fs_freemode'
--resource_type 'gametype' { name = 'fs_freemode'}
--resource_version 'v1.3.6'

--dependency 'essentialmode'

--files { 'weapons.xml' }

--weaponfile 'weapons.xml'

client_scripts {
  'Tunnel.lua',
  'Proxy.lua',
  'libs/i18n.lua',
  'config.lua',
  'bin/System.Xml.net.dll',
  'bin/NativeUI.net.dll',
  'bin/ShopMenu.net.dll',
  'lang/en.lua',
  'libs/events.lua',
  --'libs/scoreboard.lua',
  'libs/warmenu.lua',
  --'config/vehicles.lua',
  --'config/spawn.lua',
  'client.lua',
  --'int/cinema.lua',
  'int/comedy.lua',
  'int/office.lua',
  'int/taxi.lua',
  --'int/smoke.lua',
  --'int/vehicles.lua',
  --'int/weapons.lua',
  'int/warehouses.lua',
  'ext/locations.lua',
  'ext/pickups.lua',
  'ext/boatsteal.lua',
  'ext/trevor.lua',
  'ext/vente.lua',
  --'ext/moneytruck.lua',
  'ext/carsteal.lua'
}

server_scripts {
  '@vrp/lib/utils.lua',
  --'@mysql-async/lib/MySQL.lua',
  'config.lua',
  --'database.lua',
  --'libs/db.lua',
  'int/server.lua',
}