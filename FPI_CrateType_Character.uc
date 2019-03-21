class FPI_CrateType_Character extends Rx_CrateType_Character;

function bool HasFreeUnit(Rx_Pawn Recipient)
{
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Soldier' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_GDI_Soldier')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Shotgunner' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_GDI_Shotgunner')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Grenadier' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_GDI_Grenadier')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Marksman' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_GDI_Marksman')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Engineer' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_GDI_Engineer')
		return true;
		
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Soldier' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_Nod_Soldier')
	 	return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Shotgunner' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_Nod_Shotgunner')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_FlameTrooper' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_Nod_FlameTrooper')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Marksman' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_Nod_Marksman')
		return true;
	if(Recipient.GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Engineer' || Recipient.GetRxFamilyInfo() == class'FPI_FamilyInfo_Nod_Engineer')
		return true;		
		
	return false;	
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	RecipientPRI.SetChar(
		(Recipient.GetTeamNum() == TEAM_GDI ?
		class'FPI_PurchaseSystem'.default.GDIInfantryClassesFPI[RandRange(5,class'FPI_PurchaseSystem'.default.GDIInfantryClassesFPI.Length-1)] : 
		class'FPI_PurchaseSystem'.default.NodInfantryClassesFPI[RandRange(5,class'FPI_PurchaseSystem'.default.NodInfantryClassesFPI.Length-1)]),
		Recipient);
}