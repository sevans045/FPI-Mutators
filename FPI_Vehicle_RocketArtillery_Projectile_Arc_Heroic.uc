/*********************************************************
*
* File: Rx_Vehicle_Artillery_Projectile_Arc.uc
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
class FPI_Vehicle_RocketArtillery_Projectile_Arc_Heroic extends FPI_Vehicle_RocketArtillery_Projectile_Arc;

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(1.5f);
}
 
DefaultProperties
{
	   ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.Missile.P_Missile_Heroic'

}
