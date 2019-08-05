local storedMoneyTrucks = {}
local storedMoneyTruckPeds = {}
local storedMoneyTruckPeds2 = {}
local thisMoneyTruck
local thisMoneyTruckPed
local thisMoneyTruckPed2
local thisMoneyGroundEscort ={}
local thisMoneyAirEscort = {}
local moneyTruckCords = {}
local moneyTruckGuardBlip = {}
local moneyTruckBlip = {}
local moneygroup = 0
local moneyTruckHash = GetHashKey("brutus")
local moneyGroundEscortpeds ={}


local moneyTrucks ={
 [0] =  {["hash"] = GetHashKey("brutus"), ["gs"] = 1, ["as"] = 1, ["x"] = -5.902, ["y"] = -669.570, ["z"] = 31.944, ["r"] = 180.0, ["breached"] = true},
 [1] =  {["hash"] = GetHashKey("brutus"), ["gs"] = 1, ["as"] = 1, ["x"] = -122.226, ["y"] = 6479.219, ["z"] = 31.051, ["r"] = 131.124, ["breached"] = true},
 [2] =  {["hash"] = GetHashKey("brutus"), ["gs"] = 0, ["as"] = 0, ["x"] = -343.565, ["y"] = -29.775, ["z"] = 47.089, ["r"] = 0.0, ["breached"] = true},
 [3] =  {["hash"] = GetHashKey("brutus"), ["gs"] = 0, ["as"] = 0, ["x"] = -5.902, ["y"] = -669.570, ["z"] = 31.944, ["r"] = 0.0, ["breached"] = true},
 [4] =  {["hash"] = GetHashKey("brutus"), ["gs"] = 0, ["as"] = 0, ["x"] = 254.483, ["y"] = 190.450, ["z"] = 104.448, ["r"] = 0.0, ["breached"] = true},
 [5] =  {["hash"] = GetHashKey("brutus"), ["gs"] = 0, ["as"] = 0, ["x"] = -392.572, ["y"] = 6062.591, ["z"] = 31.104, ["r"] = 0.0, ["breached"] = true},
 [6] =  {["hash"] = GetHashKey("brutus"), ["gs"] = 0, ["as"] = 0, ["x"] = -122.495, ["y"] = 6479.521, ["z"] = 31.047, ["r"] = 136.0, ["breached"] = false} 
}

local moneyGroundEscorts = {
 [0] = {["hash"] = GetHashKey("riot"), ["x"] = -34.032, ["y"] = -673.547, ["z"] = 31.961, ["r"] = 183.475, ["last"] = 0},
 [1] = {["hash"] = GetHashKey("riot"), ["x"] = -18.876, ["y"] = -704.382, ["z"] = 31.960, ["r"] = 350.404},
 [2] = {["hash"] = GetHashKey("riot"), ["x"] = -134.177, ["y"] = 6468.694, ["z"] = 31.064, ["r"] = 142.429, ["last"] = 1},
 [3] = {["hash"] = GetHashKey("riot"), ["x"] = -110.279, ["y"] = 6486.652, ["z"] = 31.068, ["r"] = 110.960}
}

local moneyAirEscorts = {
  [0] = {["hash"] = GetHashKey("buzzard") , ["x"] = -75.351, ["y"] = -818.938, ["z"] = 327.175, ["r"] = 312.815},
  [1] = {["hash"] = GetHashKey("buzzard") , ["x"] = -476.314, ["y"] = 5987.767, ["z"] =31.235, ["r"] = 316.713}
}

local truckDests = {
 [0] = {["x"] = -122.495, ["y"] =  6479.521, ["z"] =  31.047, ["r"] = 0},
 [1] = {["x"] = -392.572, ["y"] =  6062.591, ["z"] =  31.104, ["r"] = 0},
 [2] = {["x"] = 254.483, ["y"] =  190.450, ["z"] =  104.448, ["r"] = 0},
 [3] = {["x"] = -343.565, ["y"] =  -29.775, ["z"] =  47.089, ["r"] = 0},
 [4] = {["x"] = -35.136, ["y"] =  -699.135, ["z"] =  31.942, ["r"] = 0},
 [5] = {["x"] = -34.552, ["y"] =  -673.060, ["z"] =  31.944, ["r"] = 0},
 [6] = {["x"] = -19.869, ["y"] =  -670.819, ["z"] =  31.942, ["r"] = 90},
 [7] = {["x"] = -5.902, ["y"] =  -669.570, ["z"] =  31.944, ["r"] = 90},
}

