class FPI_Weapon_CrateNukeSmall extends Rx_Weapon_DeployedNukeBeacon;

var ParticleSystemComponent   ExplosionParticleSecondary;
var LightComponent ExplosionLight;

simulated function PlayNukeMissile()
{
}


simulated function SpawnExplosionEmitter(vector SpawnLocation, rotator SpawnRotation)
{
   local vector loc;
   SpawnRotation.Pitch = 0;
   ExplosionParticle = WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionEffect, SpawnLocation, SpawnRotation);
   ExplosionParticleSecondary = WorldInfo.MyEmitterPool.SpawnEmitter(SecondaryExplosionEffect, SpawnLocation, SpawnRotation);
   ExplosionParticle.SetScale(0.025);
   ExplosionParticleSecondary.SetScale(0.025);
   loc = location;
   loc.z += 1024;
   if(ExplosionLightClass != None)
      ExplosionLight = UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight( ExplosionLightClass, loc);
      //ExplosionLight.SetScale(0.025);
   PlayCamerashakeAnim();
}

DefaultProperties
{
	bBroadcastPlaced = false

	//PartSysTemplate=ParticleSystem'RX_WP_Nuke.Effects.P_Nuke_Falling_Fast'
	NukeParticleLength = 2

   ExplosionLightClass = class'Rx_Light_Tank_MuzzleFlash';

	BeepCue = SoundCue'RX_WP_Nuke.Sounds.Nuke_BeepsCue_Immediate'

   DamageMomentum = 500000.0f
	DmgRadius = 1500.0f
	BuildingDmgRadius = 500.0f
	Damage = 10;

	TimeUntilExplosion = 3;
}
