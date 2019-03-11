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

simulated exec function SetText(string Text)
{
    FPI_PRI(PlayerReplicationInfo).SetSpecialText(Text);
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

function BroadcastEnemySpotMessages() 
{
	local int i,j;
	//Adding TS Vehicles (nBab)
	//local int SpottedVehicles[15];
	local int SpottedVehicles[22];
	local int SpottedInfs[32]; 
	local int NumVehicles;
	local int NumInfs;
	local Actor SpotTarget;
	local Actor FirstSpotTarget;
	local string LocationInfo;
	local string SpottingMsg;
	local UTPlayerReplicationInfo PRI;
	//local Pawn P; 
			
	FirstSpotTarget = Rx_Hud(MyHUD).SpotTargets[0];		
	SpottingMsg = "";
	
	foreach Rx_Hud(MyHUD).SpotTargets(SpotTarget)
	{
		if(Pawn(SpotTarget) == None)
			continue;
		if(Pawn(SpotTarget).GetTeamNum() == GetTeamNum())
			continue;	
		if(Rx_Vehicle(SpotTarget) != None && Rx_Vehicle_Harvester(SpotTarget) == None)
		{
			NumVehicles++;
			
			//Tell the spot target to activate its controller and set its visibility 
			Rx_Vehicle(SpotTarget).SetSpotted(10.0);
			
			if(Rx_Vehicle_Humvee(SpotTarget) != None) {
				SpottedVehicles[0]++;
			} else if(Rx_Vehicle_APC_GDI(SpotTarget) != None) {
				SpottedVehicles[1]++;
			} else if(Rx_Vehicle_MRLS(SpotTarget) != None) {
				SpottedVehicles[2]++;
			} else if(Rx_Vehicle_MediumTank(SpotTarget) != None) {
				SpottedVehicles[3]++;
			} else if(Rx_Vehicle_MammothTank(SpotTarget) != None) {
				SpottedVehicles[4]++;
			} else if(Rx_Vehicle_Chinook_GDI(SpotTarget) != None) {
				SpottedVehicles[5]++;
			} else if(Rx_Vehicle_Orca(SpotTarget) != None) {
				SpottedVehicles[6]++;
			} else if(Rx_Vehicle_Buggy(SpotTarget) != None) {
				SpottedVehicles[7]++;
			} else if(Rx_Vehicle_APC_Nod(SpotTarget) != None) {
				SpottedVehicles[8]++;
			} else if(Rx_Vehicle_Artillery(SpotTarget) != None) {
				SpottedVehicles[9]++;
			} else if(Rx_Vehicle_LightTank(SpotTarget) != None) {
				SpottedVehicles[10]++;
			} else if(Rx_Vehicle_FlameTank(SpotTarget) != None) {
				SpottedVehicles[11]++;
			} else if(Rx_Vehicle_StealthTank(SpotTarget) != None) {
				SpottedVehicles[12]++;
			} else if(Rx_Vehicle_Chinook_Nod(SpotTarget) != None) {
				SpottedVehicles[13]++;
			} else if(Rx_Vehicle_Apache(SpotTarget) != None) {
				SpottedVehicles[14]++;
			} else if(TS_Vehicle_Buggy(SpotTarget) != None) {
				SpottedVehicles[15]++;
			} else if(TS_Vehicle_ReconBike(SpotTarget) != None) {
				SpottedVehicles[16]++;
			} else if(TS_Vehicle_TickTank(SpotTarget) != None) {
				SpottedVehicles[17]++;
			} else if(TS_Vehicle_HoverMRLS(SpotTarget) != None) {
				SpottedVehicles[18]++;
			} else if(TS_Vehicle_Wolverine(SpotTarget) != None) {
				SpottedVehicles[19]++;
			} else if(TS_Vehicle_Titan(SpotTarget) != None) {
				SpottedVehicles[20]++;
			}
			 else if(Rx_Vehicle_M2Bradley(SpotTarget) != None) {
				SpottedVehicles[21]++;
			}
		}
		
		if(Rx_Pawn(SpotTarget) != None)
		{
			NumInfs++;
			if(UTPlayerReplicationInfo(Rx_Pawn(SpotTarget).PlayerReplicationInfo) == None)
				continue; 
			PRI = UTPlayerReplicationInfo(Rx_Pawn(SpotTarget).PlayerReplicationInfo);
			
			Rx_PRI(Rx_Pawn(SpotTarget).PlayerReplicationInfo).SetSpotted(10.0); 
				if((bCommandSpotting || bPlayerIsCommander()) && SpotTarget == FirstSpotTarget)  SetPlayerCommandSpotted(Rx_PRI(Rx_Pawn(SpotTarget).PlayerReplicationInfo).PlayerID); //Rx_PRI(Rx_Pawn(SpotTarget).PlayerReplicationInfo).SetAsTarget(1);
			
			if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Soldier') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Soldier'))  {
				SpottedInfs[0]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Shotgunner') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Shotgunner'))  {
				SpottedInfs[1]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Grenadier') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Grenadier')) {
				SpottedInfs[2]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Marksman') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Marksman'))  {
				SpottedInfs[3]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Engineer') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Engineer'))  {
				SpottedInfs[4]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Officer') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Officer'))  {
				SpottedInfs[5]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_RocketSoldier') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_RocketSoldier'))  {
				SpottedInfs[6]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_McFarland') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_McFarland'))  {
				SpottedInfs[7]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Deadeye') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Deadeye'))  {
				SpottedInfs[8]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Gunner') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Gunner'))  {
				SpottedInfs[9]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Patch') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Patch'))  {
				SpottedInfs[10]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Havoc') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Havoc'))  {
				SpottedInfs[11]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Sydney') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Sydney'))  {
				SpottedInfs[12]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Mobius') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Mobius'))  {
				SpottedInfs[13]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Hotwire') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Hotwire'))  {
				SpottedInfs[14]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Soldier') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Soldier'))  {
				SpottedInfs[15]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Shotgunner') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Shotgunner'))  {
				SpottedInfs[16]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_FlameTrooper') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_FlameTrooper'))  {
				SpottedInfs[17]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Marksman') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Marksman'))  {
				SpottedInfs[18]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Engineer') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Engineer'))  {
				SpottedInfs[19]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Officer') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Officer'))  {
				SpottedInfs[20]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_RocketSoldier') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_RocketSoldier'))  {
				SpottedInfs[21]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_ChemicalTrooper') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_ChemicalTrooper'))  {
				SpottedInfs[22]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_blackhandsniper') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_blackhandsniper'))  {
				SpottedInfs[23]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Stealthblackhand') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Stealthblackhand'))  {
				SpottedInfs[24]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_LaserChainGunner') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_LaserChainGunner'))  {
				SpottedInfs[25]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Sakura') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Sakura'))  {
				SpottedInfs[26]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Raveshaw') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Raveshaw'))  {
				SpottedInfs[27]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Mendoza') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Mendoza'))  {
				SpottedInfs[28]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Technician') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Technician'))  {
				SpottedInfs[29]++;
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_GDI_Sydney_Suit') || (PRI.CharClassInfo == class'RX_FamilyInfo_GDI_Sydney_Suit'))  {
				SpottedInfs[30]++; 
			} else if((PRI.CharClassInfo == class'FPI_FamilyInfo_Nod_Raveshaw_Mutant') || (PRI.CharClassInfo == class'RX_FamilyInfo_Nod_Raveshaw_Mutant'))  {
				SpottedInfs[31]++;
			}
		}
			
		if (Rx_Pawn(SpotTarget) != none)
		{
			SetPlayerSpotted(Rx_Pawn(SpotTarget).PlayerReplicationInfo.PlayerID);
		}
		else if (Rx_Vehicle(SpotTarget) != none && (Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none || Rx_DefencePRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none))
		{
			if(Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none)
			{
				//`log("Set Vehicle Spotted");
				SetPlayerSpotted(Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo).PlayerID );
				if((bCommandSpotting || bPlayerIsCommander()) && SpotTarget == FirstSpotTarget) SetPlayerCommandSpotted(Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo).PlayerID); //Rx_PRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo).SetAsTarget(1);
			}
			else
			if(Rx_DefencePRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo) != none)
			{
				//`log("Set Defense Spotted");
				SetPlayerSpotted(Rx_DefencePRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo).PlayerID);
				
				if((bCommandSpotting || bPlayerIsCommander()) && SpotTarget == FirstSpotTarget) SetPlayerCommandSpotted(Rx_DefencePRI(Rx_Vehicle(SpotTarget).PlayerReplicationInfo).PlayerID);
			}
			/**foreach WorldInfo.AllPawns(class'Pawn', P)
			{
				if(P.DrivenVehicle == Rx_Vehicle(SpotTarget))
					SetPlayerSpotted(P.PlayerReplicationInfo.PlayerID);		
			}*/
			
		}
	}
	
	//Moved uppies
	//FirstSpotTarget = Rx_Hud(MyHUD).SpotTargets[0];
	
	LocationInfo = GetSpottargetLocationInfo(FirstSpotTarget);
	
	if(numberOfRadioCommandsLastXSeconds++ > 5) 
	{
		spotMessagesBlocked = true;
		SetTimer(2.5, false, 'resetSpotMessageCountTimer'); //5.0 seconds is REALLY annoying and sometimes game breaking. 	
	}
	if(NumVehicles > 0)
	{
		for(i=20; i>=0; i--)
		{
			if(j > 5)
				break;
			if(SpottedVehicles[i] > 0)
				j++;
			if(i==0 && SpottedVehicles[0] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedVehicles[0] @ "Humvee</font>";
			else if(i==1 && SpottedVehicles[1] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedVehicles[1] @ "APC</font>";				
			else if(i==2 && SpottedVehicles[2] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedVehicles[2] @ "MRLS</font>";				
			else if(i==3 && SpottedVehicles[3] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedVehicles[3] @ "Med.Tank</font>";				
			else if(i==4 && SpottedVehicles[4] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedVehicles[4] @ "Mam.Tank</font>";				
			else if(i==5 && SpottedVehicles[5] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedVehicles[5] @ "Chinook</font>";				
			else if(i==6 && SpottedVehicles[6] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedVehicles[6] @ "Orca</font>";				
			else if(i==7 && SpottedVehicles[7] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[7] @ "Buggy</font>";				
			else if(i==8 && SpottedVehicles[8] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[8] @ "APC</font>";				
			else if(i==9 && SpottedVehicles[9] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[9] @ "Artillery</font>";				
			else if(i==10 && SpottedVehicles[10] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[10] @ "L.Tank</font>";				
			else if(i==11 && SpottedVehicles[11] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[11] @ "F.Tank</font>";				
			else if(i==12 && SpottedVehicles[12] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[12] @ "S.Tank</font>";				
			else if(i==13 && SpottedVehicles[13] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[13] @ "Chinook</font>";				
			else if(i==14 && SpottedVehicles[14] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[14] @ "Apache</font>";
			else if(i==15 && SpottedVehicles[15] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedVehicles[15] @ "Buggy</font>";
			else if(i==16 && SpottedVehicles[16] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedVehicles[16] @ "R.Bike</font>";
			else if(i==17 && SpottedVehicles[17] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedVehicles[17] @ "T.Tank</font>";
			else if(i==18 && SpottedVehicles[18] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedVehicles[18] @ "H.MRLS</font>";
			else if(i==19 && SpottedVehicles[19] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedVehicles[19] @ "Wolverine</font>";
			else if(i==20 && SpottedVehicles[20] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedVehicles[20] @ "Titan</font>";
			else if(i==20 && SpottedVehicles[21] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedVehicles[21] @ "Light Tank[M2]</font>";
			
			if(SpottedVehicles[i] > 1)
				SpottingMsg = SpottingMsg @ "s";	
			if(SpottedVehicles[i] > 0 && (NumInfs+NumVehicles) > j)
				SpottingMsg = SpottingMsg @ ",";								
		}
	}
	
	if(NumInfs > 0)
	{
		for(i=31; i>=0; i--)
		{
			if(j > 5)
				break;
			if(SpottedInfs[i] > 0)
				j++;
						
			if(i==0 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedInfs[i] @ "Soldier</font>";		
			else if(i==1 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $ SpottedInfs[i] @ "Shotgunner </font>";					
			else if(i==2 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Grenadier</font>";					
			else if(i==3 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Marksman</font>";					
			else if(i==4 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Engineer</font>";					
			else if(i==5 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Officer</font>";					
			else if(i==6 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "RocketSoldier</font>";					
			else if(i==7 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "McFarland</font>";					
			else if(i==8 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Deadeye</font>";					
			else if(i==9 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Gunner</font>";					
			else if(i==10 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Patch</font>";					
			else if(i==11 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Havoc</font>";					
			else if(i==12 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Sydney</font>";					
			else if(i==13 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Mobius</font>";					
			else if(i==14 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Hotwire</font>";					
			else if(i==15 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedInfs[i] @ "Soldier</font>";					
			else if(i==16 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $ SpottedInfs[i] @ "Shotgunner</font>";					
			else if(i==17 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "FlameTrooper</font>";					
			else if(i==18 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Marksman</font>";					
			else if(i==19 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Engineer</font>";					
			else if(i==20 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Officer</font>";					
			else if(i==21 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Rock.Soldier</font>";					
			else if(i==22 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Chem.Trooper</font>";					
			else if(i==23 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Blackh.Sniper</font>";					
			else if(i==24 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "SBH</font>";					
			else if(i==25 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "LCG</font>";					
			else if(i==26 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Sakura</font>";					
			else if(i==27 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Raveshaw</font>";					
			else if(i==28 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Mendoza</font>";					
			else if(i==29 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Tech</font>";
			else if(i==30 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $GDIColor$ "'>" $  SpottedInfs[i] @ "Armoured Syd.</font>";	
			else if(i==31 && SpottedInfs[i] > 0)
				SpottingMsg = SpottingMsg $  "<font color ='" $NodColor$ "'>" $  SpottedInfs[i] @ "Mutant Rav.</font>";	
				
			if(SpottedInfs[i] > 1)
				SpottingMsg = SpottingMsg @ "s";				
			if(SpottedInfs[i] > 0 && (NumInfs+NumVehicles) > j)
				SpottingMsg = SpottingMsg @ ",";												
		}
	}	
	
	if( (NumVehicles + NumInfs) > 6)
		SpottingMsg = SpottingMsg @ " and more"; 
		if(Rx_Vehicle(FirstSpotTarget) != none && bFocusSpotting && NumVehicles == 1 && NumInfs == 0) 
		{
			BroadCastSpotMessage(3, "FOCUS FIRE:"@SpottingMsg@LocationInfo);
			if(Rx_PRI(Rx_Vehicle(FirstSpotTarget).PlayerReplicationInfo) != none) SetPlayerFocused(Rx_PRI(Rx_Vehicle(FirstSpotTarget).PlayerReplicationInfo).PlayerID);
		}
		else
		if(Rx_Pawn(FirstSpotTarget) != none && bFocusSpotting && NumInfs == 1 && NumVehicles == 0)
		{
			BroadCastSpotMessage(19, "FOCUS FIRE:"@SpottingMsg@LocationInfo);
			if(Rx_PRI(Rx_Pawn(FirstSpotTarget).PlayerReplicationInfo) != none) SetPlayerFocused(Rx_PRI(Rx_Pawn(FirstSpotTarget).PlayerReplicationInfo).PlayerID);
		}	
		else
		BroadCastSpotMessage(9, "Spotted"@SpottingMsg@LocationInfo);	
}