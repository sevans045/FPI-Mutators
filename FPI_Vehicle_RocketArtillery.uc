/*********************************************************
*
* File: Rx_Vehicle_RocketArtillery.uc
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
class FPI_Vehicle_RocketArtillery extends Rx_Vehicle_Treaded
    placeable;

	
	
function bool TooCloseToAttack(Actor Other)
{
    local float dist;
    
    if(super.TooCloseToAttack(Other)) {
        return true;
    }
    
    dist = VSize(Location - Other.Location);
    return (dist < (700.0 + FRand()*200));
}


DefaultProperties
{

    CustomVehicleName = "Rocket Artillery"


//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\


    Health=400
    bLightArmor=True
    MaxDesireability=0.8
    MomentumMult=0.7
    bCanFlip=False
    bTurnInPlace=false
    bSeparateTurretFocus=True
    CameraLag=0.15
    LookForwardDist=250
    GroundSpeed=400
    MaxSpeed=600
    LeftStickDirDeadZone=0.1
    TurnTime=18
    ViewPitchMin=-13000
    HornIndex=1
    COMOffset=(x=-10.0,y=0.0,z=-60.0)
    bSecondaryFireTogglesFirstPerson=false
	SpeedAtWhichToApplyReducedTurningThrottle=220
	
	SprintTrackTorqueFactorDivident=0.975
	
/************************/
/*Veterancy Multipliers*/
/***********************/

//VP Given on death (by VRank)
	VPReward(0) = 5 
	VPReward(1) = 7 
	VPReward(2) = 9 
	VPReward(3) = 12 
	
	VPCost(0) = 20
	VPCost(1) = 50
	VPCost(2) = 110

Vet_HealthMod(0)=1.0 //400
Vet_HealthMod(1)=1.125 //450 
Vet_HealthMod(2)=1.25 //500
Vet_HealthMod(3)=1.375 //550 
	
Vet_SprintSpeedMod(0)=1
Vet_SprintSpeedMod(1)=1
Vet_SprintSpeedMod(2)=1.05
Vet_SprintSpeedMod(3)=1.10
	
// +X as opposed to *X
Vet_SprintTTFD(0)=0
Vet_SprintTTFD(1)=0
Vet_SprintTTFD(2)=0.05
Vet_SprintTTFD(3)=0.1

	BarrelLength(0)=450
	BarrelLength(1)=400
	BarrelLength(2)=100
	BarrelLength(3)=100
	BarrelLength(4)=100
	BarrelLength(5)=100

/**********************/

Heroic_MuzzleFlash=ParticleSystem'RX_VH_MediumTank.Effects.MuzzleFlash_Heroic'

    Begin Object Class=SVehicleSimTank Name=SimObject

        bClampedFrictionModel=true

        WheelSuspensionStiffness=100
        WheelSuspensionDamping=2.0
        WheelSuspensionBias=0

//        WheelLongExtremumSlip=0
//        WheelLongExtremumValue=20
//        WheelLatExtremumValue=4

        // Longitudinal tire model based on 10% slip ratio peak
        WheelLongExtremumSlip=0.5
        WheelLongExtremumValue=2.0
        WheelLongAsymptoteSlip=2.0
        WheelLongAsymptoteValue=0.6

        // Lateral tire model based on slip angle (radians)
           WheelLatExtremumSlip=0.5 //0.35     // 20 degrees
        WheelLatExtremumValue=4.0
        WheelLatAsymptoteSlip=1.4     // 80 degrees
        WheelLatAsymptoteValue=2.0

        ChassisTorqueScale=0.0
        StopThreshold=20
        EngineDamping=3
        InsideTrackTorqueFactor=0.35
        TurnInPlaceThrottle=0.3
        TurnMaxGripReduction=0.995
        TurnGripScaleRate=0.8
        MaxEngineTorque=2400
        End Object
    SimObj=SimObject
    Components.Add(SimObject)