local cashPickup = {}

function setupModel(model)
  RequestModel(model)
  while not HasModelLoaded(model) do
    RequestModel(model)
    Wait(0)
  end
  SetModelAsNoLongerNeeded(model)
end


function spawnMoneyTruck(delayTime, truckId, boolNew)
  Citizen.Trace(truckId)
  
  setupModel(moneyTruckHash)
  setupModel(GetHashKey("riot"))
  setupModel(GetHashKey("s_m_m_security_01"))
  setupModel(GetHashKey("s_m_y_swat_01"))
  setupModel(GetHashKey("s_m_m_highsec_02"))
  setupModel(GetHashKey("buzzard"))

  
  thisMoneyTruck = CreateVehicle(moneyTrucks[truckId]["hash"], moneyTrucks[truckId]["x"], moneyTrucks[truckId]["y"], moneyTrucks[truckId]["z"], moneyTrucks[truckId]["r"], true, false)
  RequestCollisionForModel(moneyTrucks[truckId]["hash"])
  
  N_0x06faacd625d80caa(thisMoneyTruck)

  SetVehicleDoorsLocked(thisMoneyTruck , 7)
  SetEntityAsNoLongerNeeded(thisMoneyTruck)
  SetEntityAsMissionEntity(thisMoneyTruck, 0, 0)
  SetVehicleOnGroundProperly(thisMoneyTruck)


  thisMoneyTruckPed = CreatePed(4, GetHashKey("s_m_m_security_01"), moneyTrucks[truckId]["x"], moneyTrucks[truckId]["y"], moneyTrucks[truckId]["z"], 0.0, true, false)
  thisMoneyTruckPed2 = CreatePed(4, GetHashKey("s_m_m_security_01"), moneyTrucks[truckId]["x"], moneyTrucks[truckId]["y"], moneyTrucks[truckId]["z"], 0.0, true, false)
  SetEntityAsMissionEntity(thisMoneyTruckPed, 0, 0)
  SetEntityAsMissionEntity(thisMoneyTruckPed2, 0, 0)
  --give the guard some balls
  setGaurd(thisMoneyTruckPed)
  setGaurd(thisMoneyTruckPed2)
 

  SetPedIntoVehicle(thisMoneyTruckPed, thisMoneyTruck, -1)
  SetPedIntoVehicle(thisMoneyTruckPed2, thisMoneyTruck, 0)



  if(boolNew) then
    table.insert(storedMoneyTrucks,{truck = thisMoneyTruck})
  else
    table.insert(storedMoneyTrucks, truckId,{truck = thisMoneyTruck})
  end

  if(boolNew) then
    table.insert(storedMoneyTruckPeds,{ped = thisMoneyTruckPed})
    table.insert(storedMoneyTruckPeds2,{ped = thisMoneyTruckPed2})
  else
    table.insert(storedMoneyTruckPeds, truckId,{ped = thisMoneyTruckPed})
    table.insert(storedMoneyTruckPeds2, truckId,{ped = thisMoneyTruckPed2})
  end

 moneyTruckGuardBlip[truckId] = AddBlipForEntity(thisMoneyTruckPed)
 SetBlipColour(moneyTruckGuardBlip[truckId], 12)

  moneyTruckBlip[truckId] = AddBlipForEntity(thisMoneyTruck)
  SetBlipColour(moneyTruckBlip[truckId], 11)
 

    
  



  if truckId == 0 then

    --LOAD land Escorts
    
         
      thisMoneyGroundEscort[truckId] = CreateVehicle(GetHashKey("riot"), moneyGroundEscorts[truckId]["x"], moneyGroundEscorts[truckId]["y"],moneyGroundEscorts[truckId]["z"],moneyGroundEscorts[truckId]["r"], true, false)
      thisMoneyGroundEscort[truckId + 1 ] = CreateVehicle(GetHashKey("riot"), moneyGroundEscorts[truckId + 1 ]["x"], moneyGroundEscorts[truckId + 1 ]["y"],moneyGroundEscorts[truckId + 1 ]["z"],moneyGroundEscorts[truckId + 1 ]["r"], true, false)
     
      --SET_ENTITY_AS_MISSION_ENTITY
      SetEntityAsMissionEntity(thisMoneyGroundEscort[truckId], 0, 0)
      SetEntityAsMissionEntity(thisMoneyGroundEscort[truckId+1], 0, 0)
      moneyGroundEscortpeds[1] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), -1, true, false)
      moneyGroundEscortpeds[2] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), 0, true, false)
      moneyGroundEscortpeds[3] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), 1, true, false)
      moneyGroundEscortpeds[4] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), 2,true, false)
      moneyGroundEscortpeds[5] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 3, true, false)
      moneyGroundEscortpeds[6] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 4, true, false)

      moneyGroundEscortpeds[7] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1 ], 5,  GetHashKey("s_m_m_highsec_02"), -1, true, false)
      moneyGroundEscortpeds[8] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1 ], 5,  GetHashKey("s_m_m_highsec_02"), 0, true, false)
      moneyGroundEscortpeds[9] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1 ], 5,  GetHashKey("s_m_m_highsec_02"), 1, true, false)
      moneyGroundEscortpeds[10] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1 ], 5,  GetHashKey("s_m_m_highsec_02"), 2,true, false)
      moneyGroundEscortpeds[11] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1 ], 5,  GetHashKey("s_m_y_swat_01"), 3, true, false)
      moneyGroundEscortpeds[12] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1 ], 5,  GetHashKey("s_m_y_swat_01"), 4, true, false)


      
      --Load Air Escorts
     

     
      thisMoneyAirEscort[truckId] = CreateVehicle(GetHashKey("buzzard"), moneyAirEscorts[truckId]["x"],moneyAirEscorts[truckId]["y"],moneyAirEscorts[truckId]["z"],moneyAirEscorts[truckId]["r"], true, false)
      --SetVehicleOnGroundProperly(thisMoneyAirEscort[i])
      SetEntityAsMissionEntity(thisMoneyAirEscort[truckId], 0, 0)
      moneyGroundEscortpeds[13] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), -1, true, false)
      moneyGroundEscortpeds[14] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), 0, true, false)
      moneyGroundEscortpeds[15] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 1, true, false)
      moneyGroundEscortpeds[16] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 2, true, false)
      moneyGroundEscortpeds[17] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 3, true, false)
      moneyGroundEscortpeds[18] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 4, true, false)
    

    for i=1, 18, 1 do 
      setGaurd(moneyGroundEscortpeds[i])
      Citizen.Trace("Peds setup")
      Citizen.Trace(i)
    end

    ClearPedTasks(moneyGroundEscortpeds[13])
    ClearPedTasks(moneyGroundEscortpeds[1])
    ClearPedTasks(moneyGroundEscortpeds[7])
    ClearPedTasks(thisMoneyTruckPed)
    RequestCollisionForModel(thisMoneyTruckPed)
    RequestCollisionForModel(thisMoneyGroundEscort[truckId])
    RequestCollisionForModel(thisMoneyGroundEscort[truckId +1 ])

    --First FIB truck lead path
    --
    --TaskVehicleDriveToCoord(moneyGroundEscortpeds[1], thisMoneyGroundEscort[truckId], truckDests[truckId]["x"], truckDests[truckId]["y"], truckDests[truckId]["z"], 40.0, true, GetHashKey("fbi2"), 786603, 1.0, true)
    OpenSequenceTask(taskSeq01)
    --TaskVehicleDriveToCoordLongrange(moneyGroundEscortpeds[1], thisMoneyGroundEscort[truckId], truckDests[truckId]["x"], truckDests[truckId]["y"], truckDests[truckId]["z"], 20.0, 786469, 10.0)
    --TaskVehicleDriveWander(moneyGroundEscortpeds[1], thisMoneyGroundEscort[truckId],  25.0, 786603)
    CloseSequenceTask(taskSeq01)
    TaskPerformSequence(moneyGroundEscortpeds[1], taskSeq01)

    Wait(2000)
    --Money Truck follow lead
    TaskVehicleFollow(thisMoneyTruckPed, thisMoneyTruck,  thisMoneyGroundEscort[truckId], 25.0, 786603, 10)
    Wait(2000)
    --Second FIB Truck follwo money truck
    TaskVehicleFollow(moneyGroundEscortpeds[7], thisMoneyGroundEscort[truckId+1], thisMoneyTruck, 25.0, 786603, 10)
    --Air Follow moneytruck
    TaskVehicleHeliProtect(moneyGroundEscortpeds[13], thisMoneyAirEscort[truckId], thisMoneyTruckPed, 25.0, 32, 25.0, 60, 0)
    


  end



