class FPI_DmgType_NukeGun extends Rx_DmgType_Explosive;

defaultproperties
{
    KillStatsName=KILLS_GRENADELAUNCHER
    DeathStatsName=DEATHS_GRENADELAUNCHER
    SuicideStatsName=SUICIDES_GRENADELAUNCHER

    //DamageWeaponClass=class'Rx_Weapon_GrenadeLauncher'
    DamageWeaponFireMode=0

    VehicleMomentumScaling=0.025
    VehicleDamageScaling=0.36
    NodeDamageScaling=1.1
    bThrowRagdoll=true
    CustomTauntIndex=7
    lightArmorDmgScaling=0.36
    BuildingDamageScaling=0.8
	MCTDamageScaling=1.33 //1.75 //2.5
	MineDamageScaling=2.0
	
	
    AlwaysGibDamageThreshold=99
    bNeverGibs=false
	
	KDamageImpulse=50000
	KDeathUpKick=2000

	IconTextureName="T_DeathIcon_Nuke"
	IconTexture=Texture2D'RX_WP_Nuke.UI.T_DeathIcon_Nuke'
}