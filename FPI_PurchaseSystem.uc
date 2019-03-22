/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_PurchaseSystem extends Rx_PurchaseSystem;

var int GDIItemPricesFPI[8];
var int NodItemPricesFPI[8];
var const array<class<Rx_FamilyInfo> >	GDIInfantryClassesFPI;
var const array<class<Rx_FamilyInfo> >	NodInfantryClassesFPI;
var const array<class<Rx_Weapon> >		GDIItemClassesFPI;
var const array<class<Rx_Weapon> >		NodItemClassesFPI;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	//SetTimer( 3.0, false, UpdateMapSpecificInfantryClasses());
}

function bool Check()
{
	return true;
}

simulated function class<Rx_FamilyInfo> GetStartClass(byte TeamID, PlayerReplicationInfo PRI)
{
	if ( TeamID == TEAM_GDI )
	{
		//set starting class based on the last free class (nBab)
		return GDIInfantryClassesFPI[Rx_PRI(PRI).LastFreeCharacterClass];
	} 
	else
	{
		//set starting class based on the last free class (nBab)
		return NodInfantryClassesFPI[Rx_PRI(PRI).LastFreeCharacterClass];
	}
}

simulated function class<Rx_FamilyInfo> GetHealerClass(byte TeamID)
{
	if ( TeamID == TEAM_GDI )
	{
		return GDIInfantryClassesFPI[13];
	} 
	else
	{
		return NodInfantryClassesFPI[13];
	}
}

simulated function bool IsStealthBlackHand(Rx_PRI pri)
{
	if ( pri.CharClassInfo == NodInfantryClassesFPI[9] )
	{
		return True;
	}
	return False;
}

simulated function int GetItemPrices(byte teamID, int charid)
{
	if (teamID == TEAM_GDI)
	{
		return GDIItemPricesFPI[charid];
	} 
	else
	{
		return NodItemPricesFPI[charid];
	}
}

simulated function class<Rx_FamilyInfo> GetFamilyClass(byte teamID, int charid)
{
	if (teamID == TEAM_GDI)
	{
		return GDIInfantryClassesFPI[charid];
	} 
	else
	{
		return NodInfantryClassesFPI[charid];
	}
}

simulated function class<Rx_Weapon> GetItemClass(byte teamID, int itemid)
{
	if (teamID == TEAM_GDI)
	{
		return GDIItemClassesFPI[itemid];
	} 
	else
	{
		return NodItemClassesFPI[itemid];
	}
}

/*******************************/
/* Bot Specific Functionality  */
/*******************************/

function bool DoesHaveRepairGun( class<UTFamilyInfo> inFam )
{
	if ( inFam == GDIInfantryClasses[4] || inFam == NodInfantryClasses[4] || inFam == GDIInfantryClasses[14] || inFam == NodInfantryClasses[14] || 
				inFam == GDIInfantryClassesFPI[4] || inFam == NodInfantryClassesFPI[4] || inFam == GDIInfantryClassesFPI[14] || inFam == NodInfantryClassesFPI[14] )
	{
		return true;
	}
	return false;	
}

DefaultProperties
{
	GDIInfantryClassesFPI[0]  = class'FPI_FamilyInfo_GDI_Soldier'	
	GDIInfantryClassesFPI[1]  = class'FPI_FamilyInfo_GDI_Shotgunner'
	GDIInfantryClassesFPI[2]  = class'FPI_FamilyInfo_GDI_Grenadier'
	GDIInfantryClassesFPI[3]  = class'FPI_FamilyInfo_GDI_Marksman'
	GDIInfantryClassesFPI[4]  = class'FPI_FamilyInfo_GDI_Engineer'
	GDIInfantryClassesFPI[5]  = class'FPI_FamilyInfo_GDI_Officer'
	GDIInfantryClassesFPI[6]  = class'FPI_FamilyInfo_GDI_RocketSoldier'
	GDIInfantryClassesFPI[7]  = class'FPI_FamilyInfo_GDI_McFarland'
	GDIInfantryClassesFPI[8]  = class'FPI_FamilyInfo_GDI_Deadeye'
	GDIInfantryClassesFPI[9]  = class'FPI_FamilyInfo_GDI_Gunner'
	GDIInfantryClassesFPI[10] = class'FPI_FamilyInfo_GDI_Patch'
	GDIInfantryClassesFPI[11] = class'FPI_FamilyInfo_GDI_Havoc'
	GDIInfantryClassesFPI[12] = class'FPI_FamilyInfo_GDI_Sydney'
	GDIInfantryClassesFPI[13] = class'FPI_FamilyInfo_GDI_Mobius'
	GDIInfantryClassesFPI[14] = class'FPI_FamilyInfo_GDI_Hotwire'

	GDIItemClassesFPI[0]  = class'Rx_Weapon_IonCannonBeacon'
	GDIItemClassesFPI[1]  = class'Rx_Weapon_Airstrike_GDI'
	GDIItemClassesFPI[2]  = class'FPI_Weapon_RepairTool'

	GDIItemPricesFPI[0] = 1000 
	GDIItemPricesFPI[1] = 800 
	GDIItemPricesFPI[2] = 0
	GDIItemPricesFPI[3] = 150 
	GDIItemPricesFPI[4] = 150 
	GDIItemPricesFPI[5] = 200 
	GDIItemPricesFPI[6] = 300 
	GDIItemPricesFPI[7] = 300 

	NodInfantryClassesFPI[0]  = class'FPI_FamilyInfo_Nod_Soldier'
	NodInfantryClassesFPI[1]  = class'FPI_FamilyInfo_Nod_Shotgunner'
	NodInfantryClassesFPI[2]  = class'FPI_FamilyInfo_Nod_FlameTrooper'
	NodInfantryClassesFPI[3]  = class'FPI_FamilyInfo_Nod_Marksman'
	NodInfantryClassesFPI[4]  = class'FPI_FamilyInfo_Nod_Engineer'
	NodInfantryClassesFPI[5]  = class'FPI_FamilyInfo_Nod_Officer'
	NodInfantryClassesFPI[6]  = class'FPI_FamilyInfo_Nod_RocketSoldier'	
	NodInfantryClassesFPI[7]  = class'FPI_FamilyInfo_Nod_ChemicalTrooper'
	NodInfantryClassesFPI[8]  = class'FPI_FamilyInfo_Nod_blackhandsniper'
	NodInfantryClassesFPI[9]  = class'FPI_FamilyInfo_Nod_Stealthblackhand'
	NodInfantryClassesFPI[10] = class'FPI_FamilyInfo_Nod_LaserChainGunner'
	NodInfantryClassesFPI[11] = class'FPI_FamilyInfo_Nod_Sakura'		
	NodInfantryClassesFPI[12] = class'FPI_FamilyInfo_Nod_Raveshaw'//_Mutant'
	NodInfantryClassesFPI[13] = class'FPI_FamilyInfo_Nod_Mendoza'
	NodInfantryClassesFPI[14] = class'FPI_FamilyInfo_Nod_Technician'
	
	NodItemPricesFPI[0] = 1000 
	NodItemPricesFPI[1] = 800 
	NodItemPricesFPI[2] = 0 
	NodItemPricesFPI[3] = 150
	NodItemPricesFPI[4] = 150
	NodItemPricesFPI[5] = 200
	NodItemPricesFPI[6] = 300
	NodItemPricesFPI[7] = 300

	NodItemClassesFPI[0]  = class'Rx_Weapon_NukeBeacon'
	NodItemClassesFPI[1]  = class'Rx_Weapon_Airstrike_Nod'
	NodItemClassesFPI[2]  = class'FPI_Weapon_RepairTool'
}