if truckId == 1 then

    --LOAD land Escorts
    
         
      thisMoneyGroundEscort[truckId + 1] = CreateVehicle(GetHashKey("riot"), moneyGroundEscorts[truckId + 1]["x"], moneyGroundEscorts[truckId + 1]["y"],moneyGroundEscorts[truckId + 1]["z"],moneyGroundEscorts[truckId + 1]["r"], true, false)
      thisMoneyGroundEscort[truckId + 2 ] = CreateVehicle(GetHashKey("riot"), moneyGroundEscorts[truckId + 2]["x"], moneyGroundEscorts[truckId + 2]["y"],moneyGroundEscorts[truckId + 2]["z"],moneyGroundEscorts[truckId + 2]["r"], true, false)
     
      --SET_ENTITY_AS_MISSION_ENTITY
      SetEntityAsMissionEntity(thisMoneyGroundEscort[truckId+1], 0, 0)
      SetEntityAsMissionEntity(thisMoneyGroundEscort[truckId+2], 0, 0)
      moneyGroundEscortpeds[19] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1], 5,  GetHashKey("s_m_m_highsec_02"), -1, true, false)
      moneyGroundEscortpeds[20] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1], 5,  GetHashKey("s_m_m_highsec_02"), 0, true, false)
      moneyGroundEscortpeds[21] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1], 5,  GetHashKey("s_m_m_highsec_02"), 1, true, false)
      moneyGroundEscortpeds[22] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1], 5,  GetHashKey("s_m_m_highsec_02"), 2,true, false)
      moneyGroundEscortpeds[23] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1], 5,  GetHashKey("s_m_y_swat_01"), 3, true, false)
      moneyGroundEscortpeds[24] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 1], 5,  GetHashKey("s_m_y_swat_01"), 4, true, false)

      moneyGroundEscortpeds[25] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 2], 5,  GetHashKey("s_m_m_highsec_02"), -1, true, false)
      moneyGroundEscortpeds[26] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 2], 5,  GetHashKey("s_m_m_highsec_02"), 0, true, false)
      moneyGroundEscortpeds[27] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 2], 5,  GetHashKey("s_m_m_highsec_02"), 1, true, false)
      moneyGroundEscortpeds[28] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 2], 5,  GetHashKey("s_m_m_highsec_02"), 2,true, false)
      moneyGroundEscortpeds[29] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 2], 5,  GetHashKey("s_m_y_swat_01"), 3, true, false)
      moneyGroundEscortpeds[30] = CreatePedInsideVehicle(thisMoneyGroundEscort[truckId + 2], 5,  GetHashKey("s_m_y_swat_01"), 4, true, false)


    
      --Load Air Escorts
     

     
      thisMoneyAirEscort[truckId] = CreateVehicle(GetHashKey("buzzard"), moneyAirEscorts[truckId]["x"],moneyAirEscorts[truckId]["y"],moneyAirEscorts[truckId]["z"],moneyAirEscorts[truckId]["r"], true, false)
      --SetVehicleOnGroundProperly(thisMoneyAirEscort[i])
      SetEntityAsMissionEntity(thisMoneyAirEscort[truckId], 0, 0)
      moneyGroundEscortpeds[31] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), -1, true, false)
      moneyGroundEscortpeds[32] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_m_highsec_02"), 0, true, false)
      moneyGroundEscortpeds[33] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 1, true, false)
      moneyGroundEscortpeds[34] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 2, true, false)
      moneyGroundEscortpeds[35] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 3, true, false)
      moneyGroundEscortpeds[36] = CreatePedInsideVehicle(thisMoneyAirEscort[truckId], 5,  GetHashKey("s_m_y_swat_01"), 4, true, false)
    

    for i=18, 36, 1 do 
      setGaurd(moneyGroundEscortpeds[i])
      Citizen.Trace("Peds setup")
      Citizen.Trace(i)
    end
    ClearPedTasks(moneyGroundEscortpeds[31])
    ClearPedTasks(moneyGroundEscortpeds[19])
    ClearPedTasks(moneyGroundEscortpeds[25])
    ClearPedTasks(thisMoneyTruckPed)
    RequestCollisionForModel(thisMoneyTruckPed)

    --First FIB truck lead path
    --
    OpenSequenceTask(taskSeq02)
    --TaskVehicleDriveToCoordLongrange(moneyGroundEscortpeds[19], thisMoneyGroundEscort[truckId], truckDests[truckId]["x"], truckDests[truckId]["y"], truckDests[truckId]["z"], 20.0, 786469, 10.0)
    TaskVehicleDriveWander(moneyGroundEscortpeds[19], thisMoneyGroundEscort[truckId + 1],  20.0, 786603)
    CloseSequenceTask(taskSeq02)
    --TaskPerformSequence(moneyGroundEscortpeds[19], taskSeq02)
    
    Wait(2000)

    --Money Truck follow lead
    TaskVehicleFollow(thisMoneyTruckPed, thisMoneyTruck,  thisMoneyGroundEscort[truckId + 1 ], 20.0, 786603, 10)
    Wait(2000)
    --Second FIB Truck follwo money truck
    TaskVehicleFollow(moneyGroundEscortpeds[25], thisMoneyGroundEscort[truckId + 2], thisMoneyTruck,  20.0, 786603, 10)
    Wait(2000)
    --Air Follow moneytruck
     TaskVehicleHeliProtect(moneyGroundEscortpeds[31], thisMoneyAirEscort[truckId], thisMoneyTruckPed, 20.0, 32, 25.0, 60, 0)




  end



  if truckId > 1 then
    OpenSequenceTask(taskSeq03)
    TaskVehicleDriveWander(thisMoneyTruckPed, thisMoneyTruck,  20.0, 786603)
    CloseSequenceTask(taskSeq03)
    TaskPerformSequence(thisMoneyTruckPed, taskSeq03)
    
  end
  --TaskVehicleDriveToCoordLongrange(thisMoneyTruckPed,  thisMoneyTruck,  moneyTruckDest[1],  moneyTruckDest[3],  moneyTruckDest[3],  30.0,  447,  20)
  Citizen.Wait(delayTime)
