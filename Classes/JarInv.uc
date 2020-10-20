//=============================================================================
// JarInv.
//=============================================================================
class JarInv expands FiretrucksPickup;
/**
An inventory item that looks like a jar.
*/

#exec TEXTURE IMPORT NAME=i_jar FILE=Textures\i_jar.PCX GROUP=Icons FLAGS=2 MIPS=OFF

defaultproperties
{
				eventOnUse="JarInvEvent"
				PickupMessage="You got a mysterious jar"
				ItemName="Jar"
				PickupViewMesh=LodMesh'Firetrucks.Jar'
				PickupSound=Sound'UnrealShare.Tentacle.TentSpawn'
				ActivateSound=Sound'UnrealI.Blob.BlobGoop3'
				Icon=Texture'Firetrucks.Icons.i_jar'
				Mesh=LodMesh'Firetrucks.Jar'
}
