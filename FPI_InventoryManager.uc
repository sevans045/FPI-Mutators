/*********************************************************
*
* File: RxInventoryManager.uc
* Author: RenegadeX-Team 
* Project: Renegade-X UDK <www.renegade-x.com>
*
* Desc:
*  Overwrites the default pickup methods for the new inventory system.
*
* ConfigFile:
*
*********************************************************
* <3 Vipeax
*********************************************************/

class FPI_InventoryManager extends Rx_InventoryManager
	config(Game)
	abstract;

	defaultproperties
{
	AvailableItems(5) = class'FPI_Weapon_RepairTool'
}