end



function setGaurd(inputPed)
  SetPedShootRate(inputPed,  200)
  AddArmourToPed(inputPed, GetPlayerMaxArmour(thisMoneyTruckPed)- GetPedArmour(thisMoneyTruckPed)) 
  SetPedAlertness(inputPed, 100)
  SetPedAccuracy(inputPed, 100)
  SetPedCanSwitchWeapon(inputPed, true)
  SetEntityHealth(inputPed,  200)
  SetPedFleeAttributes(inputPed, 0, 0)
  --SetPedCombatAttributes(inputPed, 16, true)
  SetPedCombatAttributes(inputPed, 46, true)
  SetPedCombatAbility(inputPed,  2)
  SetPedCombatRange(inputPed, 50)
  SetPedPathAvoidFire(inputPed,  1)
  SetPedPathCanUseLadders(inputPed,1)
  SetPedPathCanDropFromHeight(inputPed, 1)
  SetPedPathPreferToAvoidWater(inputPed, 1)
  SetPedGeneratesDeadBodyEvents(inputPed, 1)
  --GiveDelayedWeaponToPed(inputPed,  GetHashKey("smg"),  500,  true)
  GiveWeaponToPed(inputPed, GetHashKey("WEAPON_SMG"), 5000, true, true)
  SetPedRelationshipGroupHash(inputPed, GetHashKey("army"))
  --SetBlockingOfNonTemporaryEvents(inputPed, true)