//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RX_VH_RocketArtillery.Mesh.RocketArtillery'
        AnimTreeTemplate=AnimTree'RX_VH_RocketArtillery.Anims.AT_VH_RocketArtillery'
        PhysicsAsset=PhysicsAsset'RX_VH_RocketArtillery.Mesh.RocketArtillery_Physics'
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'RX_VH_RocketArtillery.Mesh.RocketArtillery'

	VehicleIconTexture=Texture2D'RX_VH_RocketArtillery.UI.artilleryrocketicon'
	MinimapIconTexture=Texture2D'RX_VH_Artillery.UI.T_MinimapIcon_Artillery'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\


    Seats(0)={(GunClass=class'FPI_Vehicle_RocketArtillery_Weapon',
                GunSocket=(MissileSocket1,MissileSocket2,MissileSocket3,MissileSocket4,MissileSocket5,MissileSocket6,MissileSocket7,MissileSocket8,MissileSocket9,MissileSocket10,MissileSocket11,MissileSocket12,MissileSocket13,MissileSocket14,MissileSocket15,MissileSocket16,MissileSocket17,MissileSocket18,MissileSocket19,MissileSocket20,MissileSocket21,MissileSocket22,MissileSocket23,MissileSocket24,MissileSocket25,MissileSocket26,MissileSocket27,MissileSocket28,MissileSocket29,MissileSocket30,MissileSocket31,MissileSocket32,MissileSocket33,MissileSocket34,MissileSocket35,MissileSocket36,MissileSocket37,MissileSocket38,MissileSocket39,MissileSocket40),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(MainTurretYaw,MainTurretPitch),
                CameraTag=CamView3P,
				SeatBone=Base,
				SeatSocket=VH_Death,
                CameraBaseOffset=(Z=-10),
                CameraOffset=-600,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'Rx_Light_Tank_MuzzleFlash'
                )}
                
    Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger",
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=-10),
                CameraOffset=-600,
                )}


//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\


