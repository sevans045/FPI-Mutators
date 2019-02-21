class FPI_HUD_PlayerNames extends Rx_Hud_PlayerNames;

function DrawPlayerNames()
{
	local Rx_Pawn OtherPawn;
	local Pawn OurPawn;
	local string ScreenName;
	local float NameAlpha;
	local float OtherPawnDistance;
	local byte AntiTeamByte;
	local Rx_PRI aPRI;
	// No need to draw player names on dedicated
	if(RenxHud.WorldInfo.NetMode == NM_DedicatedServer)
		return;
	
	OurPawn = Pawn(RenxHud.PlayerOwner.ViewTarget);
	// Only draw if we have a pawn of some sort.
	if(OurPawn == None)
		return;
	
	AntiTeamByte = GetAntiTeamByte(RenxHud.PlayerOwner.GetTeamNum());
	
	// For each Rx_Pawn in the game
   	foreach RenxHud.WorldInfo.AllPawns(class'Rx_Pawn', OtherPawn)
	{
		if (OtherPawn == None || OtherPawn.PlayerReplicationInfo == None || OtherPawn.Health <= 0)
			continue;
		if ((OtherPawn == ourPawn && !RenxHud.ShowOwnName) || OtherPawn.DrivenVehicle != None)
			continue;
		if (IsStealthedEnemyUnit(OtherPawn) || IsEnemySpy(OtherPawn))
			continue;

		aPRI = Rx_PRI(OtherPawn.PlayerReplicationInfo);
		
		//Check if it is a targeted unit
		if(AntiTeamByte != 255 && aPRI.Unit_TargetStatus[AntiTeamByte] != 0)
			DrawAttackT(OtherPawn, aPRI.Unit_TargetNumber[AntiTeamByte],  aPRI.ClientTargetUpdatedTime ); 
		
		//Draw out commander 
		if(GetStance(OtherPawn) == STANCE_FRIENDLY && aPRI.bGetIsCommander()) 
			DrawCommanderIcon(OtherPawn);
		
		if (OurPawn.DrivenVehicle != none) // If we are in a vehicle, check distance from the vehicle location
			OtherPawnDistance = VSize(OurPawn.DrivenVehicle.Location-OtherPawn.location);
		else
			OtherPawnDistance = VSize(OurPawn.Location-OtherPawn.location);

		// Fade based on display radius.
		if (RenxHud.TargetingBox.TargetedActor == OtherPawn)
		{
			if(GetStance(OtherPawn) == STANCE_FRIENDLY)
				NameAlpha = GetAlphaForDistance(OtherPawnDistance,FriendlyTargetedDisplayNamesRadius);
			else
				NameAlpha = GetAlphaForDistance(OtherPawnDistance,EnemyTargetedDisplayNamesRadius);
		}
		else
		{
			if(GetStance(OtherPawn) == STANCE_FRIENDLY)
				NameAlpha = GetAlphaForDistance(OtherPawnDistance,FriendlyDisplayNamesRadius);
			else
				NameAlpha = GetAlphaForDistance(OtherPawnDistance,EnemyDisplayNamesRadius);
		}

		if (NameAlpha == 0 || !IsActorInView(OtherPawn))
			continue;		

		ScreenName = aPRI.GetHumanReadableName();
		ScreenName $= "\n"$FPI_PRI(aPRI).GetSpecialText();
		
		DrawNameOnActor(OtherPawn,ScreenName,GetStance(OtherPawn),NameAlpha);
   	}
}