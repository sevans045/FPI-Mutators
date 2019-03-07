class FPI_InventoryManager_GDI_Gunner extends FPI_InventoryManager_Adv_GDI;

DefaultProperties
{
	PrimaryWeapons[0] = class'Rx_Weapon_RocketLauncher' //2
	//PrimaryWeapons[1] = class'Rx_Weapon_EMPGrenade_Rechargeable' //5
	PrimaryWeapons[2] = class'Rx_Weapon_ATMine' //4
	
	SidearmWeapons(0) = class'Rx_Weapon_Carbine' //1
	
	AvailableSidearmWeapons(0) = class'Rx_Weapon_Carbine' 
	
	AvailableAbilityWeapons(0) = class'Rx_WeaponAbility_EMPGrenade' 
}
