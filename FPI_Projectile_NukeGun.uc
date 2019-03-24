class FPI_Projectile_NukeGun extends Rx_Projectile;

var ParticleSystem   ExplosionEffectP, SecondaryExplosionEffectP;
var LightComponent ExplosionLight;

/**
 * Set the initial velocity and cook time
 */
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
//    SetTimer(4.0+FRand()*0.5,false);                  // Grenade begins unarmed
//    RandSpin(100000);
}

function Init(vector Direction)
{
    super.Init(Direction);

    TossZ = TossZ + (FRand() * TossZ / 2.0) - (TossZ / 4.0);
    Velocity.Z += TossZ;
    Acceleration = AccelRate * Normal(Velocity);
}


/**
 * When a grenade enters the water, kill effects/velocity and let it sink
 */
simulated function PhysicsVolumeChange( PhysicsVolume NewVolume )
{
    if ( WaterVolume(NewVolume) != none )
    {
        Velocity *= 0.15;
    }

    Super.PhysicsVolumeChange(NewVolume);
}


simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(0.85f);
}


simulated function Explode(vector HitLocation, vector HitNormal)
{
    local rotator SpawnRotation;
    local vector loc;
    local ParticleSystemComponent   ExplosionParticle, ExplosionParticleSecondary;

    SpawnRotation = Rotation;
    SpawnRotation.Pitch = 0;
    loc = location;

    ExplosionParticle = WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionEffectP, loc, SpawnRotation);
    ExplosionParticleSecondary = WorldInfo.MyEmitterPool.SpawnEmitter(SecondaryExplosionEffectP, loc, SpawnRotation);
    ExplosionParticle.SetScale(0.05);
    ExplosionParticleSecondary.SetScale(0.05);
    
    loc.z += 1024;
    if(ExplosionLightClass != None)
        ExplosionLight = UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight( ExplosionLightClass, loc);
        //ExplosionLight.SetScale(0.025);
    //PlayCamerashakeAnim();
    
    super.Explode(HitLocation, HitNormal);
}



DefaultProperties
{

    ImpactSound=SoundCue'RX_WP_Grenade.Sounds.SC_Grenade_Bounce'

    ProjFlightTemplate=ParticleSystem'FPI_WP_Special.Effects.P_NukeLauncher'
	AmbientSound=SoundCue'RX_WP_GrenadeLauncher.Sounds.SC_GrenadeLauncher_Ambient'

    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=none,Sound=SoundCue'FPI_WP_Special.Sounds.SCue_Explosion_Nuke')
	
    DrawScale= 1.0
    
    Physics=PHYS_Falling
	
	CustomGravityScaling=0.75
    
    MyDamageType=class'FPI_DmgType_NukeGun'
    
    TossZ=100 	// 150.0
    Speed=2000 	// 2000
    MaxSpeed=2000
	TerminalVelocity=2000.0
    AccelRate=0
    LifeSpan=15.0
    Damage=35
    DamageRadius=200//200
    MomentumTransfer=1000000
	HeadShotDamageMult=2.0

    bCollideComplex=true
    bCollideWorld=true
    bBounce=true
    bNetTemporary=false
    bRotationFollowsVelocity=true
    bBlockedByInstigator=false //true WHY?
    bSuppressExplosionFX=false // Do not spawn hit effect in mid air
	bWaitForEffectsAtEndOfLifetime = true
    bWaitForEffects=true
	ExplosionLightClass=Class'RenX_Game.Rx_Light_Tank_Explosion'

    ExplosionEffectP=ParticleSystem'RX_WP_Nuke.Effects.P_Nuke_Explosion'
    SecondaryExplosionEffectP=ParticleSystem'RX_WP_Nuke.Effects.P_Explosion_Secondary'

	/*************************/
	/*VETERANCY*/
	/************************/
	
	Vet_DamageIncrease(0)=1 //Normal (should be 1)
	Vet_DamageIncrease(1)=1.10 //Veteran 
	Vet_DamageIncrease(2)=1.25 //Elite
	Vet_DamageIncrease(3)=1.50 //Heroic

	Vet_SpeedIncrease(0)=1 //Normal (should be 1)
	Vet_SpeedIncrease(1)=1.1 //Veteran 
	Vet_SpeedIncrease(2)=1.25 //Elite
	Vet_SpeedIncrease(3)=1.5 //Heroic 
	
	/***********************/
	}
