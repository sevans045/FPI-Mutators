/*********************************************************
*
* File: Rx_GFxPurchaseMenu.uc
* Author: Kind of HIHIHI
* Pojekt: Renegade-X UDK <www.renegade-x.com>
*
* Desc: This class handles the creation and modification of the 
* Purchase Menu when opening a terminal.
* It is created and called by Rx_BuildingAttachment_PT.uc.
* 
* Related Flash content:   RenXPurchaseMenu.fla
*
* ConfigFile: 
*
*********************************************************
*  
*********************************************************
*  Drawboards
* 
* after finishing init, set the first selection.
* 
* 
* item clik cause the group to set selected on the selection
* use the item click on the selected to show dummy pawn
* 
* purchase button set
* 
* 
* 
* 
* 
* 
* 
*********************************************************/
class FPI_GFxPurchaseMenu extends Rx_GFxPurchaseMenu;

function ChangeDummyPawnClass(int classNum)
{
    local class<Rx_FamilyInfo> rxCharInfo;   
	
	if (TeamID == TEAM_GDI) 
	{
	 	rxCharInfo = FPI_PurchaseSystem(rxPurchaseSystem).GDIInfantryClassesFPI[classNum];	
	} else 
	{
		rxCharInfo = FPI_PurchaseSystem(rxPurchaseSystem).NodInfantryClassesFPI[classNum];	
	}
	DummyPawn.SetHidden(false);
	DummyPawn.SetCharacterClassFromInfo(rxCharInfo);
	DummyPawn.RefreshAttachedWeapons();
}

// This function only exists because of the sheer amount of indexes in this implementation of a Purchase Terminal.
function class<Rx_FamilyInfo> IndexToClass(int index, byte TeamNum) {
	if (rxPurchaseSystem != None) {
		if (TeamNum == TEAM_GDI)
			return FPI_PurchaseSystem(rxPurchaseSystem).GDIInfantryClassesFPI[index];
		else
			return FPI_PurchaseSystem(rxPurchaseSystem).NodInfantryClassesFPI[index];
	}

	return None;
}

DefaultProperties
{
}