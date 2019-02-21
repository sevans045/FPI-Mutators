/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

 class FPI_Mut_Controller extends ReplicationInfo;

var repnotify float ServerFPS;
var float PrivateServerFPS;
var repnotify int CurrentActors;
var float PrivateServerDeltaTime;
var repnotify float ServerDeltaTime;
var repnotify int StaffMembersIngame;

replication
{
	if(bNetDirty || bNetInitial)
		ServerFPS,CurrentActors,ServerDeltaTime,StaffMembersIngame;
}

simulated function PostBeginPlay()
{
	setTimer(1, true, 'CollectData');
}

function CollectData()
{
	local int counter, adminingame;
	local Actor thisActor;
	local Rx_Controller c;
	
	if(`WorldInfoObject.NetMode != NM_DedicatedServer)
		return;
	
	// Actors in game
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Actor', thisActor)
	{
		counter ++;
	}

	// Ingame admins stats
  	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Rx_Controller', c)
  	{
 		if (c.PlayerReplicationInfo.bAdmin)
    	   	 adminingame++;
  	}

	CurrentActors = counter;
	ServerFPS = PrivateServerFPS;
	ServerDeltaTime = PrivateServerDeltaTime;
	StaffMembersIngame = adminingame;
}

function OnTick(float DeltaTime)
{
	CalcServerFPS(DeltaTime);
}

reliable server function CalcServerFPS(float DeltaTime)
{
	// Are we a dedicated server?
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		// Calc servers FPS on this tick
		PrivateServerFPS = 1 / DeltaTime;
		PrivateServerDeltaTime = DeltaTime;
	}
}