end

function triggerDone(payOutIn)
  Citizen.CreateThread(function()
scaleform_state = 0
if true then
 Citizen.CreateThread(function()
   while true do
     Citizen.Wait(0)
     if scaleform_state == 0 then
       scaleform = RequestScaleformMovie("MIDSIZED_MESSAGE")

       scaleform_state = 1

     elseif scaleform_state == 1 then
       if HasScaleformMovieLoaded(scaleform) then
         scaleform_state = 2
       end
     elseif scaleform_state == 2 then
       RegisterScriptWithAudio(0)
       SetAudioFlag("AvoidMissionCompleteDelay", true)
       PlayMissionCompleteAudio("FRANKLIN_BIG_01")

       StartScreenEffect("HeistCelebPass", 9000, false)

       PushScaleformMovieFunction(scaleform, "SHOW_SHARD_MIDSIZED_MESSAGE")
       BeginTextComponent("STRING")
       Citizen.InvokeNative(0x6C188BE134E074AA, Translator.translate("moneytruck_Passed"))
       EndTextComponent()

       BeginTextComponent("STRING")
       Citizen.InvokeNative(0x6C188BE134E074AA, Translator.translate("moneytruck_Enjoy"))
       EndTextComponent()

       PushScaleformMovieFunctionParameterInt(20)
       PushScaleformMovieFunctionParameterFloat(true)

       PopScaleformMovieFunctionVoid()
       scaleform_state = 3

     elseif scaleform_state == 3 then
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)

        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
       scaleform_state = 3
     end

   end
 end)
end

Wait(7000)
scaleform_state = 4
end)

end

