/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_InventoryMutator extends UTMutator;

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('Rx_InventoryManager_GDI_Hotwire'))
	{
		Rx_InventoryManager_GDI_Hotwire(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
		Rx_InventoryManager_GDI_Hotwire(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
	} else if (Other.IsA('Rx_InventoryManager_Nod_Technician'))
	{
		Rx_InventoryManager_Nod_Technician(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
		Rx_InventoryManager_Nod_Technician(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
	}
	return true;
}