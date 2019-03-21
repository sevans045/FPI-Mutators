/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_Game extends Rx_Game;

function TickCredits(byte TeamNum)
{
    local float CreditTickAmount;
    local Rx_Building_Refinery Refinery;
    
    CreditTickAmount = Rx_MapInfo(WorldInfo.GetMapInfo()).BaseCreditsPerTick;
    Refinery = TeamCredits[TeamNum].Refinery;
    
    if (Refinery != None)
        if (!Refinery.IsDestroyed())
            CreditTickAmount += Refinery.CreditsPerTick;
        else
        {
            CreditTickAmount += 1;
        }
    
    GiveTeamCredits(CreditTickAmount, TeamNum);
    
    //Sync Credit and CP ticks 
    Rx_TeamInfo(Teams[0]).AddCommandPoints(default.CP_TickRate+(DestroyedBuildings_GDI*0.5)) ;
    Rx_TeamInfo(Teams[1]).AddCommandPoints(default.CP_TickRate+(DestroyedBuildings_Nod*0.5)) ;
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	if(Rx_Pri(PlayerPawn.PlayerReplicationInfo) != none)
	{ 
		Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.GetStartClass(PlayerPawn.GetTeamNum(), PlayerPawn.PlayerReplicationInfo);
		`LogRxPub("GAME" `s "Spawn;" `s "player" `s `PlayerLog(PlayerPawn.PlayerReplicationInfo) `s "character" `s UTPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).CharClassInfo);
		PlayerPawn.NotifyTeamChanged();
	}
	
	if(Rx_Bot(PlayerPawn.Controller) != None) 
	{
		if(PurchaseSystem.AirStrip != None) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = Rx_Bot(PlayerPawn.Controller).BotBuy(Rx_Bot(PlayerPawn.Controller), true);
		} else if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_GDI) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.GDIInfantryClasses[Rand(PurchaseSystem.GDIInfantryClasses.Length)];
			`LogRxPub("GAME" `s "Spawn;" `s "player" `s `PlayerLog(PlayerPawn.PlayerReplicationInfo) `s "character" `s UTPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).CharClassInfo);
		} else if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_NOD) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.NodInfantryClasses[Rand(PurchaseSystem.NodInfantryClasses.Length)];
			`LogRxPub("GAME" `s "Spawn;" `s "player" `s `PlayerLog(PlayerPawn.PlayerReplicationInfo) `s "character" `s UTPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).CharClassInfo);
		}
		//Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = class'Rx_FamilyInfo_Nod_StealthBlackHand';
		//Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = class'Rx_FamilyInfo_Nod_RocketSoldier';
		PlayerPawn.NotifyTeamChanged();
	} else if(Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap)
	{
		if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_GDI) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.GDIInfantryClasses[Rand(PurchaseSystem.GDIInfantryClasses.Length)];
		} else if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_NOD) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.NodInfantryClasses[Rand(PurchaseSystem.NodInfantryClasses.Length)];
		}
		PlayerPawn.NotifyTeamChanged();
	}
	
	super.SetPlayerDefaults(PlayerPawn);

	if(Rx_Controller(PlayerPawn.Controller) != None && PurchaseSystem.IsStealthBlackHand( Rx_PRI(PlayerPawn.PlayerReplicationInfo) ) ) 
	{
		Rx_Controller(PlayerPawn.Controller).SetJustBaughtEngineer(false);
		Rx_Controller(PlayerPawn.Controller).SetJustBaughtHavocSakura(false);
		Rx_Controller(PlayerPawn.Controller).ChangeToSBH(true);	
	} 
	else if(Rx_Bot(PlayerPawn.Controller) != None && PurchaseSystem.IsStealthBlackHand( Rx_PRI(PlayerPawn.PlayerReplicationInfo) ) ) 
	{
		Rx_Bot(PlayerPawn.Controller).ChangeToSBH(true);
	} else {
		if (Rx_Controller(PlayerPawn.Controller) != none) {
			Rx_Controller(PlayerPawn.Controller).SetJustBaughtEngineer(false);
			Rx_Controller(PlayerPawn.Controller).SetJustBaughtHavocSakura(false);
			Rx_Controller(PlayerPawn.Controller).RemoveCurrentSidearmAndExplosive();
		}
		Rx_Pri(PlayerPawn.PlayerReplicationInfo).equipStartWeapons();
	}
	
	
}

DefaultProperties
{
	PurchaseSystemClass = class'FPI_PurchaseSystem'
}
