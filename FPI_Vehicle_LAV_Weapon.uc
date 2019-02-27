
class FPI_Vehicle_LAV_Weapon extends Rx_Vehicle_MultiWeapon;

var	SoundCue WeaponDistantFireSnd[2];


DefaultProperties
{
    InventoryGroup=18
    
    SecondaryLockingDisabled=true
    
    ClipSize(0) = 12
    ClipSize(1) = 2

    ShotCost(0)=1
    ShotCost(1)=1

    ReloadTime(0) = 3.5// 3.0 2.0
    ReloadTime(1) = 10.0
    
    FireInterval(0)= 0.25
    FireInterval(1)=1.5
    bFastRepeater = true
    
    Spread(0)=0.01
    Spread(1)=0.02
	
	RecoilImpulse = -0.02f
    
	CloseRangeAimAdjustRange = 600  
	bCheckIfBarrelInsideWorldGeomBeforeFiring = true  
 
    // gun config
    FireTriggerTags(0)="CannonFireSocket"
	FireTriggerTags(1)="CannonFireSocket"

    AltFireTriggerTags(0)="MissileSocket1"
    AltFireTriggerTags(1)="MissileSocket2"

   
    VehicleClass=Class'FPI_Vehicle_LAV'

    WeaponFireSnd(0)     = SoundCue'RX_VH_LAV.Sounds.cannonfirecue'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'FPI_Vehicle_LAV_Cannon'
    WeaponFireSnd(1)     = SoundCue'RX_VH_LAV.Sounds.MissileFire'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'FPI_Vehicle_LAV_Rocket'
	
	WeaponDistantFireSnd(0)=SoundCue'RX_VH_M2Bradley.Sounds.SC_Cannon_DistantFire'
	WeaponDistantFireSnd(1)=SoundCue'TS_VH_HoverMRLS.Sounds.SC_Missile_DistantFire'

	WeaponProjectiles_Heroic(0)= Class'FPI_Vehicle_LAV_Cannon'
	WeaponProjectiles_Heroic(1)= Class'FPI_Vehicle_LAV_Rocket'
 
	WeaponFireSounds_Heroic(0)=SoundCue'RX_VH_LAV.Sounds.cannonfirecue'
	WeaponFireSounds_Heroic(1)=SoundCue'RX_VH_LAV.Sounds.MissileFire'
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
    
     // AI
    bRecommendSplashDamage=True
    bTargetLockingActive = false;
	
/***********************/
/*Veterancy*/
/**********************/
Vet_ClipSizeModifier(0)=0 //Normal +X
Vet_ClipSizeModifier(1)=0 //Veteran 
Vet_ClipSizeModifier(2)=1 //Elite
Vet_ClipSizeModifier(3)=2 //Heroic


Vet_ReloadSpeedModifier(0)=1 //Normal (should be 1) Reverse *X
Vet_ReloadSpeedModifier(1)=0.95 //Veteran 
Vet_ReloadSpeedModifier(2)=0.90 //Elite
Vet_ReloadSpeedModifier(3)=0.85 //Heroic

Vet_SecondaryClipSizeModifier(0)=0 //Normal +X
Vet_SecondaryClipSizeModifier(1)=0 //Veteran 
Vet_SecondaryClipSizeModifier(2)=0 //Elite
Vet_SecondaryClipSizeModifier(3)=1 //Heroic


Vet_SecondaryReloadSpeedModifier(0)=1 //Normal (should be 1) Reverse *X
Vet_SecondaryReloadSpeedModifier(1)=0.95 //Veteran 
Vet_SecondaryReloadSpeedModifier(2)=0.9 //Elite
Vet_SecondaryReloadSpeedModifier(3)=0.8 //Heroic

//Cannon
Vet_ROFSpeedModifier(0)=1 //Normal (should be 1) Reverse *X
Vet_ROFSpeedModifier(1)=0.925 //Veteran 
Vet_ROFSpeedModifier(2)=0.85 //Elite
Vet_ROFSpeedModifier(3)=0.7 //Heroic

//Missiles
Vet_SecondaryROFSpeedModifier(0)=1 //Normal (should be 1) Reverse *X
Vet_SecondaryROFSpeedModifier(1)=1 //Veteran 
Vet_SecondaryROFSpeedModifier(2)=1 //Elite
Vet_SecondaryROFSpeedModifier(3)=1 //Heroic 

/***********************************/

SF_Tolerance = 2


FM0_ROFTurnover = 1; //9 for most automatics. Single shot weapons should be more, except the shotgun
FM1_ROFTurnover = 2; 
}

