//This has some bugs to work out still, so we don't need to use it for now.

class FPI_Weapon_PotGun extends Rx_Weapon_Reloadable;

/** class of deployable actor to spawn */
var class<Rx_Weapon_DeployedActor> DeployedActorClass;

/** Toss strength when throwing out deployable */
var float TossMag;

function bool Deploy()
{
	local vector SpawnLocation;
	local rotator Aim, FlatAim;
    local actor DeployedActor;

	SpawnLocation = GetPhysicalFireStartLoc();
	Aim = GetAdjustedAim(SpawnLocation);
    Aim.Pitch = Aim.Pitch + 2730;
    if(Aim.Pitch > 16380){
        Aim.Pitch = 16380;
    }

	FlatAim.Yaw = Aim.Yaw - 16384;

	DeployedActor = Spawn(DeployedActorClass,,, SpawnLocation, FlatAim);
	
	if (DeployedActor != None)
	{
		//DeployedActor.VRank=VRank; 
		
		//ClientSubtractAmmo();
		
		/*
		if ( AmmoCount <= 0 )
		{
			bForceHidden = true;
			Mesh.SetHidden(true);
		}
		*/
		DeployedActor.Velocity = TossMag * vector(Aim);
		return true;
	}

	return false;
}

simulated function CustomFire()
{
	Deploy();
}

DefaultProperties
{
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'RX_WP_PotGun.Mesh.SK_PotGun_1P'
		AnimSets(0)=AnimSet'RX_WP_PotGun.Anims.AS_PotGun_1P'
		Animations=MeshSequenceA
		Scale=2.5
		FOV=50.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'RX_WP_PotGun.Mesh.SK_PotGun_Back'
        Scale=1.0
    End Object

    AttachmentClass=class'Rx_Attachment_GrenadeLauncher'

	ArmsAnimSet=AnimSet'RX_WP_PotGun.Anims.AS_PotGun_Arms'

	PlayerViewOffset=(X=6.0,Y=1.0,Z=-3.0)
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	RightHandIK_Offset=(X=6,Y=-5,Z=-0.5)
	
	LeftHandIK_Relaxed_Offset = (X=0.000000,Y=-2.000000,Z=4.000000)
	
	FireOffset=(X=20,Y=17,Z=-20)
	
	//-------------- Recoil
	RecoilDelay = 0.07
	RecoilSpreadDecreaseDelay = 0.6
	MinRecoil = 450.0
	MaxRecoil = 525.0
	MaxTotalRecoil = 2000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 25.0
	RecoilDeclinePct = 1.0
	RecoilDeclineSpeed = 3.0
	RecoilSpread = 0.0
	MaxSpread = 0.1
	RecoilSpreadIncreasePerShot = 0.025
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadCrosshairScaling = 0;

    TossMag=1000
    DeployedActorClass=class'FPI_Weapon_DeployedFlowerPot'

    ShotCost(0)=1
    ShotCost(1)=2
    FireInterval(0)=+1.0
    FireInterval(1)=+0.1
    ReloadTime(0) = 3.0
    ReloadTime(1) = 3.0
    
    EquipTime=0.75
//	PutDownTime=0.5

    WeaponFireTypes(0)=EWFT_Custom
    WeaponFireTypes(1)=EWFT_Custom

    Spread(0)=0.025
    Spread(1)=0.3
   
    ClipSize = 10
    InitalNumClips = 4
    MaxClips = 4

    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
    ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"

    WeaponFireSnd[0]=SoundCue'RX_WP_PotGun.Sounds.SC_PotGun_Fire'
    WeaponFireSnd[1]=SoundCue'RX_WP_PotGun.Sounds.SC_PotGun_Fire'

    WeaponPutDownSnd=SoundCue'RX_WP_PotGun.Sounds.SC_PotGun_Equip'
    WeaponEquipSnd=SoundCue'RX_WP_PotGun.Sounds.SC_PotGun_PutDown'
    ReloadSound(0)=SoundCue'RX_WP_PotGun.Sounds.SC_PotGun_Reload'
    ReloadSound(1)=SoundCue'RX_WP_PotGun.Sounds.SC_PotGun_Reload'

    PickupSound=SoundCue'RX_WP_PotGun.Sounds.SC_PotGun_Pickup'

    MuzzleFlashSocket="MuzzleFlashSocket"
    FireSocket = "MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_PotGun.Effects.MuzzleFlash_1P'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
 
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_GrenadeLauncher'
	CrosshairDotMIC = MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Glass' // MaterialInstanceConstant'RenXHud.MI_Reticle_Dot'
	
	CrosshairWidth = 256
	CrosshairHeight = 256

    InventoryGroup=2
    InventoryMovieGroup=9

	WeaponIconTexture=Texture2D'RX_WP_PotGun.UI.T_WeaponIcon_PotGun'
    
    // AI Hints:
    //MaxDesireability=0.7
    AIRating=+0.3
    CurrentRating=+0.3
    bFastRepeater=false
    bInstantHit=false
    bSplashJump=false
    bRecommendSplashDamage=false
    bSniping=false

	/** one1: Added. */
	BackWeaponAttachmentClass = class'Rx_BackWeaponAttachment_GrenadeLauncher'
	
	/*******************/
	/*Veterancy*/
	/******************/
	
	
	Vet_ROFModifier(0) = 1
	Vet_ROFModifier(1) = 0.95 
	Vet_ROFModifier(2) = 0.9  
	Vet_ROFModifier(3) = 0.85  
	
	Vet_ClipSizeModifier(0)=0 //Normal (should be 1)	
	Vet_ClipSizeModifier(1)=0 //Veteran 
	Vet_ClipSizeModifier(2)=2 //Elite
	Vet_ClipSizeModifier(3)=4 //Heroic

	Vet_ReloadSpeedModifier(0)=1 //Normal (should be 1)
	Vet_ReloadSpeedModifier(1)=0.95 //Veteran 
	Vet_ReloadSpeedModifier(2)=0.9 //Elite
	Vet_ReloadSpeedModifier(3)=0.85 //Heroic
	/**********************/
	
	ROFTurnover = 4
}
