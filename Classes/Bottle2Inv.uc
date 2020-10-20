//=============================================================================
// Bottle2Inv.
//=============================================================================
class Bottle2Inv expands FiretrucksPickup;
/**
An inventory item that resembles Bottle2
*/
#exec TEXTURE IMPORT NAME=i_bottle2 FILE=Textures\i_bottle2.PCX GROUP=Icons FLAGS=2 MIPS=OFF

defaultproperties
{
				eventOnUse="Bottle2InvEvent"
				PickupMessage="You got a small turquoise bottle"
				ItemName="Bottle"
				PickupViewMesh=LodMesh'Firetrucks.Bottle2'
				PickupSound=Sound'UnrealShare.Tentacle.TentSpawn'
				ActivateSound=Sound'UnrealShare.Slith.slithr1sl'
				Icon=Texture'Firetrucks.Icons.i_bottle2'
				Mesh=LodMesh'Firetrucks.Bottle2'
}
