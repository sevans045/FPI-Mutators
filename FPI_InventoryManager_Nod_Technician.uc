class FPI_InventoryManager_Nod_Technician extends FPI_InventoryManager_Adv_NOD;

function int GetPrimaryWeaponSlots() { return 3; }

DefaultProperties
{
	PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced' //2
	PrimaryWeapons[1] = class'Rx_Weapon_RemoteC4' //4
	
	SidearmWeapons[0] = class'Rx_Weapon_Pistol'// class'Rx_Weapon_HeavyPistol' //1
	AvailableSidearmWeapons(0) = class'Rx_Weapon_Pistol' //class'Rx_Weapon_HeavyPistol' //1
	
 	PrimaryWeapons[2] = class'Rx_Weapon_TimedC4_Multiple' //3
 	ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4' //6
	
	AvailableExplosiveWeapons(0) = class'FPI_Weapon_ProxyC4'	

// 	PrimaryWeapons[2] = class'Rx_Weapon_ProxyC4'
// 	ExplosiveWeapons[0] = class'Rx_Weapon_TimedC4_Multiple'
 //AvailableExplosiveWeapons(1) = class'Rx_Weapon_Grenade'
//AvailableExplosiveWeapons(2) = class'Rx_Weapon_ATMine'			
}
