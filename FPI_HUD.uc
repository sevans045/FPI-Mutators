/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

 class FPI_HUD extends Rx_HUD;

var int DefaultTargettingRangex;
var FPI_HUD_AdminComponent AdminHud;

//Create and initialize hud components
function CreateHudCompoenents()
{
	TargetingBox = New TargetingBoxClass;
	PlayerNames = New PlayerNamesClass;
	CaptureProgress = New CaptureProgressClass;
	CommandText = New CommandTextClass;
	AdminHud = New class'FPI_HUD_AdminComponent';
	//Visuals for objective oriented stuff
	//C_Visuals = New C_VisualsClass;
	//Rx_Controller(PlayerOwner).Hudvisuals = C_Visuals; 
}

function UpdateHudCompoenents(float DeltaTime, Rx_HUD HUD)
{
	if(DrawTargetBox)	TargetingBox.Update(DeltaTime,HUD);  // Targetting box isn't fully seperated from this class yet so we can't update it here.
	if(DrawPlayerNames)	PlayerNames.Update(DeltaTime,HUD);
	if(DrawCaptureProgress) CaptureProgress.Update(DeltaTime,HUD);
	if(DrawCText)	CommandText.Update(DeltaTime,HUD);
	if(DrawTargetBox) AdminHud.Update(DeltaTime,HUD);
	//if(DrawC_Visuals)	C_Visuals.Update(DeltaTime,HUD);
	if(Rx_Controller(PlayerOwner).Vet_Menu != none) Rx_Controller(PlayerOwner).Vet_Menu.UpdateTiles(DeltaTime, HUD);
}

function DrawHudCompoenents()
{
if(DrawTargetBox)	TargetingBox.Draw(); // Targeting box isn't fully separated from this class yet so we can't draw it here.
if(DrawPlayerNames)	PlayerNames.Draw();
if(DrawCaptureProgress)	CaptureProgress.Draw();
if(DrawTargetBox) AdminHud.Draw();
if(Rx_Controller(PlayerOwner).Vet_Menu != none) Rx_Controller(PlayerOwner).Vet_Menu.DrawTiles(self);

//if(DrawC_Visuals)	C_Visuals.Draw(); 
}

function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime )
{
	local string cName, fMsg, rMsg;
	local bool bEVA;

	if (Len(Msg) == 0)
		return;

	if ( bMessageBeep )
		PlayerOwner.PlayBeepSound();

	// Create Raw and Formatted Chat Messages
	
	if (PRI != None)
	{	
		// We have a player, let's sort this out
		cName = CleanHTMLMessage(PRI.PlayerName);

		if (PRI.bAdmin)
			cName = "<font color='#00ffc9'><b>[ADMIN]</b></font> " $ cName;
	
		else if (Rx_PRI(PRI).bModeratorOnly)
			cName = "<font color='#02FF00'><b>[MOD]</b></font> " $ cName;
	}

	else
		cName = "Host";
		
	if (MsgType == 'Say') {
		if (PRI == None)
			fMsg = "<font color='" $HostColor$"'>" $cName$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI)
			fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: ";
		else if (PRI.Team.GetTeamNum() == TEAM_NOD)
			fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: ";
	
		if ( cName != "Host" ) {
			fMsg $= CleanHTMLMessage(Msg);
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'TeamSay') {
		if (PRI.GetTeamNum() == TEAM_GDI)
		{
			fMsg = "<font color='" $GDIColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
		else if (PRI.GetTeamNum() == TEAM_NOD)
		{
			fMsg = "<font color='" $NodColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'Radio')
	{
		if(Rx_PRI(PRI).bGetIsCommander())
			fMsg = "<font color='" $CommandTextColor $"'>" $ "[Commander]" $ cName $": "$ Msg $"</font>"; 
		else
			fMsg = "<font color='" $RadioColor $"'>" $ cName $": "$ Msg $"</font>"; 
		
		fMsg = HighlightStructureNames(fMsg); 
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'Commander') 
	{
		if(Left(Caps(msg), 2) == "/C") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 120.0,,true);
		}
		else
		if(Left(Caps(msg), 2) == "/R") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 360.0,,true);
		}
		fMsg = "<b><font color='" $CommandTextColor $"'>" $ "[Commander]"$ cName $": "$ CleanHTMLMessage(Msg) $"</font></b>";
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'System') {
		if(InStr(Msg, "entered the game") >= 0)
			return;
		fMsg = Msg;
		PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = Msg;
	}
	else if (MsgType == 'PM') {
		if (PRI != None)
			fMsg = "<font color='"$PrivateFromColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		else
			fMsg = "<font color='"$HostColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private from "$ cName $": "$ Msg;
	}
	else if (MsgType == 'PM_Loopback') {
		fMsg = "<font color='"$PrivateToColor$"'>Private to "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private to "$ cName $": "$ Msg;
	}
	else
		bEVA = true;

	// Add to currently active GUI | Edit by Yosh : Don't bother spamming the non-HUD chat logs with radio messages... it's pretty pointless for them to be there.
	if (bEVA)
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddEVAMessage(Msg);
	}
	else
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddChatMessage(fMsg, rMsg);

		if (Scoreboard != none && MsgType != 'Radio' && Scoreboard.bMovieIsOpen) {
			if (PlayerOwner.WorldInfo.GRI.bMatchIsOver) {
				Scoreboard.AddChatMessage(fMsg, rMsg);
			}
		}

		if (RxPauseMenuMovie != none && MsgType != 'Radio' && RxPauseMenuMovie.bMovieIsOpen) {
			if (RxPauseMenuMovie.ChatView != none) {
				RxPauseMenuMovie.ChatView.AddChatMessage(fMsg, rMsg, MsgType=='PM' || MsgType=='PM_Loopback');
			}
		}

	}
}

DefaultProperties
{
	DefaultTargettingRangex = 10000;
	Neutral_Recruit = (Texture = Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Recruit', U= 0, V = 0, UL = 64, VL = 64)
	Neutral_Veteran = (Texture = Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Veteran', U= 0, V = 0, UL = 64, VL = 64)
	Neutral_Elite = (Texture = Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Elite', U= 0, V = 0, UL = 64, VL = 64)
	Neutral_Heroic = (Texture = Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Heroic', U= 0, V = 0, UL = 64, VL = 64)
}
