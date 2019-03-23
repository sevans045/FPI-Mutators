class FPI_DmgType_RocketArtillery extends Rx_DmgType_Shell;

defaultproperties
{
    KillStatsName=KILLS_ROCKETARTILLERY
    DeathStatsName=DEATHS_ROCKETARTILLERY
    SuicideStatsName=SUICIDES_ROCKETARTILLERY

    ////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 1.6   //FLAK infantry armour (Standard rule is explosive weapons does  30% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 1.9	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties)
	Inf_LazarusDamageScaling = 1.9  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	
	VehicleDamageScaling=0.95
	lightArmorDmgScaling=0.95
    BuildingDamageScaling=0.95f
	
	IconTextureName="artilleryrocketicon"
	IconTexture=Texture2D'RX_VH_RocketArtillery.UI.artilleryrocketicon'
}