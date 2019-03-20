/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

 class FPI_PRI extends Rx_PRI;

var repnotify string MutatorVersion, SpecialText;

 replication
{
	if(bNetDirty || bNetInitial)
		MutatorVersion, SpecialText;
}

simulated event ReplicatedEvent(name VarName)
{
    if(VarName == 'SpecialText')
        SetText(SpecialText);
    else
       super.ReplicatedEvent(VarName);
}

reliable client function WriteMutatorVersion(string Version)
{
	MutatorVersion = Version;
}

function string ReadMutatorVersion()
{
	return ClientReadMutatorVersion();
}

reliable client function string ClientReadMutatorVersion()
{
	return MutatorVersion;
}

function SetChar(class<Rx_FamilyInfo> newFamily, Pawn pawn, optional bool isFreeClass)
{
   local Rx_Pawn rxPawn;

   bIsSpy = false;

	if (newFamily != none)
		CharClassInfo = newFamily;
	else
		return;
	
	if((WorldInfo.NetMode == NM_ListenServer && RemoteRole == ROLE_SimulatedProxy) || WorldInfo.NetMode == NM_Standalone)
		UpdateCharClassInfo();
	else if(newFamily != None)
		Rx_Pawn(pawn).SetCharacterClassFromInfo(newFamily);

		if (self.CharClassInfo == class'Rx_FamilyInfo_Nod_StealthBlackHand')
		{
			if(Rx_Controller(Owner) != none)
				Rx_Controller(Owner).ChangeToSBH(true);
			else if(Rx_Bot(Owner) != none)
				Rx_Bot(Owner).ChangeToSBH(true);
		}
		else
		{
			if(Rx_Controller(Owner) != none)
				Rx_Controller(Owner).ChangeToSBH(false);
			else if(Rx_Bot(Owner) != none)
				Rx_Bot(Owner).ChangeToSBH(false);
		}

   rxPawn = Rx_Pawn(pawn);

   if (rxPawn == none || Team == none)
      return;
   
   equipStartWeapons(isFreeClass);
}

reliable server function ServerSetLastFreeCharacter(int fClass)
{
	local byte TeamID;
	local array<class<Rx_FamilyInfo> > ClassList;

	TeamID = GetTeamNum();

	if(TeamID == TEAM_GDI)
	{
		ClassList = class'Rx_PurchaseSystem'.default.FPI;
	}
	else if(TeamID == TEAM_NOD)
	{
		ClassList = class'Rx_PurchaseSystem'.default.NodInfantryClassesFPI;
	}

	if(fClass < 0 || fClass > ClassList.Length || ClassList[fClass].default.BasePurchaseCost != 0)
	{
		return;
	}

	LastFreeCharacterClass = fClass;
}

simulated function string GetSpecialText()
{
	return SpecialText;
}

simulated function SetSpecialText(string Text)
{
	SetText(Text);
}

simulated function SetText(string Text)
{
	SpecialText = Text;
}