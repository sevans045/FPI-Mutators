/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_MutatorHandler extends Rx_Mutator
config(FPI);

enum Team
{
    TEAM_GDI,
    TEAM_NOD,
    TEAM_UNOWNED
};

var FPI_Sys_Mutator SystemMutator;

var config bool bEnableCreditMutator;
var config string ServerMutatorVersion;

/** List of SteamIDs authorised for Administator. */
var config array<string> AdministratorSteamIDs;

/** List of SteamIDs authorised for Moderator. */
var config array<string> ModeratorSteamIDs;

function PostBeginPlay()
{
    local int i;

    For (i=0; i<AdministratorSteamIDs.Length; ++i)
        AdministratorSteamIDs[i] = class'FPI_AccessControl'.static.FixSteamID(AdministratorSteamIDs[i]);
    For (i=0; i<ModeratorSteamIDs.Length; ++i)
        ModeratorSteamIDs[i] = class'FPI_AccessControl'.static.FixSteamID(ModeratorSteamIDs[i]);

    SaveConfig();
}

function bool CheckReplacement(Actor Other)
{
    local FPI_CratePickup ReplacementCrate;
	local Rx_CratePickup OldCrate;

    if(Rx_TeamInfo(Other) != None)
    {
        Rx_Game(WorldInfo.Game).PlayerControllerClass = class'FPI_Controller';
        Rx_Game(WorldInfo.Game).HudClass = class'FPI_HUD';
        Rx_Game(WorldInfo.Game).PlayerReplicationInfoClass = class'FPI_PRI';
        Rx_Game(WorldInfo.Game).AccessControlClass = class'FPI_AccessControl';
        Rx_Game(WorldInfo.Game).PurchaseSystemClass = class'FPI_PurchaseSystem';
        Rx_Game(WorldInfo.Game).DefaultPawnClass = class'FPI_Pawn';
    }

    if (Other.IsA('Rx_InventoryManager_GDI_Hotwire'))
	{
		Rx_InventoryManager_GDI_Hotwire(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
        Rx_InventoryManager_GDI_Hotwire(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
        Rx_InventoryManager_GDI_Hotwire(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced';
    } 
    else if (Other.IsA('Rx_InventoryManager_Nod_Technician'))
	{
		Rx_InventoryManager_Nod_Technician(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
        Rx_InventoryManager_Nod_Technician(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
        Rx_InventoryManager_Nod_Technician(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced';
    }
    else if (Other.IsA('Rx_InventoryManager_GDI_Engineer'))
    {
        Rx_InventoryManager_GDI_Engineer(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGun';
    }
    else if (Other.IsA('Rx_InventoryManager_Nod_Engineer'))
    {
        Rx_InventoryManager_Nod_Engineer(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGun';
    }
    else if ((Rx_CratePickup(Other) != none) && (FPI_CratePickup(Other) == none)) //Blame HIHIHI if it breaks.
	{
		OldCrate = Rx_CratePickup(Other);
		ReplacementCrate = FPI_CratePickup(ReplaceAndReturnReplaced(Other, "FPI.FPI_CratePickup"));

		ReplacementCrate.bNoVehicleSpawn = OldCrate.bNoVehicleSpawn;
		ReplacementCrate.bNoNukeDeath = OldCrate.bNoNukeDeath;
		
        return false;
	}
    return true;
}

function InitMutator(string Options, out string ErrorMessage)
{
    SystemMutator = spawn(class'FPI_Sys_Mutator');

    if (SystemMutator != None)
        SystemMutator.InitThisMutator();
}

simulated function Tick(float DeltaTime) // Tick for our Admin HUD
{
    if (SystemMutator != None)
        SystemMutator.OnTick(DeltaTime);
}

/***************** Mutator Hooks *****************/

function OnMatchStart()
{  
    MessageAll("Welcome to the Fair Play Inc. server!\nPlease review the rules and have fun.\nDon't forget to vote for a commander!");
    SetTimer(90, true, 'CommanderReminder');
    //SetTimer(900, true, 'Broadcast'); //Goku says this is annoying. Happens now on "!about" in chat and at end of match.
}

function OnMatchEnd()
{
    ClearTimer('CommanderReminder');
    SetTimer(3, false, 'Broadcast');
}

function OnPlayerConnect(PlayerController NewPlayer,  string SteamID)
{
    FPI_Controller(NewPlayer).ReportVersion();
    FPI_Controller(NewPlayer).TimerLoop();

    if (Len(SteamID) > 1)
    {
        if(IsAdminSteamID(SteamID))
            NewPlayer.PlayerReplicationInfo.bAdmin = true;
        if(IsModSteamID(SteamID))
            FPI_PRI(NewPlayer.PlayerReplicationInfo).bModeratorOnly = true;
    }

    //`WorldInfoObject.Game.BroadcastHandler.Broadcast(None, NewPlayer.GetHumanReadableName()@"joined the game", 'Say'); //Goku says this is annoying.
}

function OnPlayerDisconnect(Controller PlayerLeaving)
{
    //`WorldInfoObject.Game.BroadcastHandler.Broadcast(None, PlayerLeaving.GetHumanReadableName()@"left the game", 'Say'); //Goku says this is annoying.
}

function OnBuildingDestroyed(PlayerReplicationInfo Destroyer, Rx_Building_Team_Internals BuildingInternals, Rx_Building Building, class<DamageType> DamageType)
{

}

/***************** Custom Functions *****************/

function bool IsAdminSteamID(String ID)
{
    local int i;
    For (i=0; i<AdministratorSteamIDs.Length; i++)
        if (ID == AdministratorSteamIDs[i])
            return true;
        else return false;
}

function bool IsModSteamID(String ID)
{
    local int i;
    For (i=0; i<ModeratorSteamIDs.Length; i++)
        if (ID == ModeratorSteamIDs[i])
            return true;
        else return false;
}

static function MessageAll(string message)
{
    local FPI_Controller c;
    ForEach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'FPI_Controller', c)
    {
        if (c != None)
            if (Rx_PRI(c.PlayerReplicationInfo) != None)
                c.CTextMessage(message, 'Green', 120);
    }
}

static function MessageAdmins(string message, optional name MsgColor = 'Green')
{
    local FPI_Controller c;
    
    ForEach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'FPI_Controller', c)
    {
        if (c != None)
            if (c.PlayerReplicationInfo != None && FPI_PRI(c.PlayerReplicationInfo).bAdmin)
                c.CTextMessage("[FPI Admin]"@message, MsgColor, 120);
    }
}

static function MessageSpecific(PlayerController receiver, string message, optional name MsgColor = 'Green')
{
    if (receiver != None)
        if (Rx_Controller(receiver) != none && Rx_PRI(Rx_Controller(receiver).PlayerReplicationInfo) != None)
            Rx_Controller(receiver).CTextMessage("[FPI]"@message, MsgColor, 120);
}

static function MessageTeam(int TeamID, string message)
{
    local FPI_Controller c;
    ForEach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'FPI_Controller', c)
    {
        if (c != None && c.GetTeamNum() == TeamID)
            c.CTextMessage("[FPI]"@message, 'Red', 300.0, 1.5);
    }
}

function CommanderReminder()
{
    local FPI_Controller c;
    local bool NodHasCommander, GDIHasCommander;
    
    ForEach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'FPI_Controller', c)
    {
        if (c != none && Rx_PRI(c.PlayerReplicationInfo) != None && Rx_PRI(c.PlayerReplicationInfo).bGetIsCommander())
        {
            if (c.GetTeamNum() == TEAM_GDI)
                GDIHasCommander = true;
            else if (c.GetTeamNum() == TEAM_NOD)
                NodHasCommander = true;
        }
    }

    if (!GDIHasCommander)
        MessageTeam(TEAM_GDI, "You have no commander, vote for one");
    if (!NodHasCommander)
        MessageTeam(TEAM_NOD, "You have no commander, vote for one");
}


function Broadcast() //Reactivated - occurs at end of match. The same message also appears on "!about" in chat or teamchat
{
    `WorldInfoObject.Game.Broadcast(None, "This server is running the FPI mutator package, created by Sarah", 'Say');
}


function actor ReplaceAndReturnReplaced(actor Other, string aClassName) //Blame HIHIHI if it breaks.
{
	local Actor A;
	local class<Actor> aClass;
	local PickupFactory OldFactory, NewFactory;

	if(aClassName == "")
	{
		return none;
	}


	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
	{
		A = Spawn(aClass,Other.Owner,,Other.Location, Other.Rotation);
		if (A != None)
		{
			OldFactory = PickupFactory(Other);
			NewFactory = PickupFactory(A);
			if (OldFactory != None && NewFactory != None)
			{
				OldFactory.ReplacementFactory = NewFactory;
				NewFactory.OriginalFactory = OldFactory;
			}
		}
	}
	return A;
}

/***************** Commands *****************/

function Mutate(String MutateString, PlayerController Sender)
{
  local Rx_PRI PlayerPRI;
  local string errorMessage;
  local array<string> MutateStringSplit;
  local string str;

    MutateStringSplit = SplitString ( MutateString, " ", true);
    if (MutateStringSplit.Length == 0) return;

    `log("[FPI Admin] Command executed: " $ MutateString $ " from " $ Sender.PlayerReplicationInfo.GetHumanReadableName() $ ".");

    if (MutateStringSplit.Length == 1 && MutateStringSplit[0] ~= "fpi")
    {
        MessageSpecific(Sender, "- Use 'fpi help' for help.", 'Red');
        return;
    }

    if (MutateStringSplit.Length > 1 && MutateStringSplit[0] ~= "fpi")
    {
        /*
         * [0] = fpi
         * [1] = cmd
         * (2) = params (optional, depends on cmd)
         */

        if (MutateStringSplit[1] ~= "help")
            MessageSpecific(Sender, "Commands: assignuuid", 'Red');
        else if (MutateStringSplit[1] ~= "assignuuid")
        {
            if (!Sender.PlayerReplicationInfo.bAdmin)
            {
                MessageSpecific(Sender, "You lack authentication for that.", 'Red');
                return;
            }

            if(MutateStringSplit.Length < 3)
                return;

            PlayerPRI = Rx_Game(`WorldInfoObject.Game).ParsePlayer(MutateStringSplit[2], errorMessage);
                if (PlayerPRI == None)
                {
                    Sender.ClientMessage(errorMessage);
                    return;
                }
            FPI_Controller(PlayerPRI.Owner).WriteMutatorVersion(MutateStringSplit[3]);
            MessageSpecific(Sender, "Successfully set"@PlayerPRI.GetHumanReadableName()$"'s UUID to"@MutateStringSplit[3]);

        }
        else if (MutateStringSplit[1] ~= "report")
        {
            if(MutateStringSplit[2] == ""){
                FPI_Controller(Sender).WriteMutatorVersion(ServerMutatorVersion);

                `log("Blank version found, assigning"@ServerMutatorVersion@"to"@Sender.PlayerReplicationInfo.GetHumanReadableName());
            } else if (MutateStringSplit[2] != ServerMutatorVersion)
            {
                str = "[FPIAlert] " $ MutateStringSplit[2];

                `LogRx("CHAT"`s "TeamSay;"`s `PlayerLog(Sender.PlayerReplicationInfo)`s "said:"`s str);
            }
        } else if (MutateStringSplit[1] ~= "time" && MutateStringSplit[2] != "")
            {
                str = "Client time"@MutateStringSplit[2]@"Server time"@WorldInfo.GRI.ElapsedTime;

                `LogRx("CHAT"`s "TeamSay;"`s `PlayerLog(Sender.PlayerReplicationInfo)`s "said:"`s str);
            }
        else
            MessageSpecific(Sender, "Unknown command", 'Red');
    }
}

DefaultProperties
{
}
