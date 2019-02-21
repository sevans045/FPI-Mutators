/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */
 
class FPI_Controller extends Rx_Controller
config(FPI);

var config int MinimumPlayersForSuperweapon;
var config bool bConsiderBuildingCount;
var config string MutatorVersion;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    Rx_HUD(myHud).Message(none, "This server is running using Sarah's FPI mutator package.", 'Say');
}

reliable client function WriteMutatorVersion(string Version)
{
	MutatorVersion = Version;
	SaveConfig();
}

reliable client function ReportVersion()
{
	Mutate("fpi report"@MutatorVersion);
}

function TimerLoop()
{
	//SetTimer(90, true, 'ReportTime');
}

reliable client function ReportTime()
{
	Mutate("fpi time"@WorldInfo.GRI.ElapsedTime);
}

reliable server function ServerPurchaseItem(int CharID, Rx_BuildingAttachment_PT PT)	// Called when someone attempts to purchase an item
{
	if(CharID == 0)	// Is the item being purchased a beacon? Beacon ID is 0
	{	  
		if (CanPurchaseBeacon() == false)
		{
			CTextMessage("[FPI] Not enough players for that.\nThere needs to be more than "$MinimumPlayersForSuperweapon$" players.",'Red');    // Notify our purchaser that they can not purchase that.
			return;
		} else {
			if (ValidPTUse(PT))
				Rx_Game(WorldInfo.Game).GetPurchaseSystem().PurchaseItem(self,GetTeamNum(),CharID);
		}
	} else {
		if (ValidPTUse(PT))
			Rx_Game(WorldInfo.Game).GetPurchaseSystem().PurchaseItem(self,GetTeamNum(),CharID);
	}
}

reliable server function bool CanPurchaseBeacon()
{
	local int AliveBuildings, AllBuildings, PlayerCount;
	PlayerCount = `WorldInfoObject.Game.NumPlayers-1;

	AliveBuildings = CountAliveBuildings();
	AllBuildings   = CountAllBuildings();

	if (MinimumPlayersForSuperweapon > PlayerCount)
		return false;
	else if (PlayerCount == MinimumPlayersForSuperweapon || PlayerCount > MinimumPlayersForSuperweapon)
		return true;
	else if (AliveBuildings * 2 < AllBuildings && bConsiderBuildingCount)
		return true;
	else
		return false;
}

function int CountAliveBuildings()
{
    local Rx_Building_Team_Internals thisBuilding;
    local Rx_Building_Techbuilding_Internals thisTBuilding;
    local Rx_Building_Airstrip AirStrip;
    local int AliveBuildings;

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Team_Internals', thisBuilding)
    {
    if(thisBuilding.IsDestroyed() == false)
      	AliveBuildings++;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Techbuilding_Internals', thisTBuilding)	// Because I am dumb and cant get ClassIsAChild to work or IsA to check if it's a tech building.
    {
    	AliveBuildings--;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Airstrip', AirStrip)	// I really hate looping through all these, but apparently the airstrip counts as 2. 
    {
    	AliveBuildings--;
    }
    return AliveBuildings;
}

function int CountAllBuildings()
{
    local Rx_Building_Team_Internals thisBuilding;
    local Rx_Building_Techbuilding_Internals thisTBuilding;
    local Rx_Building_Airstrip AirStrip;
    local int AllBuildings;

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Team_Internals', thisBuilding)
    {
        AllBuildings++;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Techbuilding_Internals', thisTBuilding)
    {
    	AllBuildings--;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Airstrip', AirStrip)	
    {
    	AllBuildings--;
    }
    return AllBuildings;
}
