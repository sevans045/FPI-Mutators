/*********************************************************
*
* File: Rx_Vehicle_LAV.uc
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
class FPI_Vehicle_LAV extends Rx_Vehicle //_Treaded
    placeable;


var GameSkelCtrl_Recoil    Recoil_L, Recoil_R, Recoil_Rocket_R, Recoil_Rocket_L;

var() AudioComponent FiringAmbient;
var() SoundCue FiringStopSound;


simulated function vector GetEffectLocation(int SeatIndex)
{

    local vector SocketLocation;
   local name FireTriggerTag;

    if ( Seats[SeatIndex].GunSocket.Length <= 0 )
        return Location;

   FireTriggerTag = Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)];

   Mesh.GetSocketWorldLocationAndRotation(FireTriggerTag, SocketLocation);

    return SocketLocation;
}



// special for mammoth
simulated event GetBarrelLocationAndRotation(int SeatIndex, out vector SocketLocation, optional out rotator SocketRotation)
{
    if (Seats[SeatIndex].GunSocket.Length > 0)
    {
        Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)], SocketLocation, SocketRotation);
    }
    else
    {
        SocketLocation = Location;
        SocketRotation = Rotation;
    }
}

simulated function int GetBarrelIndex(int SeatIndex)
{
   local int OldBarrelIndex;
   OldBarrelIndex = super.GetBarrelIndex(SeatIndex);
   if (Weapon == none)
      return OldBarrelIndex;

   return (Weapon.CurrentFireMode == 0 ? OldBarrelIndex % 2 : (OldBarrelIndex % 2) + 2);
}


simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    Super.PostInitAnimTree(SkelComp);



    if (SkelComp == Mesh)
    {
        Recoil_R = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil') );
        Recoil_L = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil') );

        Recoil_Rocket_R = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil_Rocket') );
        Recoil_Rocket_L = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil_Rocket') );
    }
}


simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
   local Name FireTriggerTag;

   Super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

   //`Log("VehicleWeaponFireEffects called",, '_Mammoth_Debug');
   FireTriggerTag = Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)];

   if(Weapon != None) {
       if (Weapon.CurrentFireMode == 0)
       {
           switch(FireTriggerTag)
          {
          case 'CannonFireSocket':
             Recoil_L.bPlayRecoil = TRUE;
             break;
    
          case 'CannonFireSocket2':
             Recoil_R.bPlayRecoil = TRUE;
             break;
          }
       }
       else
       {
          switch(FireTriggerTag)
          {
          case 'MissileSocket1':
             Recoil_Rocket_L.bPlayRecoil = TRUE;
             break;
    
          case 'MissileSocket2':
             Recoil_Rocket_R.bPlayRecoil = TRUE;
             break;
          }
       }
   }
}

	
DefaultProperties
{

    CustomVehicleName = "Light Assault Vehicle"


//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\


    Health=425
    MaxDesireability=0.8
    MomentumMult=0.7
    bCanFlip=False
    bTurnInPlace=false
    bSeparateTurretFocus=True
    CameraLag=0.15 //0.25
	LookForwardDist=200
    GroundSpeed=850
    AirSpeed=550	// 650
    MaxSpeed=1600
    LeftStickDirDeadZone=0.1
    TurnTime=18
     ViewPitchMin=-13000
    HornIndex=1
    COMOffset=(x=0.0,y=0.0,z=-55.0)
    bUsesBullets = true
    bOkAgainstBuildings=false
    bSecondaryFireTogglesFirstPerson=false
	
	CustomGravityScaling=1.0

/************************/
/*Veterancy Multipliers*/
/***********************/

//VP Given on death (by VRank)
	VPReward(0) = 6 
	VPReward(1) = 8 
	VPReward(2) = 10 
	VPReward(3) = 14 
	
	VPCost(0) = 20
	VPCost(1) = 50
	VPCost(2) = 110

Vet_HealthMod(0)=1 //600
Vet_HealthMod(1)=1.083334 //650 
Vet_HealthMod(2)=1.166667 //700
Vet_HealthMod(3)=1.25 //750
	
Vet_SprintSpeedMod(0)=1
Vet_SprintSpeedMod(1)=1.075
Vet_SprintSpeedMod(2)=1.15
Vet_SprintSpeedMod(3)=1.225

