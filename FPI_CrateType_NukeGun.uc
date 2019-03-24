/*
 * YOU ARE NOT UNDER ANY CIRCUMSTANCES ALLOWED TO REDISTRUBUTE OR USE THE SOURCE CODE IN ANY NON-AGN SERVER WITHOUT THE WRITTEN PERMISSION BY THE OWNER.
 *
 * THE FILES CONTAINED WITHIN ARE COPYRIGHT VIRTUAL PRIVATE SERVER SOLUTIONS LTD (https://beta.companieshouse.gov.uk/company/10750173).
 *
 * IF YOU WISH TO USE THESE FILES, INCLUDING ANY OF IT'S CONTENT FOR YOUR OWN WORK, ONCE AGAIN YOU WILL HAVE TO HAVE WRITTEN PERMISSION FROM THE CONTENT OWNER https://www.vps-solutions.co.uk
 *
 * BY BROWSING THIS CONTENT YOU HEREBY AGREE TO THE VPS-SOLUTIONS TERMS OF SERVICE (https://www.vps-solutions.co.uk/terms-of-service.php)
 */

 //Permission given here: https://github.com/AlienXAXS/AGN-Server-Mutators/blob/master/README.md


//This has some bugs to work out still, so we don't need to use it for now.

class FPI_CrateType_NukeGun extends FPI_CrateType
    transient;

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
    return ((((((("GAME" $ Chr(2)) $ "Crate;") $ Chr(2)) $ "`weapon`") $ Chr(2)) $ "by") $ Chr(2)) $ class'Rx_Game'.static.GetPRILogName(RecipientPRI);
}

function string GetPickupMessage()
{
    return "You got a Nuke Gun!";
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
    local Rx_InventoryManager InvManager;
	local class<Rx_Weapon> WeaponClass;

    WeaponClass = class'FPI_Weapon_NukeGun';
    InvManager = Rx_InventoryManager(Recipient.InvManager);
    InvManager.PrimaryWeapons.AddItem(WeaponClass);
    if(InvManager.FindInventoryType(WeaponClass) != none)
    {
        InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.FindInventoryType(WeaponClass)));
    }
    else
    {
        InvManager.SetCurrentWeapon(Rx_Weapon(InvManager.CreateInventory(WeaponClass, false)));
    }
}

defaultproperties
{
    BroadcastMessageIndex=9
    PickupSound=SoundCue'Rx_Pickups.Sounds.SC_Pickup_Ammo'
}