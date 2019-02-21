/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_CreditMutator extends Rx_Mutator
config(FPI);

var config float TickAmount;
var config float TickTime;

function InitThisMutator()
{
  `log("################################");
  `log("[Credit Mutator] Successfully inited!");
  `log("################################");
}

function MHOnBuildingDestroyed(PlayerReplicationInfo Destroyer, Rx_Building_Team_Internals BuildingInternals, Rx_Building Building, class<DamageType> DamageType)
{
local Rx_Building_Refinery thisBuilding;

  ForEach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Building_Refinery',thisBuilding)
  {
    if(Rx_Building_GDI_MoneyFactory(thisBuilding).IsDestroyed())
    {
      SetTimer(TickTime, true, nameof(CreditTickGDI));
      `log("[Credit Mutator] GDI refinery has died. Starting credit tick for GDI.");
    } else if(Rx_Building_Nod_MoneyFactory(thisBuilding).IsDestroyed())
    {
      SetTimer(TickTime, true, nameof(CreditTickNod));
      `log("[Credit Mutator] Nod refinery has died. Starting credit tick for Nod.");
    }
  }
}

reliable server function CreditTickGDI()
{
  local PlayerReplicationInfo PRI;

  foreach WorldInfo.GRI.PRIArray(pri)
  {
    if(Rx_PRI(pri) != None && Rx_PRI(pri).GetTeamNum() == TEAM_GDI) {
      Rx_PRI(pri).AddCredits(TickAmount); // Add credits to every GDI player.
    }
  }
}

reliable server function CreditTickNod()
{
  local PlayerReplicationInfo PRI;

  foreach WorldInfo.GRI.PRIArray(pri)
  {
    if(Rx_PRI(pri) != None && Rx_PRI(pri).GetTeamNum() == TEAM_NOD) {
      Rx_PRI(pri).AddCredits(TickAmount); // Add credits to every Nod player.
    }
  }
}

DefaultProperties
{
}