/**********************/
	
	
    Begin Object Class=UDKVehicleSimCar Name=SimObject
        WheelSuspensionStiffness=50
        WheelSuspensionDamping=1.5
        WheelSuspensionBias=0
        ChassisTorqueScale=0.5
        MaxBrakeTorque=4.0
        StopThreshold=100

        MaxSteerAngleCurve=(Points=((InVal=0,OutVal=45),(InVal=640.0,OutVal=30.0),(InVal=660.0,OutVal=8.0)))
        SteerSpeed=100

        LSDFactor=0.4

        TorqueVSpeedCurve=(Points=((InVal=-600.0,OutVal=0.0),(InVal=-300.0,OutVal=80.0),(InVal=0.0,OutVal=130.0),(InVal=1200.0,OutVal=10.0)))

        EngineRPMCurve=(Points=((InVal=-500.0,OutVal=3500.0),(InVal=0.0,OutVal=1500.0),(InVal=1000.0,OutVal=6000.0)))

        EngineBrakeFactor=0.1
        ThrottleSpeed=1.2
        WheelInertia=0.2
        NumWheelsForFullSteering=8
        SteeringReductionFactor=0.0
        SteeringReductionMinSpeed=1100.0
        SteeringReductionSpeed=1400.0
        bAutoHandbrake=true
        bClampedFrictionModel=true
        FrontalCollisionGripFactor=0.18
        ConsoleHardTurnGripFactor=1.0
        HardTurnMotorTorque=0.7

        SpeedBasedTurnDamping=20.0
        AirControlTurnTorque=0.0

        // Longitudinal tire model based on 10% slip ratio peak
        WheelLongExtremumSlip=0.1
        WheelLongExtremumValue=1.0
        WheelLongAsymptoteSlip=2.0
        WheelLongAsymptoteValue=0.6

        // Lateral tire model based on slip angle (radians)
           WheelLatExtremumSlip=0.35     // 20 degrees
        WheelLatExtremumValue=0.9
        WheelLatAsymptoteSlip=1.4     // 80 degrees
        WheelLatAsymptoteValue=0.9

        bAutoDrive=false
        AutoDriveSteer=0.3
    End Object
    SimObj=SimObject
    Components.Add(SimObject)




//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RX_VH_LAV.Mesh.LAVtest'
        AnimTreeTemplate=AnimTree'RX_VH_LAV.Anims.AT_VH_LAV'
        PhysicsAsset=PhysicsAsset'RX_VH_LAV.Mesh.LAVtest_Physics'
    End Object
	
	SkeletalMeshForPT=SkeletalMesh'RX_VH_LAV.Mesh.LAVtest'

    DrawScale=1.20

	VehicleIconTexture=Texture2D'RX_VH_LAV.UI.LAVicon'
	MinimapIconTexture=Texture2D'RX_VH_APC_Nod.UI.T_MinimapIcon_APC_Nod'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\


    Seats(0)={(GunClass=class'FPI_Vehicle_LAV_Weapon',
                GunSocket=("CannonFireSocket","CannonFireSocket2","MissileSocket1","MissileSocket2"),
                TurretControls=(TurretPitch,TurretRotate),
				TurretVarPrefix="",
                GunPivotPoints=(MainTurretYaw,MainTurretPitch),
                CameraTag=CamView3P,
				SeatBone=Base,
				SeatSocket=VH_Death,
                CameraBaseOffset=(Z=-30),
                CameraOffset=-350,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
                )}
 
    Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger1",
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=-30),
                CameraOffset=-350,
                )}

    Seats(2)={( GunClass=none,
				TurretVarPrefix="Passenger2",
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=-30),
                CameraOffset=-350,
                )}

    Seats(3)={( GunClass=none,
				TurretVarPrefix="Passenger3",
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=-30),
                CameraOffset=-350,
                )}

				
//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\


//    LeftTeadIndex     = 1
//    RightTreadIndex   = 2

//    BurnOutMaterial[0]=MaterialInstanceConstant'RX_VH_APC_Nod.Materials.MI_VH_APC_Destroyed'
//    BurnOutMaterial[1]=MaterialInstanceConstant'RX_VH_APC_Nod.Materials.MI_VH_Nod_APC_Wheel_Destroyed'

    DrivingPhysicalMaterial=PhysicalMaterial'RX_VH_APC_Nod.Materials.PhysMat_APC_Nod_Driving'
    DefaultPhysicalMaterial=PhysicalMaterial'RX_VH_APC_Nod.Materials.PhysMat_APC_Nod'

    RecoilTriggerTag = "MainGun"
    VehicleEffects(0)=(EffectStartTag="MainGun",EffectEndTag="STOP_MainGun",bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_APC_GDI.Effects.P_MuzzleFlash_50Cal_Looping',EffectSocket="Fire01")
    VehicleEffects(1)=(EffectStartTag="MainGun",EffectEndTag="STOP_MainGun",bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_APC_GDI.Effects.P_ShellCasing_Looping',EffectSocket="ShellCasingSocket")
    VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSmoke01)
	VehicleEffects(3)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire01)
	VehicleEffects(4)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire02)
	VehicleEffects(5)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks01)
	VehicleEffects(6)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks02)

    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_VH_APC_Nod.Effects.P_Explosion_Vehicle')
    BigExplosionSocket=VH_Death
	
	DamageMorphTargets(0)=(InfluenceBone=MT_Front,MorphNodeName=MorphNodeW_Front,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage1))
    DamageMorphTargets(1)=(InfluenceBone=MT_Left,MorphNodeName=MorphNodeW_Left,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage2))
    DamageMorphTargets(2)=(InfluenceBone=MT_Right,MorphNodeName=MorphNodeW_Right,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage3))
    DamageMorphTargets(3)=(InfluenceBone=MT_Rear,MorphNodeName=MorphNodeW_Rear,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage4))

    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=0.1)


