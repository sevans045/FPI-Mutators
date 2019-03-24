class FPI_Weapon_NukeGun extends Rx_Weapon_Reloadable;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

/*
simulated function bool UsesClientSideProjectiles(byte FireMode)
{
	return FireMode==1;
}
*/


DefaultProperties
{
	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'FPI_WP_Special.Meshes.SK_WP_MissileLauncher_1P'
		AnimSets(0)=AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Weapon'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=55.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'FPI_WP_Special.Meshes.SK_WP_MissileLauncher_Back'
		//Translation=(X=-25)
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Arms'

	AttachmentClass = class'FPI_Attachment_NukeGun'
	
	PlayerViewOffset=(X=0.0,Y=0.0,Z=-1.5)
	WideScreenOffsetScaling = 0.0
	BobDamping = 0.85
	JumpDamping = 0.5

	FireOffset=(X=20,Y=10,Z=-3)
	
	LeftHandIK_Offset=(X=-3.054600,Y=-3.855900,Z=0.031600)
	LeftHandIK_Rotation=(Pitch=910,Yaw=2002,Roll=-1092)
	RightHandIK_Offset=(X=4.0,Y=-2.0,Z=2.0)
	
	LeftHandIK_Relaxed_Offset = (X=-4.000000,Y=-4.000000,Z=-1.000000)
	LeftHandIK_Relaxed_Rotation = (Pitch=0,Yaw=0,Roll=3640)
	RightHandIK_Relaxed_Offset = (X=0.000000,Y=-5.000000,Z=-8.000000)
	RightHandIK_Relaxed_Rotation = (Pitch=-5461,Yaw=6189,Roll=14017)
	
	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed
	
	//-------------- Recoil
	RecoilDelay = 0.07
	RecoilSpreadDecreaseDelay = 0.1
	MinRecoil = 1000.0
	MaxRecoil = 1200.0
	MaxTotalRecoil = 5000.0
	RecoilYawModifier = 0.75 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 60.0
	RecoilDeclinePct = 0.75
	RecoilDeclineSpeed = 4.0
	RecoilSpread = 0.0
	MaxSpread = 0.1
	RecoilSpreadIncreasePerShot = 0.0
	RecoilSpreadDeclineSpeed = 0.03

	ShotCost(0)=1
	ShotCost(1)=1
	FireInterval(0)=+0.4
	FireInterval(1)=+0.4
	ReloadTime(0) = 3.2
	ReloadTime(1) = 3.2
	
	EquipTime=0.75
	PutDownTime=0.5

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
	
	WeaponProjectiles(0)=class'FPI_Projectile_NukeGun'
	WeaponProjectiles(1)=class'FPI_Projectile_NukeGun'

	WeaponProjectiles_Heroic(0)=class'FPI_Projectile_NukeGun'
	WeaponProjectiles_Heroic(1)=class'FPI_Projectile_NukeGun'
	
	Spread(0)=0.0
	Spread(1)=0.0
	
	ClipSize = 1
	InitalNumClips = 13
	MaxClips = 13

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_RocketLauncher_Reload"
	ReloadAnim3PName(1) = "H_M_RocketLauncher_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"

	WeaponFireSnd[0]=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_Fire'
	WeaponFireSnd[1]=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_Fire'
	
	WeaponDistantFireSnd=SoundCue'RX_WP_RocketLauncher.Sounds.SC_RocketLauncher_DistantFire'

	WeaponPutDownSnd=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_PutDown'
	WeaponEquipSnd=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_Equip'
	ReloadSound(0)=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_Reload'
	ReloadSound(1)=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_Reload'
	
	

	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	MuzzleFlashSocket="MuzzleFlashSocket"
	FireSocket = "MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_MissileLauncher.Effects.P_MuzzleFlash'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_RocketLauncher'

	InventoryGroup=2
	InventoryMovieGroup=16

	WeaponIconTexture=Texture2D'RX_WP_MissileLauncher.UI.T_WeaponIcon_MissileLauncher'
	
	// AI Hints:
	// MaxDesireability=0.7
	AIRating=+0.4
	CurrentRating=+0.4
	bFastRepeater=false
	bInstantHit=false
	bSplashJump=false
	bRecommendSplashDamage=true
	bSniping=false   

	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = false	
	bDisplayCrosshairInIronsight = true
	IronSightViewOffset=(X=-8,Y=0,Z=3)
	IronSightFireOffset=(X=20,Y=7,Z=0)
	IronSightBobDamping=1
	IronSightPostAnimDurationModifier=1.0
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=35.0 
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=100
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2
	IronSightMaxRecoilDamping = 2
	IronSightMaxTotalRecoilDamping = 2
	IronSightRecoilYawDamping = 1
	IronSightMaxSpreadDamping = 2
	IronSightSpreadIncreasePerShotDamping = 4

	/** one1: Added. */
	BackWeaponAttachmentClass = class'FPI_BackWeaponAttachment_NukeGun'
	
	
	/*******************/
	/*Veterancy*/
	/******************/

	Vet_ReloadSpeedModifier(0)=1 //Normal (should be 1)
	Vet_ReloadSpeedModifier(1)=0.95 //Veteran 
	Vet_ReloadSpeedModifier(2)=0.9 //Elite
	Vet_ReloadSpeedModifier(3)=0.80 //Heroic
	/**********************/
	//17 > 12 
	Elite_Building_DamageMod = 1.33 //1.75 //Increase building damage at Elite 
	Ammo_Increment = 4

	CustomWeaponName = "Nuke Gun"
}
