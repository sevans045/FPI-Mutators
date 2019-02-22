/*********************************************************
*
* File: RxVehicle_RocketArtillery_Weapon.uc
* Author: RenegadeX-Team
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
class Rx_Vehicle_RocketArtillery_Weapon extends Rx_Vehicle_Weapon_Reloadable;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

simulated function FireAmmunition()
{
	super.FireAmmunition();
	WeaponPlaySound( WeaponDistantFireSnd );
}

simulated function GetFireStartLocationAndRotation(out vector SocketLocation, out rotator SocketRotation) {
    
    super.GetFireStartLocationAndRotation(SocketLocation, SocketRotation);    
    
    if( (Rx_Bot(MyVehicle.Controller) != None) && (Rx_Bot(MyVehicle.Controller).GetFocus() != None) ) {
        if(class'Rx_Utils'.static.OrientationOfLocAndRotToB(SocketLocation,SocketRotation,Rx_Bot(MyVehicle.Controller).GetFocus()) > 0.7) {
    		if(VSize(Rx_Bot(MyVehicle.Controller).GetFocus().location - MyVehicle.location) < CloseRangeAimAdjustRange)
    			MaxFinalAimAdjustment = 0.450;	
			else            
            	MaxFinalAimAdjustment = 0.990;
        } else {
            MaxFinalAimAdjustment = 0.990;
        }
    }
}

simulated function SetWeaponRecoil() {
	DeltaPitchX = 0.0;
	recoiltime = 1.6;
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
		DeltaPitchX += (Deltatime*(10.0-RandRecoilIncrease/2.0));
		DeltaPitch = (20.0+RandRecoilIncrease)*sin(DeltaPitchX);

		if(DeltaPitch>0) {		
			if(bWasNegativeRecoil) {
				DeltaPitch = DeltaPitch*2.4;
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
    InventoryGroup=20

    // reload config
    ClipSize = 40
    InitalNumClips = 999
    MaxClips = 999
    
    ShotCost(0)=1
    ShotCost(1)=1
     
    bReloadAfterEveryShot = false
    ReloadTime(0) = 10.0

    ReloadSound(0)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'
    ReloadSound(1)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'
        
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
	Vet_ROFModifier(1) = 1  //Veteran
	Vet_ROFModifier(2) = 1  //Elite
	Vet_ROFModifier(3) = 1  //Heroic
 
	//+X
	Vet_ClipSizeModifier(0)=0 //Normal (should be 1)
	Vet_ClipSizeModifier(1)=0 //Veteran 
	Vet_ClipSizeModifier(2)=0 //Elite
	Vet_ClipSizeModifier(3)=0 //Heroic

	//*X Reverse percentage (0.75 is 25% increase in speed)
	Vet_ReloadSpeedModifier(0)=1 //Normal (should be 1)
	Vet_ReloadSpeedModifier(1)=0.95 //Veteran 
	Vet_ReloadSpeedModifier(2)=0.9 //Elite
	Vet_ReloadSpeedModifier(3)=0.85 //Heroic
	
	
	/********************************/	
		
    // gun config
   FireTriggerTags(0)="MissileSocket1"
   FireTriggerTags(1)="MissileSocket2"
   FireTriggerTags(2)="MissileSocket3"
   FireTriggerTags(3)="MissileSocket4"
   FireTriggerTags(4)="MissileSocket5"
   FireTriggerTags(5)="MissileSocket6"
   FireTriggerTags(6)="MissileSocket7"
   FireTriggerTags(7)="MissileSocket8"
   FireTriggerTags(8)="MissileSocket9"
   FireTriggerTags(9)="MissileSocket10"
   FireTriggerTags(10)="MissileSocket11"
   FireTriggerTags(11)="MissileSocket12"
   FireTriggerTags(12)="MissileSocket13"
   FireTriggerTags(13)="MissileSocket14"
   FireTriggerTags(14)="MissileSocket15"
   FireTriggerTags(15)="MissileSocket16"
   FireTriggerTags(16)="MissileSocket17"
   FireTriggerTags(17)="MissileSocket18"
   FireTriggerTags(18)="MissileSocket19"
   FireTriggerTags(19)="MissileSocket20"
   FireTriggerTags(20)="MissileSocket21"
   FireTriggerTags(21)="MissileSocket22"
   FireTriggerTags(22)="MissileSocket23"
   FireTriggerTags(23)="MissileSocket24"
   FireTriggerTags(24)="MissileSocket25"
   FireTriggerTags(25)="MissileSocket26"
   FireTriggerTags(26)="MissileSocket27"
   FireTriggerTags(27)="MissileSocket28"
   FireTriggerTags(28)="MissileSocket29"
   FireTriggerTags(29)="MissileSocket30"
   FireTriggerTags(30)="MissileSocket31"
   FireTriggerTags(31)="MissileSocket32"
   FireTriggerTags(32)="MissileSocket33"
   FireTriggerTags(33)="MissileSocket34"
   FireTriggerTags(34)="MissileSocket35"
   FireTriggerTags(35)="MissileSocket36"
   FireTriggerTags(36)="MissileSocket37"
   FireTriggerTags(37)="MissileSocket38"
   FireTriggerTags(38)="MissileSocket39"
   FireTriggerTags(39)="MissileSocket40"
   AltFireTriggerTags(0)="MissileSocket1"
   AltFireTriggerTags(1)="MissileSocket2"
   AltFireTriggerTags(2)="MissileSocket3"
   AltFireTriggerTags(3)="MissileSocket4"
   AltFireTriggerTags(4)="MissileSocket5"
   AltFireTriggerTags(5)="MissileSocket6"
   AltFireTriggerTags(6)="MissileSocket7"
   AltFireTriggerTags(7)="MissileSocket8"
   AltFireTriggerTags(8)="MissileSocket9"
   AltFireTriggerTags(9)="MissileSocket10"
   AltFireTriggerTags(10)="MissileSocket11"
   AltFireTriggerTags(11)="MissileSocket12"
   AltFireTriggerTags(12)="MissileSocket13"
   AltFireTriggerTags(13)="MissileSocket14"
   AltFireTriggerTags(14)="MissileSocket15"
   AltFireTriggerTags(15)="MissileSocket16"
   AltFireTriggerTags(16)="MissileSocket17"
   AltFireTriggerTags(17)="MissileSocket18"
   AltFireTriggerTags(18)="MissileSocket19"
   AltFireTriggerTags(19)="MissileSocket20"
   AltFireTriggerTags(20)="MissileSocket21"
   AltFireTriggerTags(21)="MissileSocket22"
   AltFireTriggerTags(22)="MissileSocket23"
   AltFireTriggerTags(23)="MissileSocket24"
   AltFireTriggerTags(24)="MissileSocket25"
   AltFireTriggerTags(25)="MissileSocket26"
   AltFireTriggerTags(26)="MissileSocket27"
   AltFireTriggerTags(27)="MissileSocket28"
   AltFireTriggerTags(28)="MissileSocket29"
   AltFireTriggerTags(29)="MissileSocket30"
   AltFireTriggerTags(30)="MissileSocket31"
   AltFireTriggerTags(31)="MissileSocket32"
   AltFireTriggerTags(32)="MissileSocket33"
   AltFireTriggerTags(33)="MissileSocket34"
   AltFireTriggerTags(34)="MissileSocket35"
   AltFireTriggerTags(35)="MissileSocket36"
   AltFireTriggerTags(36)="MissileSocket37"
   AltFireTriggerTags(37)="MissileSocket38"
   AltFireTriggerTags(38)="MissileSocket39"
   AltFireTriggerTags(39)="MissileSocket40"
   VehicleClass=Class'Rx_Vehicle_RocketArtillery'

   FireInterval(0)=0.10
   FireInterval(1)=0.10

   Spread(0)=0.05
   Spread(1)=0.05
   
   bHasRecoil = false
   RecoilImpulse = -0.0f
 
   WeaponFireSnd(0)     = SoundCue'RX_VH_RocketArtillery.Sounds.RocketFire'
   WeaponFireTypes(0)   = EWFT_Projectile
   WeaponProjectiles(0) = Class'Rx_Vehicle_RocketArtillery_Projectile_Arc'
   WeaponFireSnd(1)     = SoundCue'RX_VH_RocketArtillery.Sounds.RocketFire'
   WeaponFireTypes(1)   = EWFT_Projectile
   WeaponProjectiles(1) = Class'Rx_Vehicle_RocketArtillery_Projectile_Arc'
      
   WeaponDistantFireSnd=SoundCue'TS_VH_HoverMRLS.Sounds.SC_Missile_DistantFire'

   // CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Artillery'
   CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
   
//	CrosshairWidth = 512
//	CrosshairHeight = 512
   
    // AI
   bRecommendSplashDamage=True
   
   FM0_ROFTurnover = 2; //9 for most automatics. Single shot weapons should be more, except the shotgun

}
