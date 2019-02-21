/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

 class FPI_Pawn extends Rx_Pawn;

reliable client function ClientSprayDecal()
{
	local MaterialInterface myDecal;

	if (GetTeamNum() == 0)
		myDecal = MaterialInstanceConstant'RX_Mesa_Main.DecalMaterials.MatInst_Old_GDI_Logo';
	else
		myDecal = MaterialInstanceConstant'RX_Mesa_Main.DecalMaterials.MatInst_NodLogo';
	//GetMyDecals();
	ServerSprayDecal(myDecal, Rx_Controller(GetALocalPlayerController()).GetHUDAim(), GetBaseAimRotation());
}

reliable server function ServerSprayDecal(MaterialInterface inDecal, vector inLoc, rotator inRot)
{
	SprayDecal(inDecal, inLoc, inRot);
}

simulated function SprayDecal(MaterialInterface inDecal, vector inLoc, rotator inRot)
{
	WorldInfo.MyDecalManager.SpawnDecal(inDecal, inLoc, inRot, 50.5f, 50.5f, 50.5f, true,,,,,,,10.0f);
}