//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\


    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'RX_VH_APC_Nod.Sounds.SC_APC_Idle'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);
    
    Begin Object Class=AudioComponent name=FiringAmbientSoundComponent
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        SoundCue=SoundCue'RX_VH_APC_Nod.Sounds.SC_APC_Fire_Loop'
    End Object
    FiringAmbient=FiringAmbientSoundComponent
    Components.Add(FiringAmbientSoundComponent)
    
    FiringStopSound=SoundCue'RX_VH_APC_Nod.Sounds.SC_APC_Fire_Stop'

    EnterVehicleSound=SoundCue'RX_VH_APC_Nod.Sounds.SC_APC_Start'
    ExitVehicleSound=SoundCue'RX_VH_APC_Nod.Sounds.SC_APC_Stop'

    SquealThreshold=0.2
    SquealLatThreshold=0.1
    LatAngleVolumeMult = 30.0
    EngineStartOffsetSecs=2.0
    EngineStopOffsetSecs=1.0
	
	Begin Object Class=AudioComponent Name=ScorpionSquealSound
		SoundCue=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_TireSlide'
	End Object
	SquealSound=ScorpionSquealSound
	Components.Add(ScorpionSquealSound);
	
	Begin Object Class=AudioComponent Name=ScorpionTireSound
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



   Begin Object class=FPI_Vehicle_LAV_Wheel Name=RWheel_01
      BoneName="RT_wheel_01"
      SkelControlName="Wheel_R_01_Cont"
      Side=SIDE_Right
      SteerFactor=0.5
      LongSlipFactor=2.0
      LatSlipFactor=3.0
      HandbrakeLongSlipFactor=2.0
      HandbrakeLatSlipFactor=3.0
   End Object
   Wheels(0)=RWheel_01

   Begin Object class=FPI_Vehicle_LAV_Wheel Name=RWheel_02
      BoneName="RT_wheel_02"
      SkelControlName="Wheel_R_02_Cont"
      Side=SIDE_Right
      SteerFactor=0.5
      LongSlipFactor=2.0
      LatSlipFactor=3.0
      HandbrakeLongSlipFactor=2.0
      HandbrakeLatSlipFactor=3.0
   End Object
   Wheels(1)=RWheel_02

   Begin Object class=FPI_Vehicle_LAV_Wheel Name=RWheel_03
      BoneName="RT_wheel_03"
      SkelControlName="Wheel_R_03_Cont"
      Side=SIDE_Right
	  SteerFactor=-0.5
      LongSlipFactor=2.0
      LatSlipFactor=2.75
      HandbrakeLongSlipFactor=2.0
      HandbrakeLatSlipFactor=1.5
   End Object
   Wheels(2)=RWheel_03

   Begin Object class=FPI_Vehicle_LAV_Wheel Name=RWheel_04
      BoneName="RT_wheel_04"
      SkelControlName="Wheel_R_04_Cont"
      Side=SIDE_Right
	  SteerFactor=-0.5
      LongSlipFactor=2.0
      LatSlipFactor=2.75
      HandbrakeLongSlipFactor=1.0
      HandbrakeLatSlipFactor=0.5
   End Object
   Wheels(3)=RWheel_04

   Begin Object class=FPI_Vehicle_LAV_Wheel Name=LWheel_01
      BoneName="LT_wheel_01"
      SkelControlName="Wheel_L_01_Cont"
      Side=SIDE_Left
      SteerFactor=0.5
      LongSlipFactor=2.0
      LatSlipFactor=3.0
      HandbrakeLongSlipFactor=2.0
      HandbrakeLatSlipFactor=3.0
   End Object
   Wheels(4)=LWheel_01

   Begin Object class=FPI_Vehicle_LAV_Wheel Name=LWheel_02
      BoneName="LT_wheel_02"
      SkelControlName="Wheel_L_02_Cont"
      Side=SIDE_Left
      SteerFactor=0.5
      LongSlipFactor=2.0
      LatSlipFactor=3.0
      HandbrakeLongSlipFactor=2.0
      HandbrakeLatSlipFactor=3.0
   End Object
   Wheels(5)=LWheel_02

   Begin Object class=FPI_Vehicle_LAV_Wheel Name=LWheel_03
      BoneName="LT_wheel_03"
      SkelControlName="Wheel_L_03_Cont"
      Side=SIDE_Left
	  SteerFactor=-0.5
      LongSlipFactor=2.0
      LatSlipFactor=2.75
      HandbrakeLongSlipFactor=2.0
      HandbrakeLatSlipFactor=1.5
   End Object
   Wheels(6)=LWheel_03

   Begin Object class=FPI_Vehicle_LAV_Wheel Name=LWheel_04
      BoneName="LT_wheel_04"
      SkelControlName="Wheel_L_04_Cont"
      Side=SIDE_Left
	  SteerFactor=-0.5
      LongSlipFactor=2.0
      LatSlipFactor=2.75
      HandbrakeLongSlipFactor=1.0
      HandbrakeLatSlipFactor=0.5
   End Object
   Wheels(7)=LWheel_04
}