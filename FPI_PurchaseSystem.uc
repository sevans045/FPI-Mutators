/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_PurchaseSystem extends Rx_PurchaseSystem;

var int GDIItemPricesFPI[8];
var int NodItemPricesFPI[8];

function bool Check()
{
	return true;
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

DefaultProperties
{
	GDIInfantryClasses[0]  = class'FPI_FamilyInfo_GDI_Soldier'	
	GDIInfantryClasses[1]  = class'FPI_FamilyInfo_GDI_Shotgunner'
	GDIInfantryClasses[2]  = class'FPI_FamilyInfo_GDI_Grenadier'
	GDIInfantryClasses[3]  = class'FPI_FamilyInfo_GDI_Marksman'
	GDIInfantryClasses[4]  = class'FPI_FamilyInfo_GDI_Engineer'
	GDIInfantryClasses[5]  = class'FPI_FamilyInfo_GDI_Officer'
	GDIInfantryClasses[6]  = class'FPI_FamilyInfo_GDI_RocketSoldier'
	GDIInfantryClasses[7]  = class'FPI_FamilyInfo_GDI_McFarland'
	GDIInfantryClasses[8]  = class'FPI_FamilyInfo_GDI_Deadeye'
	GDIInfantryClasses[9]  = class'FPI_FamilyInfo_GDI_Gunner'
	GDIInfantryClasses[10] = class'FPI_FamilyInfo_GDI_Patch'
	GDIInfantryClasses[11] = class'FPI_FamilyInfo_GDI_Havoc'
	GDIInfantryClasses[12] = class'FPI_FamilyInfo_GDI_Sydney'
	GDIInfantryClasses[13] = class'FPI_FamilyInfo_GDI_Mobius'
	GDIInfantryClasses[14] = class'FPI_FamilyInfo_GDI_Hotwire'

	GDIItemPricesFPI[0] = 1000 
	GDIItemPricesFPI[1] = 800 
	GDIItemPricesFPI[2] = 0
	GDIItemPricesFPI[3] = 150 
	GDIItemPricesFPI[4] = 150 
	GDIItemPricesFPI[5] = 200 
	GDIItemPricesFPI[6] = 300 
	GDIItemPricesFPI[7] = 300 

	NodInfantryClasses[0]  = class'FPI_FamilyInfo_Nod_Soldier'
	NodInfantryClasses[1]  = class'FPI_FamilyInfo_Nod_Shotgunner'
	NodInfantryClasses[2]  = class'FPI_FamilyInfo_Nod_FlameTrooper'
	NodInfantryClasses[3]  = class'FPI_FamilyInfo_Nod_Marksman'
	NodInfantryClasses[4]  = class'FPI_FamilyInfo_Nod_Engineer'
	NodInfantryClasses[5]  = class'FPI_FamilyInfo_Nod_Officer'
	NodInfantryClasses[6]  = class'FPI_FamilyInfo_Nod_RocketSoldier'	
	NodInfantryClasses[7]  = class'FPI_FamilyInfo_Nod_ChemicalTrooper'
	NodInfantryClasses[8]  = class'FPI_FamilyInfo_Nod_blackhandsniper'
	NodInfantryClasses[9]  = class'FPI_FamilyInfo_Nod_Stealthblackhand'
	NodInfantryClasses[10] = class'FPI_FamilyInfo_Nod_LaserChainGunner'
	NodInfantryClasses[11] = class'FPI_FamilyInfo_Nod_Sakura'		
	NodInfantryClasses[12] = class'FPI_FamilyInfo_Nod_Raveshaw'//_Mutant'
	NodInfantryClasses[13] = class'FPI_FamilyInfo_Nod_Mendoza'
	NodInfantryClasses[14] = class'FPI_FamilyInfo_Nod_Technician'
	
	NodItemPricesFPI[0] = 1000 
	NodItemPricesFPI[1] = 800 
	NodItemPricesFPI[2] = 0 
	NodItemPricesFPI[3] = 150
	NodItemPricesFPI[4] = 150
	NodItemPricesFPI[5] = 200
	NodItemPricesFPI[6] = 300
	NodItemPricesFPI[7] = 300
}