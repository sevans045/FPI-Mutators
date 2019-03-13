class FPI_DmgType_RocketArtillery extends Rx_DmgType_Shell;

defaultproperties
{
    KillStatsName=KILLS_ROCKETARTILLERY
    DeathStatsName=DEATHS_ROCKETARTILLERY
    SuicideStatsName=SUICIDES_ROCKETARTILLERY

    ////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 1.1   //FLAK infantry armour (Standard rule is explosive weapons does  30% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 1.0	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties)
	Inf_LazarusDamageScaling = 1.1  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	
	VehicleDamageScaling=0.84
	lightArmorDmgScaling=0.84
    BuildingDamageScaling=0.84f
	
	IconTextureName="artilleryrocketicon"
	IconTexture=Texture2D'RX_VH_RocketArtillery.UI.artilleryrocketicon'
}