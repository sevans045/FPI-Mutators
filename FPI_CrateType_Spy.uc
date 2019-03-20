class FPI_CrateType_Spy extends Rx_CrateType_Spy;

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	RecipientPRI.SetChar(
		(Recipient.GetTeamNum() == TEAM_NOD ?
		class'Rx_PurchaseSystem'.default.GDIInfantryClassesFPI[Rand(14)] : 
		class'Rx_PurchaseSystem'.default.NodInfantryClassesFPI[Rand(14)]),
		Recipient);
	RecipientPRI.SetIsSpy(true);	
}