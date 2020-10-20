//=============================================================================
// KeyInv.
//=============================================================================
class KeyInv expands FiretrucksPickup;
/**
Is this a key that goes in your inventory or a thing that goes in your
inventory that happens to look like a key?
*/

#exec TEXTURE IMPORT NAME=i_key FILE=Textures\i_key.PCX GROUP=Icons FLAGS=2 MIPS=OFF

defaultproperties
{
				oneUse=False
				eventOnUse="KeyInvEvent"
				PickupMessage="You got a key."
				ItemName="Key"
				PickupViewMesh=LodMesh'Firetrucks.Key'
				PickupSound=Sound'UnrealShare.AutoMag.Shell2'
				ActivateSound=Sound'UnrealShare.Eightball.GrenadeFloor'
				Icon=Texture'Firetrucks.Icons.i_key'
				Mesh=LodMesh'Firetrucks.Key'
}
