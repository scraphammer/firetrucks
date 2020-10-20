//=============================================================================
// TankardInv.
//=============================================================================
class TankardInv expands FiretrucksPickup;
/**
The perfect beer container for goths. It is always empty, like their soul.
*/

#exec TEXTURE IMPORT NAME=i_tankard FILE=Textures\i_tankard.pcx GROUP=Icons FLAGS=2 MIPS=OFF

defaultproperties
{
				oneUse=False
				eventOnUse="TankardInvEvent"
				PickupMessage="You got a Tankard. Sadly, it is empty."
				ItemName="Tankard"
				PickupViewMesh=LodMesh'Firetrucks.Tankard'
				PickupSound=Sound'UnrealShare.Tentacle.TentSpawn'
				ActivateSound=Sound'UnrealShare.Slith.slithr1sl'
				Icon=Texture'Firetrucks.Icons.i_tankard'
				Mesh=LodMesh'Firetrucks.Tankard'
}
