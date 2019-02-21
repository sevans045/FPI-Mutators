/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_AccessControl extends Rx_AccessControl
config(RenegadeX);

var config string ModPassword;

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string OutError, bool bSpectator)
{
	if (bRequireSteam && OnlineSub.UniqueNetIdToString(UniqueId) == `BlankSteamID)
		OutError = "Engine.Errors.SteamClientRequired";
	else
		super.PreLogin(Options, Address, UniqueId, bSupportsAuth, OutError, bSpectator);
}

/** Temporary "Moderator". Admin without access to the Admin command. */
function bool AdminLogin( PlayerController P, string Password )
{
	local string SteamID;

	// Can't login if already logged in.
	if ( P.PlayerReplicationInfo.bAdmin )
		return false;

	SteamID = OnlineSub.UniqueNetIdToString(P.PlayerReplicationInfo.UniqueId);

	// Try logging in as Admin first.
	if ( super.AdminLogin(P, Password) )
	{
		if (bSteamAuthAdmins && !IsAdminSteamID(SteamID))
			P.PlayerReplicationInfo.bAdmin = false;
		else
			return true;
	}

	// If failure, try logging in as Moderator.
	if (ModPassword == "")
		return false;
	if (Password == ModPassword)
	{
		if (bSteamAuthAdmins && !IsModSteamID(SteamID) && !IsAdminSteamID(SteamID) )
			return false;
		P.PlayerReplicationInfo.bAdmin = true;
		Rx_PRI(P.PlayerReplicationInfo).bModeratorOnly = true;
		return true;
	}
	return false;
}

function bool IsAdminSteamID(String ID)
{
	local int i;
	for (i=0; i<AdministratorSteamIDs.Length; ++i)
		if (ID == AdministratorSteamIDs[i])
			return true;
	return false;
}

function bool IsModSteamID(String ID)
{
	local int i;
	for (i=0; i<ModeratorSteamIDs.Length; ++i)
		if (ID == ModeratorSteamIDs[i])
			return true;
	return false;
}

function bool AdminLogout(PlayerController P)
{
	if (super.AdminLogout(P))
	{
		if (Rx_PRI(P.PlayerReplicationInfo).bModeratorOnly)
			Rx_PRI(P.PlayerReplicationInfo).bModeratorOnly = false;
		return true;
	}
	return false;
}

function ModEntered( PlayerController P )
{
	local string LoginString;

	`LogRx("ADMIN"`s "Login;" `s `PlayerLog(P.PlayerReplicationinfo)`s"as"`s"moderator");

	if (!bBroadcastAdminIdentity)
	{
		//P.ClientMessage("Logged in as server moderator.");
		Rx_Controller(P).CTextMessage("[FPI] Authenticated as moderator.",'LightGreen',120);
		return;
	}

	LoginString = P.PlayerReplicationInfo.PlayerName@"logged in as a server moderator.";

	`log(LoginString);
	WorldInfo.Game.Broadcast( P, LoginString );
}
function ModExited( PlayerController P )
{
	local string LogoutString;

	`LogRx("ADMIN"`s "Logout;" `s `PlayerLog(P.PlayerReplicationinfo)`s "as"`s "moderator");

	if (!bBroadcastAdminIdentity)
	{
		//P.ClientMessage("No longer logged in as a server moderator.");
		Rx_Controller(P).CTextMessage("[FPI] Authentication as moderator revoked.",'Red',120);
		return;
	}

	LogoutString = P.PlayerReplicationInfo.PlayerName$"is no longer logged in as a server moderator.";

	`log(LogoutString);
	WorldInfo.Game.Broadcast( P, LogoutString );
}

function AdminEntered( PlayerController P )
{
	`LogRx("ADMIN"`s "Login;" `s `PlayerLog(P.PlayerReplicationinfo)`s "as"`s "administrator");
	if (!bBroadcastAdminIdentity)
	{
		//P.ClientMessage("[FPI] Logged in as a server administrator.");
		Rx_Controller(P).CTextMessage("[FPI] Authenticated as administrator.",'LightGreen',120);
		return;
	}
	super.AdminEntered(P);
}

function AdminExited( PlayerController P )
{
	`LogRx("ADMIN"`s "Logout;" `s `PlayerLog(P.PlayerReplicationinfo)`s "as"`s "administrator");
	if (!bBroadcastAdminIdentity)
	{
		//P.ClientMessage("No longer logged in as a server administrator.");
		Rx_Controller(P).CTextMessage("[FPI] Authentication as administrator revoked.",'Red',120);
		return;
	}
	super.AdminExited(P);
}

function AddAdmin( PlayerController Caller, PlayerReplicationInfo NewAdmin, bool AsModerator )
{
	local string SteamID;
	local int i;

	SteamID = OnlineSub.UniqueNetIdToString(NewAdmin.UniqueId);

	if (SteamID == `BlankSteamID)
	{
		Caller.ClientMessage(NewAdmin.Name@"is not using Steam.");
		return;
	}

	if (IsAdminSteamID(SteamID))
	{
		Caller.ClientMessage(NewAdmin.Name@"is already an Administrator.");
		return;
	}

	if (AsModerator)
	{
		if (IsModSteamID(SteamID))
		{
			Caller.ClientMessage(NewAdmin.Name@"is already a Moderator.");
			return;
		}

		ModeratorSteamIDs[ModeratorSteamIDs.Length] = SteamID;
		SaveConfig();
		`LogRx("ADMIN"`s "Granted;"`s `PlayerLog(NewAdmin)`s "as"`s "moderator");
		Caller.ClientMessage(NewAdmin.Name@" successfully added as a Moderator.");
	}
	else
	{
		AdministratorSteamIDs[AdministratorSteamIDs.Length] = SteamID;

		for (i=0; i<ModeratorSteamIDs.Length; ++i)
		{
			if (ModeratorSteamIDs[i] == SteamID)
			{
				ModeratorSteamIDs.Remove(i,1);
				break;
			}
		}
		SaveConfig();
		`LogRx("ADMIN"`s "Granted;"`s `PlayerLog(NewAdmin)`s "as"`s "administrator");
		Caller.ClientMessage(NewAdmin.Name@" successfully added as an Administrator.");
	}
}

DefaultProperties
{
}
