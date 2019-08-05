--[[
            fs_freemode - game mode for FiveM.
              Copyright (C) 2018 FiveM-Scripts
              
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with fs_freemode in the file "LICENSE". If not, see <http://www.gnu.org/licenses/>.
]]

i18n.importData("en", {
  welcome_message = "Presse ~INPUT_INTERACTION_MENU~ pour ton Menu ~INPUT_CELLPHONE_UP~ pour avoir ton Inventaire ~INPUT_SCRIPT_RB~ pour avoir ton Phone.",
  buy = "Buy",
  no = "No",
  andtext = " and ",  
  categories = "Categories",
  confirm = "Confirm",
  exit = "Exit",
  options = "Options",
  items = "Items",
  more_cash_needed = "You need more cash",
  enter_bunker_workshop = "Press ~INPUT_CONTEXT~ to access the Bunker Vehicle Workshop.",
  bunker_vehicle_workshop_title = "Bunker Vehicle Workshop",
  enter_bunker = "Press ~INPUT_CONTEXT~ to enter the bunker",
  exit_bunker = "Press ~INPUT_CONTEXT~ to exit the bunker",
  enter_office = "Presse ~INPUT_CONTEXT~ pour Acheter ce bureau pour ~g~10 000 000 €~w~ et commence a faire des affaire !",
  enter_taxi = "Devien actionnaire, presse ~INPUT_CONTEXT~ ~g~10000000€~w~ avec acces a toutes l\'Entreprise !",

  exit_office = "Presse ~INPUT_CONTEXT~ pour sortir du Bureau",
  exit_taxi = "Presse ~INPUT_CONTEXT~ pour sortir de garage",
  --enter_pc = "Press ~INPUT_SELECT_CHARACTER_MICHAEL~ pour alume le PC ",
  enter_moc = "Press ~INPUT_CONTEXT~ to enter the MOC",
  exit_moc = "Press ~INPUT_CONTEXT~ to exit the MOC",
  enter_vehicleshop = "Press ~INPUT_CONTEXT~ to browse vehicles",
  enter_warehouse = "Press ~INPUT_CONTEXT~ to enter the warehouse",
  exit_warehouse = "Press ~INPUT_CONTEXT~ to exit the warehouse",
  browse_weapons = "Press ~INPUT_CONTEXT~ to browse weapons",
  weapons_purchased = "Weapon Purchased",
  vehicles_shop_title = "Vehicle Shop",
  vehicle_shop_confirmation = "Purchase confirmation",
  vehicle_inventory = "Vehicle Inventory",
  vehicles_owned = "Owned vehicles",
  vehicles_lockdoors = "Lock vehicle doors",  
  vehicles_engine_on = "Engine on",
  cinema_closed = "The cinema is currently closed.~n~Come back between ",
  enter_cinema = "Press ~INPUT_CONTEXT~ to watch a movie for $10.",
  leave_cinema = "Press ~INPUT_FRONTEND_CANCEL~ to leave",
  weed_help = "Press ~INPUT_PICKUP~ to open the weed menu",
  wasted_message = "~r~Wasted~w~",
  continue = "Continue       ",
  call_ems = "Call EMS       ",
  dispatch = "Dispatch",
  ems_heal = "Heal request",
  ems_request = " request EMS support",
  weedshop_title = "Cannabis Menu",
  enter_facility = "Presse ~INPUT_CONTEXT~ pour rentré au Comissaria.",
  leave_facility = "Press ~INPUT_CONTEXT~ pour sortir du Comissaria.",
  update_available = "a new update for fs_freemode is available, please update now.",
  StartMissionDialog = "Presse ~INPUT_PICKUP~ pour commencé la mission.",
  simeon_firstline = "~y~Simeon:~w~ Un de mes client ne veut pas payé son crédit en cours.",
  simeon_secondline = "~y~Simeon:~w~ je veux a present ~g~reprendre~w~ le véhicule.",
  simeon_thirthline = "~y~Simeon:~w~ Quant tu auras le ~g~vehicule~w~ va jusque dans mon garage au Dock.",
  simeon_coordinates = "~y~Simeon:~g~ Conduit~w~ jusqu'a mon garage, j'ai mis les coordonné sur ton GPS.",
  lester_firstline = "~y~Lester:~w~ Enfin te voilà ! Bon j'espere que tu as la marchandise.",
  lester_secondline = "~y~Lester:~w~ je vais te preté mon ~g~bateau~w~ pour la livraison.",
  lester_thirthline = "~y~Lester:~w~ Quant tu sera au ~g~bateau~w~ va jusqu'a l'ile pour livret la ~g~Weed~w~!",
  lester_coordinates = "~y~Lester:~g~ Navigue~w~ jusqu'a l'ile, j'ai mis les coordonné sur ton GPS.",
  clear_wantedLevel = "~z~Semet la police pour pouvoir retrouvé le ~y~point de destination~z~.",
  trevor_firstline = "~y~Trevor:~w~ J'ai une planque en ville ou il faut ramene les cartes Pirate.",
  trevor_secondline = "~y~Trevor:~w~ Je te passe un ~g~vehicule~w~ va jusque dans ma planque avec.",
  trevor_thirthline = "~y~Trevor:~w~ je les met tous dans le ~g~coffre~w~ de ce véhicule.",
  trevor_coordinates = "~y~Trevor:~g~ Conduit~w~ jusqu'a ma planque, j'ai mis les coordonné sur ton GPS.",
  trevor_wantedLevel = "~r~la voiture est recherché ~z~Semet la police pour pouvoir retrouvé le ~y~point de destination~z~.",
  simeon_notification = "Hey i would like to use your services, meet me at my office inside ~g~Premium Deluxe MotorSports~w~."
})