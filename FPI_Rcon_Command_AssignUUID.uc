/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */
 
class FPI_Rcon_Command_AssignUUID extends Rx_Rcon_Command;

function string trigger(string parameters)
{
	local array<string> MutateStringSplit;
	local Rx_PRI PRI;
	local string error;

	MutateStringSplit = SplitString(parameters, " ", true);
    if (MutateStringSplit.Length == 0 || MutateStringSplit.Length > 1)
    	return "Error: Too many or few parameters." @ getSyntax();

	if (parameters == "")
		return "Error: Too few parameters." @ getSyntax();

	PRI = Rx_Game(`WorldInfoObject.Game).ParsePlayer(MutateStringSplit[0], error);
	
	if (PRI == None)
		return error;

	if (FPI_Controller(PRI.Owner) == None)
		return "Error: Player has no FPI controller!";

	if (FPI_Controller(PRI.Owner) != None)
	{
	FPI_Controller(PRI.Owner).WriteMutatorVersion(MutateStringSplit[1]);
    return "Successfully set"@PRI.GetHumanReadableName()$"'s UUID to"@MutateStringSplit[1];
    }

	return "";
}

function string getHelp(string parameters)
{
	return "Assigns a UUID." @ getSyntax();
}

DefaultProperties
{
	triggers.Add("assignuuid");
	triggers.Add("assign");
	triggers.Add("setuuid");
	Syntax="Syntax: Player[String] UUID[String]";
}