function checkMoneyTruckTick()

  
    --Need to check if the trucks are still drivable if not pay
    for i=0, 6, 1 do



        thisMoneyTruck = storedMoneyTrucks[i+1].truck
        thisMoneyTruckPed = storedMoneyTruckPeds[i+1].ped
        thisMoneyTruckPed2 = storedMoneyTruckPeds2[i+1].ped
        thisMoneyTruckBreached = moneyTrucks[i][breached]
        
        --check to see if we are at endlocation so we can choose another location rand to go to
        distanceFromEnd = GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, useZ)


        if GetVehicleDoorAngleRatio(thisMoneyTruck, 2) > .1 or GetVehicleDoorAngleRatio(thisMoneyTruck, 3) > .1 then


          
          if not moneyTrucks[i]["breached"] then
            Citizen.Trace("Money truck breached")
            GetEntityCoords(thisMoneyTruck, 1)
            cashPickup[i] = CreatePickup(GetHashKey("PICKUP_MONEY_SECURITY_CASE"), GetOffsetFromEntityInWorldCoords(thisMoneyTruck, 0.0, -5.0, 0.0))
          end
          moneyTrucks[i]["breached"] = true
          Wait(1000)


        end

        if moneyTrucks[i]["breached"] then

          --check to see the pickup has been collected
          if (HasPickupBeenCollected(cashPickup[i])) then
              SetPedComponentVariation(playerPed, 9, 0, 0, 0)
              PlayMissionCompleteAudio("FRANKLIN_BIG_01")

              if i == 0 or i == 1 then
                payOut = Setup.truckPayout * Setup.truckPayX
                
                --DrawMissionText("Money Truck robbed.", 5000)

                triggerDone(payOut)
                TriggerServerEvent('mission:completed', payOut)
                SetPlayerWantedLevel(GetPlayerPed(playerPed),3,0)
                DrawMissionText(Translator.translate("moneytruck_LoseCops"), 10000)
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(thisMoneyGroundEscort[i]))
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(thisMoneyGroundEscort[i+1]))
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(thisMoneyTruck))
                DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed))
                DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed2))
                if i == 0 then
                  for i=1, 18, 1 do
                    DeletePed(Citizen.PointerValueIntInitialized(moneyGroundEscortpeds[i]))
                  end
                end
                if i == 1 then
                  for i=19, 36, 1 do 
                    DeletePed(Citizen.PointerValueIntInitialized(moneyGroundEscortpeds[i]))
                  end
                end
              end




              if i > 1 then
                TriggerServerEvent('mission:completed', Setup.truckPayout)

                --sfx_state = 0
                triggerDone(Setup.truckPayout)
                TriggerServerEvent('mission:complete', Setup.truckPayout)


                --DrawMissionText("Money Truck robbed.", 5000)              
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(thisMoneyTruck))
                DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed))
                DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed2))
                moneyTrucks[i]["breached"] = false
                respawnTime = Setup.truckRespawn * 60 * 1000

                spawnMoneyTruck(respawnTime, i,false)

                SetPlayerWantedLevel(GetPlayerPed(playerPed),3,0)
                DrawMissionText("Lose the ~r~cops!", 10000)
              end
          end

        end


        if (GetVehicleBodyHealth(thisMoneyTruck) < 5.0) then 
          NetworkExplodeVehicle(thisMoneyTruck,1,1,1)
          TriggerServerEvent("mission:completed", tonumber(100000))
          --TriggerServerEvent('mission:completed', Setup.truckPayout)DisplayRadar()
          DrawMissionText(Translator.translate("moneytruck_Failed"), 25000)
          Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(thisMoneyTruck))
          DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed))
          DeletePed(Citizen.PointerValueIntInitialized(thisMoneyTruckPed2))
          RemovePickup(cashPickup[i])
          --DeleteEnity(thisMoneyTruck)
          respawnTime = Setup.truckRespawn * 60 * 1000

          spawnMoneyTruck(respawnTime, i,false)

          SetPlayerWantedLevel(GetPlayerPed(playerPed),3,0)
          DrawMissionText("Lose the ~r~cops!", 10000)
        end

    end
end



  Citizen.Trace("WE ARE STARTING MoneyTruck")

   
    Citizen.CreateThread(function()
      SetFarDrawVehicles(true)
      --setup trucks
      if NetworkIsHost() then 
        for i=0, 6, 1 do
          spawnMoneyTruck(2000, i, true)
          Wait(1)
        end
        while true do
        
          checkMoneyTruckTick()
          Wait(0)
        end
      end
    end)
    
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