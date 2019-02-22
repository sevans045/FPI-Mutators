class FPI_CrateType_IRIVehicle extends FPI_CrateType;

var transient Rx_Vehicle GivenVehicle;
var config float ProbabilityIncreaseWhenVehicleProductionDestroyed;
var array<class<Rx_Vehicle> > Vehicles;

function string GetPickupMessage()
{
	return ("The Fabric of Spacetime has warped! You have Received a special vehicle!");
	//return Repl(PickupMessage, "`vehname`", GivenVehicle.GetHumanReadableName(), false);
}

function string GetGameLogMessage(Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	return "GAME" `s "Crate;" `s "Classic_Vehicle" `s GivenVehicle.class.name `s "by" `s `PlayerLog(RecipientPRI);
}

function float GetProbabilityWeight(Rx_Pawn Recipient, Rx_CratePickup CratePickup)
{			
	local Rx_Building building;
	local float Probability;

	if (CratePickup.bNoVehicleSpawn || Vehicles.Length == 0)
		return 0;
	else
	{
		Probability = Super.GetProbabilityWeight(Recipient,CratePickup);

		ForEach CratePickup.AllActors(class'Rx_Building',building)
		{
			if((Recipient.GetTeamNum() == TEAM_GDI && Rx_Building_GDI_VehicleFactory(building) != none  && Rx_Building_GDI_VehicleFactory(building).IsDestroyed()) || 
				(Recipient.GetTeamNum() == TEAM_NOD && Rx_Building_Nod_VehicleFactory(building) != none  && Rx_Building_Nod_VehicleFactory(building).IsDestroyed()))
			{
				Probability += ProbabilityIncreaseWhenVehicleProductionDestroyed;
			}
		}

		return Probability;
	}
}

function ExecuteCrateBehaviour(Rx_Pawn Recipient, Rx_PRI RecipientPRI, Rx_CratePickup CratePickup)
{
	local Vector tmpSpawnPoint;
	local Rotator SpawnRot;

	tmpSpawnPoint = CratePickup.Location + vector(CratePickup.Rotation)*450;
	tmpSpawnPoint.Z += 200;

	SpawnRot = CratePickup.Rotation;
	SpawnRot.Yaw += 8192;	//Add ~45 degrees so if it's a Superhind, it doesn't whack the recipient.

	if(Rx_MapInfo(CratePickup.WorldInfo.GetMapInfo()).bAircraftDisabled) //If it is, check two things: is it a non-flying map and is this an aircraft?
	{
		GivenVehicle = CratePickup.Spawn(Vehicles[Rand(Vehicles.Length-1)],,, tmpSpawnPoint, SpawnRot,,true);
	}
	else
	{
		GivenVehicle = CratePickup.Spawn(Vehicles[Rand(Vehicles.Length)],,, tmpSpawnPoint, SpawnRot,,true);
	}
	
	GivenVehicle.DropToGround();
	if (GivenVehicle.Mesh != none)
		GivenVehicle.Mesh.WakeRigidBody();
}

DefaultProperties
{
	BroadcastMessageIndex=6
	PickupSound=SoundCue'Rx_Pickups.Sounds.SC_Crate_VehicleDrop'

	Vehicles.Add(class'Rx_Vehicle_LAV');
	Vehicles.Add(class'Rx_Vehicle_RocketArtillery');
	Vehicles.Add(class'Rx_Vehicle_Superhind');

}