/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

 class FPI_Sys_Mutator extends Rx_Mutator;

var float ourServerFPS;
var FPI_Mut_Controller FPIController;
var int calcServerFPS;

function OnTick(float DeltaTime)
{
	// Keep server FPS here as well for Log file logging.
	ourServerFPS = 1 / DeltaTime;
	calcServerFPS++;
	
	if ( FPIController != None ) 
		FPIController.OnTick(DeltaTime);
}

function InitThisMutator()
{
	ourServerFPS = 0;
	
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		`log("[Sys Mutator] Server Found - Starting FPS Timer");
		setTimer(10, true, 'PrintourServerFPS');
	} else {
		`log("[Sys Mutator] Client Found, not logging FPS");
	}
	
	if ( Rx_Game(WorldInfo.Game) != None )
	{
		FPIController = Rx_Game(WorldInfo.Game).Spawn(class'FPI_Mut_Controller');
		
		`log("[Sys Mutator] Spawned Controller and Replication Info classes");
	}
}

function PrintourServerFPS()
{
	`log("[Sys Mutator] Server FPS: " $ ourServerFPS $ " Calc Server FPS: " $ string((calcServerFPS/10)));	
	calcServerFPS = 0;
}