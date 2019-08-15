resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'


client_scripts {
  'Tunnel.lua',
  'Proxy.lua',
  'libs/i18n.lua',
  'config.lua',
  'bin/System.Xml.net.dll',
  'bin/NativeUI.net.dll',
  'bin/ShopMenu.net.dll',
  'lang/en.lua',
  --'libs/events.lua',
  'libs/warmenu.lua',
  'client.lua',
  'int/comedy.lua',
  'int/office.lua',
  'int/taxi.lua',
  'int/warehouses.lua',
  'ext/locations.lua',
  'ext/pickups.lua',
  'ext/boatsteal.lua',
  'ext/trevor.lua',
  'ext/vente.lua',
  'ext/carsteal.lua'
}

server_scripts {
  '@vrp/lib/utils.lua',
  'config.lua',
  'int/server.lua',
}
