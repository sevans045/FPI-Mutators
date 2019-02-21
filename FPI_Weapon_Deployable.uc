/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */
 
class FPI_Weapon_Deployable extends Rx_Weapon_Deployable;

var SoundCue NotificationSound;

function OvermineBroadcast()
{
	local Rx_Controller PC;
	local string Message;

	Message = Instigator.Controller.PlayerReplicationInfo.PlayerName $ " is over-mining " $ Rx_Controller(Instigator.Controller).GetSpottargetLocationInfo(self);
	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
		if (Instigator.GetTeamNum() == PC.GetTeamNum())
			PC.ClientMessage(Message, 'EVA');
		Rx_Controller(Instigator.Controller).CTextMessage("[FPI] You're overmining!",'Red',300.0,1.5);
		Rx_Controller(Instigator.Controller).CTextMessage("[FPI] Do you know what you're doing?",'Red',300.0,1.5);

	`LogRx("GAME" `s "OverMine;" `s `PlayerLog(Instigator.Controller.PlayerReplicationInfo) `s "near" `s Rx_Controller(Instigator.Controller).GetSpottargetLocationInfo(self));
}

DefaultProperties
{
}