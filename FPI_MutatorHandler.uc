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
}

var FPI_ServerTravelMutator ServerTravelMutator;
var FPI_Sys_Mutator SystemMutator;

var config bool bEnableCreditMutator;
var config bool bEnableServerTravelMutator;
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
    MessageAll("Welcome to the Fair Play Inc. RX Server!\nPlease review the rules and have fun.\nDon't forget to vote for a commander!");  

    if (bEnableServerTravelMutator)
        ServerTravelMutator = spawn(class'FPI_ServerTravelMutator');

    if (ServerTravelMutator != None)
    {
        ServerTravelMutator.InitThisMutator();
         `log("[Mutator Handler] Initing Server Travel Mutator");
    }

    SetTimer(90, true, 'CommanderReminder');
}


function OnMatchEnd()
{
    if (ServerTravelMutator != None && ShouldSplit)
        ServerTravelMutator.FPIServerTravel();

    ClearTimer('CommanderReminder');
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
}

function OnBuildingDestroyed(PlayerReplicationInfo Destroyer, Rx_Building_Team_Internals BuildingInternals, Rx_Building Building, class<DamageType> DamageType)
{
    //
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
        MessageTeam(TEAM_GDI, "You have no commander, vote for one.");
    if (!NodHasCommander)
        MessageTeam(TEAM_NOD, "You have no commander, vote for one.");
}

static function string GetCustomWeaponNames(UTWeapon ThisWeapon)
{
  if (ThisWeapon.IsA('FPI_Weapon_ProxyC4'))
    return "Proxy C4";
  if (ThisWeapon.IsA('FPI_Weapon_RepairGunAdvanced'))
    return "Advanced Repair Gun";
  else
    return ThisWeapon.ItemName;
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
            MessageSpecific(Sender, "Commands: split_server, laser, assignuuid", 'Red');
        else if (MutateStringSplit[1] ~= "split_server")
        {
            if (!Sender.PlayerReplicationInfo.bAdmin)
            {
                MessageSpecific(Sender, "You lack authentication for that.", 'Red');
                return;
            }
                ShouldSplit = true;
        }
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
