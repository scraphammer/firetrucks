//=============================================================================
// Bottle3Inv.
//=============================================================================
class Bottle3Inv expands FiretrucksPickup;
/**
An inventory item that appears like Bottle3
*/

#exec TEXTURE IMPORT NAME=i_bottle3 FILE=Textures\i_bottle3.PCX GROUP=Icons FLAGS=2 MIPS=OFF

defaultproperties
{
				eventOnUse="Bottle3InvEvent"
				PickupMessage="You got a wine bottle."
				ItemName="Bottle"
				PickupViewMesh=LodMesh'Firetrucks.Bottle3'
				PickupSound=Sound'UnrealShare.Slith.SliImpact'
				ActivateSound=Sound'UnrealShare.Slith.SliSpawn'
				Icon=Texture'Firetrucks.Icons.i_bottle3'
				Mesh=LodMesh'Firetrucks.Bottle3'
}
