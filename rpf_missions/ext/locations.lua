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

local locations = {
  {name="Altruist Cult Camp", id=269, c=4, x=-1042.29, y=4910.17, z=94.92},
  --{name="Comedy Club", id=102, c=4, x=-420.087, y=264.681, z=83.1927},
  --{name="Arena War", id=529, c=75, x = -272.08843994141, y=-1905.8538818359, z=27.755443572998},
  {name="Acheter ou Louer un vehicule ADDON", id=524, c=57, x= -910.49676513672, y=-227.26220703125, z=39.859992980957},
  --{name="Strip club", id=121, c=4, x=134.476, y=-1307.887, z=28.983},
  --{name="Tequil-La La", id=93, c=4, x=-565.171, y=276.625, z=83.286},
  {name="Force Special", id=590, c=8, x=1837.92, y=220.767, z=176.917},
  --{name="Mine de Diamante", id=161, c=4, x=5964.2846679688,y=118.68231201172,z=345.80258178711,},
  {name="Prison", id=285, c=4, x=1679.049, y=2513.711, z=45.565},
  {name="Yacht", id=455, c=4, x=-2045.800, y=-1031.200, z=11.900},
  {name="Yacht", id=455, c=4, x=1802.1281738281, y=4143.4111328125, z=44.492488861084},
  {name="Yacht", id=455, c=4, x=-2190.4187011719, y=-1216.11328125, z=14.896757125854},
  {name="Yacht", id=455, c=4, x=-1381.5125732422, y=6740.443359375, z=2.5845251083374},
    --{name="Tony's Club", id=614, c=4, x=193.9785, y=-3167.5754, z=5.79206},-1381.5125732422,6740.443359375,2.5845251083374
  --{name="Entreprise Taxi ~g~En Vente !", id=476, c=4, x=900.34851074219, y=-145.19323730469, z=76.652969360352},
  --{name="Warehouse", id=473, c=4, x=758.90, y=-909.15, z=30.0}, 
  --{name="Warehouse", id=473, c=4, x=714.05, y=-716.50, z=30.0},  
  --{name="Weed Production", id=496, c=4, x=1308.95, y=4362.15, z=30.0},
  --{name="Cocaine Production ", id=497, c=4, x=387.40, y=3583.45, z=30.0},
  --{name="Meth Production", id=499, c=4, x=1179.732, y=-3114.203, z=6.028},
  --{name="Money Production", id=500, c=4, x=639.35, y=2769.65, z=30},
  --{name="Fake ID Production", id=498, c=4, x=378.646, y=-834.4833, z=29.292},
  --{name="Entreprise Import Export ~g~En Vente !", id=476, c=4, x=-43.954, y=-796.541, z=44.225},
  {name="Humane Labs", id=80, c=4, x=3624.632, y=3756.963, z=28.516},
  {name="Fume un petard", id=140, c=2, x=-1174.073, y=-1573.562, z=4.372}
}

Citizen.CreateThread(function()
 if (Setup.blips == true) then
    for _, item in pairs(locations) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.c)

      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)

      SetBlipAsShortRange(item.blip, true)
    end
  end

  RequestIpl("facelobby") 
  RequestIpl("FIBlobby")
  RequestIpl("v_tunnel_hole")
  RequestIpl("v_tunnel_hole_lod")
  RequestIpl("v_tunnel_hole_swap")
  RequestIpl("v_tunnel_hole_swap_lod")
  RequestIpl("TrevorsTrailerTrash")
  RequestIpl("v_rockclub")
  RequestIpl("refit_unload")
  RequestIpl("post_hiest_unload")
  RequestIpl("FINBANK")
  RequestIpl("shr_int")
  RequestIpl("v_carshowroom")
  RequestIpl("Carwash_with_spinners")
  RequestIpl("KT_CarWash")
  RequestIpl("CS1_02_cf_onmission1")
  RequestIpl("CS1_02_cf_onmission2")
  RequestIpl("CS1_02_cf_onmission3")
  RequestIpl("CS1_02_cf_onmission4")
  RequestIpl("ferris_finale_Anim")
  RequestIpl("ufo")
  RequestIpl("ufo_lod")
  RequestIpl("ufo_eye")
  RequestIpl("v_comedy")
  RequestIpl("Plane_crash_trench")
  RemoveIpl("sp1_10_fake_interior")
  RemoveIpl("sp1_10_fake_interior_lod")
  RequestIpl("sp1_10_real_interior")
  RequestIpl("sp1_10_real_interior_lod") 
  --RequestIpl("hei_yacht_heist")
  RequestIpl("hei_yacht_heist_Bar")
  --RequestIpl("hei_yacht_heist_Bedrm")
  RequestIpl("hei_yacht_heist_Bridge")
  RequestIpl("hei_yacht_heist_DistantLights")
  RequestIpl("hei_yacht_heist_enginrm")
  RequestIpl("hei_yacht_heist_LODLights")
  --RequestIpl("hei_yacht_heist_Lounge")
  RequestIpl("gr_case0_bunkerclosed")
  RequestIpl("gr_case1_bunkerclosed")
  RequestIpl("gr_case2_bunkerclosed")
  RequestIpl("gr_case3_bunkerclosed")
  RequestIpl("gr_case4_bunkerclosed")
  RequestIpl("gr_case5_bunkerclosed")
  RequestIpl("gr_case6_bunkerclosed")
  RequestIpl("gr_case7_bunkerclosed")
  RequestIpl("gr_case9_bunkerclosed")
  RequestIpl("gr_case10_bunkerclosed")
  RequestIpl("gr_case11_bunkerclosed")
  RequestIpl("lr_cs6_08_grave_closed") 
  RequestIpl("bkr_bi_id1_23_door")
  RequestIpl("bkr_bi_hw1_13_int")
  RequestIpl("bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo")
  RequestIpl("bkr_biker_interior_placement_interior_1_biker_dlc_int_02_milo")
  RequestIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo")
  RequestIpl("bkr_biker_interior_placement_interior_3_biker_dlc_int_ware02_milo")
  RequestIpl("bkr_biker_interior_placement_interior_4_biker_dlc_int_ware03_milo") 
  RequestIpl("bkr_biker_interior_placement_interior_5_biker_dlc_int_ware04_milo")
  RequestIpl("bkr_biker_interior_placement_interior_6_biker_dlc_int_ware05_milo")
  RequestIpl("ex_exec_warehouse_placement_interior_1_int_warehouse_s_dlc_milo")
  RequestIpl("ex_exec_warehouse_placement_interior_0_int_warehouse_m_dlc_milo")  
  RequestIpl("ex_exec_warehouse_placement_interior_2_int_warehouse_l_dlc_milo")
  RequestIpl("ex_dt1_11_office_02c")
  RequestIpl("id2_14_during_door")
  RequestIpl("id2_14_during1")
  RequestIpl("apa_v_mp_h_04_b")
  RequestIpl("rc12b_default")
end)
