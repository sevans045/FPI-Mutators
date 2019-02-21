/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */
 
class FPI_ServerTravelMutator extends Rx_Mutator
config(FPI);

var config string ServerDestination;
var config bool bAutomaticallySplitServer;
var config int PlayerAmountSplit;

function InitThisMutator()
{
    `log("################################");
    `log("[Server Travel Mutator] Successfully inited!");
    `log("################################");
}

function FPIServerTravel()
{
    local string NextMap;
    local Guid NextMapGuid;
    local PlayerController c;
    local int i;
    local int PlayerCount;
    
    PlayerCount = `WorldInfoObject.Game.NumPlayers-1;
    NextMap = string(WorldInfo.GetPackageName());
    NextMapGuid = GetPackageGuid(name(NextMap));
    FPI_Game(`WorldInfoObject.Game).SetMaxPlayers(40);
    
    if(bAutomaticallySplitServer == true)
      	{
      		if(PlayerCount > PlayerAmountSplit || PlayerCount == PlayerAmountSplit)
      		{
      		    foreach WorldInfo.AllControllers(class'PlayerController', c)
      		    {
      		        if(Rx_Controller(c) != none && i == 0) {
      		            C.ClientTravel(ServerDestination, TRAVEL_Relative, false, NextMapGuid);
      		        	i++;
      		        } else if (Rx_Controller(c) != none && i > 0) {
      		            i--;
      		    	    return;
      		        }
      		    }
    		}
      	}
}



DefaultProperties
{
}