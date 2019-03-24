//This has some bugs to work out still, so we don't need to use it for now.

class FPI_Weapon_DeployedFlowerPot extends Rx_Weapon_DeployedC4
	implements (RxIfc_TargetedDescription);

/** Countdown to explosion */
var repnotify int Count;

replication
{
	if (bNetDirty)
		Count;
}

simulated event ReplicatedEvent(name VarName) {
	if (VarName == 'Count') {
	}
	else {
		super.ReplicatedEvent(VarName);
	}
}

function bool IsStealthUnit(pawn inPawn)
{
	if ((Rx_Pawn_SBH(inPawn) != None || Rx_Vehicle_StealthTank(inPawn) != None))
	{
		return true;			
	}
	return false;
}


function Landed(vector HitNormal, Actor FloorActor)
{
	ImpactedActor = FloorActor;
   	//loginternal(impactedActor);
   	FloorNormal = HitNormal;
   	PlaySound(ImpactSound);
	
	super(Actor).Landed(HitNormal, FloorActor);
   
	if (WorldInfo.NetMode != NM_Client)
      bDeployed = true;

	//if(!IsStealthUnit(FloorActor))
	//{
		PerformDeploy();
	//}
	
		//PerformDeploy();
      
	if (FloorActor != None)
    {
    	if((Rx_Weapon_DeployedActor(FloorActor) == none))// && !IsStealthUnit(FloorActor))
    	{
            SetBase(FloorActor, HitNormal);
			Mesh.SetTraceBlocking (true,true); //Enable collision with zero-extent traces for repair guns
			
		}
    }
	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
    	if(LandEffects != none && !LandEffects.bIsActive)
    	{
        LandEffects.SetActive(true);
    	}
	} 
	else 
	{    
		SetTimer(0.5,false,'ReplicatePositionAfterLanded');
	}
	
	if(IsStealthUnit(pawn(FloorActor)))
	{
		Explosion();
	}
}


function CountDown()
{
	Count--;
}

simulated function string GetTargetedDescription(PlayerController PlayerPerspective)
{
	return "";
}


defaultproperties
{
	DeployableName="Flowerpot"
	Count=30.0
	DmgRadius=1
	BuildingDmgRadius = 1
	HP = 200
    Damage=0
    DamageMomentum=1.0

    DisarmScoreReward = 5	

	ExplosionLightClass=None
	ExplosionTemplate=ParticleSystem'RX_WP_PotGun.Effects.P_Bullet_Impact_Dirt_Heavy'
	ExplosionSound=SoundCue'RX_WP_PotGun.Sounds.SC_Pot_Break'
    ImpactSound=SoundCue'RX_WP_PotGun.Sounds.SC_Pot_Land'
	ChargeDamageType=class'Rx_DmgType_TimedC4'

	ExplosionShake=None
	InnerExplosionShakeRadius=1
	OuterExplosionShakeRadius=2

	Begin Object Name=DeployableMesh
		SkeletalMesh=SkeletalMesh'RX_WP_PotGun.Mesh.SK_Pot2'
		//PhysicsAsset=SkeletalMesh'RX_WP_PotGun.Mesh.SK_Pot2'
		Scale=1.0
	End Object
}