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
	GDIItemPricesFPI[0] = 1000 
	GDIItemPricesFPI[1] = 800 
	GDIItemPricesFPI[2] = 0
	GDIItemPricesFPI[3] = 150 
	GDIItemPricesFPI[4] = 150 
	GDIItemPricesFPI[5] = 200 
	GDIItemPricesFPI[6] = 300 
	GDIItemPricesFPI[7] = 300 

	NodItemPricesFPI[0] = 1000 
	NodItemPricesFPI[1] = 800 
	NodItemPricesFPI[2] = 0 
	NodItemPricesFPI[3] = 150
	NodItemPricesFPI[4] = 150
	NodItemPricesFPI[5] = 200
	NodItemPricesFPI[6] = 300
	NodItemPricesFPI[7] = 300
}