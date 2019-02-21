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

DefaultProperties
{
}
