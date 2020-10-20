//=============================================================================
// BottleInv.
//=============================================================================
class BottleInv expands FiretrucksPickup;
/**
An inventory item that looks like the Bottle
*/

#exec TEXTURE IMPORT NAME=i_bottle FILE=Textures\i_bottle.PCX GROUP=Icons FLAGS=2 MIPS=OFF

defaultproperties
{
				eventOnUse="BottleInvEvent"
				PickupMessage="You got a bottle of brown fluid."
				ItemName="Bottle"
				PickupViewMesh=LodMesh'Firetrucks.Bottle'
				PickupSound=Sound'UnrealShare.Tentacle.TentSpawn'
				ActivateSound=Sound'UnrealShare.Slith.slithr1sl'
				Icon=Texture'Firetrucks.Icons.i_bottle'
				Mesh=LodMesh'Firetrucks.Bottle'
}
