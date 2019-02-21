/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_Game extends Rx_Game;

function SetMaxPlayers(int NewMaxPlayers)
{
	if (NewMaxPlayers > 64)
		return;
	else 
		MaxPlayers = NewMaxPlayers;
}

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
            CreditTickAmount += 1000;
    
    GiveTeamCredits(CreditTickAmount, TeamNum);
    
    //Sync Credit and CP ticks 
    Rx_TeamInfo(Teams[0]).AddCommandPoints(default.CP_TickRate+(DestroyedBuildings_GDI*0.5)) ;
    Rx_TeamInfo(Teams[1]).AddCommandPoints(default.CP_TickRate+(DestroyedBuildings_Nod*0.5)) ;
}

DefaultProperties
{
    HudClass                   = class'FPI_HUD'
    PlayerControllerClass      = class'FPI_Controller'
    PlayerReplicationInfoClass = class'FPI_PRI'
    AccessControlClass         = class'FPI_AccessControl'
    PurchaseSystemClass        = class'FPI_PurchaseSystem'
    DefaultPawnClass           = class'FPI_Pawn'
}
