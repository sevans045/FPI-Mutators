class FPI_PlaceDefenseActor extends Actor;

var() StaticMeshComponent SVehicleMesh;
var array<StaticMeshComponent> StaticMeshPieces;
var private vector2D AS2DRotPlane;
var private float ASCurrentAngle;
var private int StartingYaw;
var MaterialInstanceConstant MIC, MICNoPlace;
var class<Rx_Defense> MyDefense;

simulated event PostBeginPlay()
{
	SetTimer(0.1f, true, nameof(CheckMaterialChange));
}

simulated function SetBuilding(class<Rx_Defense> Defense)
{
	StaticExterior.SetStaticMesh(Vehicle.default.StaticExterior.StaticMesh, true);

	MyBuilding = Building;
}

simulated function class<Rx_Defense> GetDefense()
{
	return MyDefense;
}

simulated function SetMaterials(class<Rx_Defense> Defense)
{
	local int i;
	local MaterialInstanceConstant InitMIC;

	if (CanPlace()) // Find the beginning MIC to use, so it doesn't spawn then change quickly, as it's noticeable.
		InitMIC = MIC;
	else
		InitMIC = MICNoPlace;

	For(i = 0; i < 20; i++) // I hope there's no vehicles with more than 20 materials.
	{
		SVehicleMesh.SetMaterial(i, InitMIC);
	}
}

simulated function CheckMaterialChange()
{
	local int i;

	if (CanPlace())
	{
		For(i = 0; i < 20; i++) 
		{
			if (SVehicleMesh.GetMaterial(i) == MIC) // If mesh is already using this MIC, no need to set it again.
				continue;

			SVehicleMesh.SetMaterial(i, MIC);
		}
	}
	else 
	{
		For(i = 0; i < 20; i++) 
		{
			if (SVehicleMesh.GetMaterial(i) == MICNoPlace) // If mesh is already using this MIC, no need to set it again.
				continue;

			SVehicleMesh.SetMaterial(i, MICNoPlace);
		}
	}
}

simulated function bool CanPlace()
{
	return true;
	//local TS_Volume_BuildingPlacementArea V;
	//
	//ForEach DynamicActors(class'TS_Volume_BuildingPlacementArea', V) // If not inside the volume, return false.
	//{
	//	return V.Encompasses(self);
	//}
	//return false;
}

simulated function AdjustRotation(float X, float Y) // Borrowed from airstrike stuffs. Move mouse in a circle for best results.
{
	local rotator r;
	AS2DRotPlane.X += X * 0.001f;
	AS2DRotPlane.Y += Y * 0.001f;

	ASCurrentAngle = Atan2(AS2DRotPlane.Y, AS2DRotPlane.X);

	// push X and Y back on to circle
	AS2DRotPlane.X = Cos(ASCurrentAngle);
	AS2DRotPlane.Y = Sin(ASCurrentAngle);

	ASCurrentAngle *= RadToDeg;
	ASCurrentAngle -= 90.f;
	r.Yaw = StartingYaw - (ASCurrentAngle * DegToUnrRot);
	SetRotation(r);
}

simulated function Deploy()
{
	local Rx_Chinook_Airdrop AirdropingChinook;

	AirdropingChinook = Spawn(class'FPI_Chinook_Airdrop', , , tempLocation, thisTower.Rotation, , false);
	//byte TeamID, AGN_Rebuildable_Defence_Handler OurHandler, vector thisLocation, rotator thisRotation, int OurHandlerID, int OurTurretType
	AirdropingChinook.Init(thisTower.Team, thisTower.Location, thisTower.Rotation);
}

DefaultProperties
{
    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RX_DEF_GuardTower.Mesh.SK_DEF_GuardTower'
        AnimTreeTemplate=AnimTree'RX_DEF_GuardTower.Anims.AT_DEF_GuardTower'
        PhysicsAsset=PhysicsAsset'RX_DEF_GuardTower.Mesh.SK_DEF_GuardTower_Physics'
		MorphSets[0]=MorphTargetSet'RX_DEF_GuardTower.Mesh.MT_DEF_GuardTower'
    End Object

	MIC = MaterialInstanceConstant'RX_Mesa_Main.Materials.MMat_Holo_Array_Green'//'TS_Buildings_All.Materials.Mat_Holo_INST'
	MICNoPlace = MaterialInstanceConstant'RX_Mesa_Main.Materials.MMat_Holo_Array_Red'//MaterialInstanceConstant'TS_Buildings_All.Materials.Mat_Holo_NoPlace_INST'
}