//    LeftTeadIndex     = 1
//    RightTreadIndex   = 2

    BurnOutMaterial[0]=MaterialInstanceConstant'RX_VH_Artillery.Materials.MI_VH_Artillery_Destroyed'
    BurnOutMaterial[1]=MaterialInstanceConstant'RX_VH_Artillery.Materials.MI_VH_Artillery_Destroyed'

    DrivingPhysicalMaterial=PhysicalMaterial'RX_VH_RocketArtillery.Materials.PhysMat_RocketArty_Driving'
    DefaultPhysicalMaterial=PhysicalMaterial'RX_VH_RocketArtillery.Materials.PhysMat_RocketArty'

    RecoilTriggerTag = "MainGun"
    VehicleEffects(0)=(EffectStartTag="MainGun",EffectTemplate=ParticleSystem'RX_VH_Artillery.Effects.P_MuzzleFlash',EffectSocket="Fire01")
    VehicleEffects(1)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSmoke01)
    VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSmoke02)
    VehicleEffects(3)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks01)
    VehicleEffects(4)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks02)
    VehicleEffects(5)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Tracks',EffectSocket=DamageTSparks01)
    VehicleEffects(6)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Tracks',EffectSocket=DamageTSparks02)
    VehicleEffects(7)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire01)
    VehicleEffects(8)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire02)

	WheelParticleEffects[0]=(MaterialType=Generic,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
    WheelParticleEffects[1]=(MaterialType=Dirt,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt_Small')
	WheelParticleEffects[2]=(MaterialType=Grass,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt_Small')
    WheelParticleEffects[3]=(MaterialType=Water,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Water')
    WheelParticleEffects[4]=(MaterialType=Snow,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Snow_Small')
	WheelParticleEffects[5]=(MaterialType=Concrete,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
	WheelParticleEffects[6]=(MaterialType=Metal,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
	WheelParticleEffects[7]=(MaterialType=Stone,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Stone')
	WheelParticleEffects[8]=(MaterialType=WhiteSand,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_WhiteSand_Small')
	WheelParticleEffects[9]=(MaterialType=YellowSand,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_YellowSand_Small')
	DefaultWheelPSCTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt_Small'	
	
    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Vehicle_Huge')
    BigExplosionSocket=VH_Death
	
	DamageMorphTargets(0)=(InfluenceBone=MT_Ch_F,MorphNodeName=MorphNodeW_Ch_F,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage1))
    DamageMorphTargets(1)=(InfluenceBone=MT_Ch_L,MorphNodeName=MorphNodeW_Ch_L,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage3))
    DamageMorphTargets(2)=(InfluenceBone=MT_Ch_R,MorphNodeName=MorphNodeW_Ch_R,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage4))
    DamageMorphTargets(3)=(InfluenceBone=MT_Ch_B,MorphNodeName=MorphNodeW_Ch_B,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage2))
    DamageMorphTargets(4)=(InfluenceBone=MT_Tu_L,MorphNodeName=MorphNodeW_Tu_L,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage3))
    DamageMorphTargets(5)=(InfluenceBone=MT_Tu_R,MorphNodeName=MorphNodeW_Tu_R,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage1))
    DamageMorphTargets(6)=(InfluenceBone=MT_Tu_B,MorphNodeName=MorphNodeW_Tu_B,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage2))

    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=0.1)

//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\


    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'RX_VH_Artillery.Sounds.Arty_IdleCue'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);

    EnterVehicleSound=SoundCue'RX_VH_Artillery.Sounds.Arty_startCue'
    ExitVehicleSound=SoundCue'RX_VH_Artillery.Sounds.Arty_StopCue'
	
	ExplosionSound=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_Explode_Large'
	
	Begin Object Class=AudioComponent Name=ScorpionSquealSound
		SoundCue=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_TireSlide'
	End Object
	SquealSound=ScorpionSquealSound
	Components.Add(ScorpionSquealSound);
	
	Begin Object Name=ScorpionTireSound
		SoundCue=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireDirt'
	End Object
	TireAudioComp=ScorpionTireSound
	Components.Add(ScorpionTireSound);
	
	TireSoundList(0)=(MaterialType=Dirt,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireDirt')
	TireSoundList(1)=(MaterialType=Foliage,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireFoliage')
	TireSoundList(2)=(MaterialType=Grass,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireGrass')
	TireSoundList(3)=(MaterialType=Metal,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireMetal')
	TireSoundList(4)=(MaterialType=Mud,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireMud')
	TireSoundList(5)=(MaterialType=Snow,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireSnow')
	TireSoundList(6)=(MaterialType=Stone,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireStone')
	TireSoundList(7)=(MaterialType=Water,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireWater')
	TireSoundList(8)=(MaterialType=Wood,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireWood')
    

//========================================================\\
//******** Vehicle Wheels & Suspension Properties ********\\
//========================================================\\

   
   Begin Object class=FPI_Vehicle_RocketArtillery_Wheel Name=RRWheel_01
      BoneName="Wheel_RT_2"
      SkelControlName="Rt_Rear_01_Control"
      Side=SIDE_Right
   End Object
   Wheels(0)=RRWheel_01

   Begin Object class=FPI_Vehicle_RocketArtillery_Wheel Name=LRWheel_01
      BoneName="Wheel_LT_2"
      SkelControlName="Lt_Rear_01_Control"
      Side=SIDE_Left
   End Object
   Wheels(1)=LRWheel_01

   Begin Object class=FPI_Vehicle_RocketArtillery_Wheel Name=RRWheel_02
      BoneName="Wheel_RT_3"
      SkelControlName="Rt_Rear_02_Control"
      Side=SIDE_Right
   End Object
   Wheels(2)=RRWheel_02

   Begin Object class=FPI_Vehicle_RocketArtillery_Wheel Name=LRWheel_02
      BoneName="Wheel_RT_3"
      SkelControlName="Lt_Rear_02_Control"
      Side=SIDE_Left
   End Object
   Wheels(3)=LRWheel_02

   Begin Object class=FPI_Vehicle_RocketArtillery_Wheel Name=RFWheel_01
      BoneName="Wheel_RT_1"
      SkelControlName="Rt_Front_Control"
      Side=SIDE_Right
   End Object
   Wheels(4)=RFWheel_01

   Begin Object class=FPI_Vehicle_RocketArtillery_Wheel Name=LFWheel_01
      BoneName="Wheel_LT_1"
      SkelControlName="Lt_Front_Control"
      Side=SIDE_Left
   End Object
   Wheels(5)=LFWheel_01

}