/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_Weapon_RepairTool extends Rx_Weapon_RepairTool;


simulated function RepairDeployedActor(Rx_Weapon_DeployedActor deployedActor, float DeltaTime)
{

    if (!deployedActor.bCanNotBeDisarmedAnymore
            && (IsEnemy(deployedActor) || (Rx_Weapon_DeployedProxyC4(deployedActor) != None
                                                && CurrentFireMode == 0
                                                && (Rx_Weapon_DeployedProxyC4(deployedActor).OwnerPRI == Instigator.PlayerReplicationInfo || Rx_PRI(Rx_Weapon_DeployedProxyC4(deployedActor).OwnerPRI).GetMineStatus() == false ||  Instigator.PlayerReplicationInfo.bAdmin ) // Checks who can disarm this mine. Owner, minebanned, mod/admin
                                                && deployedActor.HP > 0
                                                && deployedActor.HP <= deployedActor.MaxHP)))
    {
        Repair(deployedActor,DeltaTime,true);
    }
    else if (deployedActor.HP > 0 &&
            deployedActor.HP <= deployedActor.MaxHP)
    {
        Repair(deployedActor,DeltaTime,false);
    }
    else
    {
        bHealing = false;
    }
}
