/*********************************************************
*
* File: Rx_Vehicle_Superhind_Projectile_Heroic.uc
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
class FPI_Vehicle_Superhind_Projectile_Heroic extends FPI_Vehicle_Superhind_Projectile;

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(1.5f);
}

DefaultProperties
{

    AmbientSound=SoundCue'RX_SoundEffects.Missiles.SC_Missile_FlyBy'

    ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.Missile.P_Missile_Heroic' //ParticleSystem'RX_FX_Munitions.Missile.P_Missile_RocketLauncher' 
	// ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.Missile.P_Missile_Rockets'		// ParticleSystem'RX_FX_Munitions.Missile.P_Missile_RocketLauncher'

	
    DrawScale= 1.75f

}
