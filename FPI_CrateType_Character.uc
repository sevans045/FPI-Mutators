class FPI_CrateType_Character extends Rx_CrateType_Character;

function bool HasFreeUnit(Rx_Pawn Recipient)
{
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_GDI_Soldier' || (class'FPI_FamilyInfo_GDI_Soldier'))
		return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_GDI_Shotgunner' || (class'FPI_FamilyInfo_GDI_Shotgunner'))
		return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_GDI_Grenadier' || (class'FPI_FamilyInfo_GDI_Grenadier'))
		return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_GDI_Marksman' || (class'FPI_FamilyInfo_GDI_Marksman'))
		return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_GDI_Engineer' || (class'FPI_FamilyInfo_GDI_Engineer'))
		return true;
		
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_Nod_Soldier' || (class'FPI_FamilyInfo_Nod_Soldier'))
	 	return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_Nod_Shotgunner' || (class'FPI_FamilyInfo_Nod_Shotgunner'))
		return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_Nod_FlameTrooper' || (class'FPI_FamilyInfo_Nod_FlameTrooper'))
		return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_Nod_Marksman' || (class'FPI_FamilyInfo_Nod_Marksman'))
		return true;
	if(Recipient.GetRxFamilyInfo() == (class'Rx_FamilyInfo_Nod_Engineer' || (class'FPI_FamilyInfo_Nod_Engineer'))
		return true;		
		
	return false;	
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	RecipientPRI.SetChar(
		(Recipient.GetTeamNum() == TEAM_GDI ?
		class'Rx_PurchaseSystem'.default.GDIInfantryClassesFPI[RandRange(5,class'Rx_PurchaseSystem'.default.GDIInfantryClassesFPI.Length-1)] : 
		class'Rx_PurchaseSystem'.default.NodInfantryClassesFPI[RandRange(5,class'Rx_PurchaseSystem'.default.NodInfantryClassesFPI.Length-1)]),
		Recipient);
}