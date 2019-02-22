/*********************************************************
*
* File: Rx_Vehicle_Superhind_Weapon.uc
* Author: Iridesence
* Pojekt: Renegade-X UDK <www.renegade-x.com>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle_Superhind_Weapon extends Rx_Vehicle_Weapon_Reloadable;



var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)


/*********************************************************************************************
 * Shoot methods
 *********************************************************************************************/

simulated function FireAmmunition()
{
    Super.FireAmmunition();
	WeaponPlaySound( WeaponDistantFireSnd );
}

simulated function bool UsesClientSideProjectiles(byte CurrFireMode)
{
	return false;
}

simulated function GetFireStartLocationAndRotation(out vector SocketLocation, out rotator SocketRotation) {
    
    super.GetFireStartLocationAndRotation(SocketLocation, SocketRotation);    
    
    if( (Rx_Bot(MyVehicle.Controller) != None) && (Rx_Bot(MyVehicle.Controller).GetFocus() != None) ) {
        if(class'Rx_Utils'.static.OrientationOfLocAndRotToB(SocketLocation,SocketRotation,Rx_Bot(MyVehicle.Controller).GetFocus()) > 0.7) {
			MaxFinalAimAdjustment = 0.450;	
        } else {
            MaxFinalAimAdjustment = 0.990;
        }
    }
}

simulated function SetWeaponRecoil() {
	DeltaPitchX = 0.0;	
	recoiltime = 1.2;
	bWasNegativeRecoil = false;
	bWasPositiveRecoilSecondTime = false;
	RandRecoilIncrease = Rand(4);
}

simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local float DeltaPitch;
	
	if(recoiltime > 0) {
		recoiltime -= Deltatime;
		DeltaPitchXOld = DeltaPitchX;
		DeltaPitchX += (Deltatime*(20.0-RandRecoilIncrease/2.0));
		DeltaPitch = (5.0+RandRecoilIncrease)*sin(DeltaPitchX);

		if(DeltaPitch>0) {		
			if(bWasNegativeRecoil) {
				bWasPositiveRecoilSecondTime = true;
				return;
			} else {
				DeltaPitch = Deltapitch;
			}
		}
		if(DeltaPitch<0) {
			if(bWasPositiveRecoilSecondTime) {
				return;
			}
			bWasNegativeRecoil = true;
			DeltaPitch = Deltapitch;	
		}
		out_DeltaRot.Pitch += DeltaPitch;
		//loginternal("DeltaPitchX"$DeltaPitchX-DeltaPitchXOld);
		//loginternal("DeltaPitch"$DeltaPitch);
	}
}

DefaultProperties
{
    InventoryGroup=16

    // reload config
    ClipSize = 80
    InitalNumClips = 999
    MaxClips = 999
    
    ShotCost(0)=1
    
    ReloadTime(0) = 8.0
	
	RecoilImpulse = -0.00f
	
	CloseRangeAimAdjustRange = 200    
	bIgnoreDownwardPitch = false
    
    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"
  
    // gun config
    FireTriggerTags(0)="Rocket1"
    FireTriggerTags(1)="Rocket2"
    FireTriggerTags(2)="Rocket3"
    FireTriggerTags(3)="Rocket4"

    
    VehicleClass=Class'Rx_Vehicle_SuperHind'
    
    FireInterval(0)=0.10
    bFastRepeater=true
    
    Spread(0)=0.15
    Spread(1)=0.15
   
   /****************************************/
	/*Veterancy*/
	/****************************************/
	
	//*X (Applied to instant-hits only) Modify Projectiles separately
	Vet_DamageModifier(0)=1  //Normal
	Vet_DamageModifier(1)=1.10  //Veteran
	Vet_DamageModifier(2)=1.25  //Elite
	Vet_DamageModifier(3)=1.50  //Heroic
	
	//*X Reverse percentage (0.75 is 25% increase in speed)
	Vet_ROFModifier(0) = 1 //Normal
	Vet_ROFModifier(1) = 0.90  //Veteran
	Vet_ROFModifier(2) = 0.80  //Elite
	Vet_ROFModifier(3) = 0.65  //Heroic
 
	//+X
	Vet_ClipSizeModifier(0)=0 //Normal (should be 1)
	Vet_ClipSizeModifier(1)=2 //Veteran 
	Vet_ClipSizeModifier(2)=4 //Elite
	Vet_ClipSizeModifier(3)=6 //Heroic

	//*X Reverse percentage (0.75 is 25% increase in speed)
	Vet_ReloadSpeedModifier(0)=1 //Normal (should be 1)
	Vet_ReloadSpeedModifier(1)=0.95 //Veteran 
	Vet_ReloadSpeedModifier(2)=0.9 //Elite
	Vet_ReloadSpeedModifier(3)=0.80 //Heroic
	
	
	/********************************/
   
    WeaponFireSnd(0)     = SoundCue'RX_VH_Apache.Sounds.SC_Apache_Missile'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Vehicle_Superhind_Projectile'

    WeaponFireSnd(1)     = SoundCue'RX_VH_Apache.Sounds.SC_Apache_Missile'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Vehicle_Superhind_Projectile'
	
	//Heroic Modifiers
	WeaponProjectiles_Heroic(0)= Class'Rx_Vehicle_Superhind_Projectile_Heroic'
	
	ReloadSound(0)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Missiles'
	
	WeaponDistantFireSnd=SoundCue'RX_SoundEffects.Missiles.SC_Missile_DistantFire'
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
    
    // AI
    bRecommendSplashDamage=True

    bTargetLockingActive = false
    bHasRecoil = false
    
	FM0_ROFTurnover = 6; //9 for most automatics. Single shot weapons should be more, except the shotgun
	FM1_ROFTurnover = 6;
	
}