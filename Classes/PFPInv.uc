//=============================================================================
// PFPInv.
//=============================================================================
class PFPInv expands FiretrucksPickup;
/**
And this is the version that goes in your inventory. I'll probably get an
 angry C&D letter because of this.
*/

#exec texture import name=i_pfp file=Textures\i_pfp.pcx group=Icons mips=off flags=2

defaultproperties
{
				oneUse=False
				eventOnUse="PFPInvEvent"
				PickupMessage="You got a NEK Play Field Personal! The reference has finally been pushed too far."
				ItemName="NEK Play Field Personal"
				PickupViewMesh=LodMesh'Firetrucks.PFP'
				PickupSound=Sound'UnrealShare.Tentacle.TentSpawn'
				ActivateSound=Sound'UnrealShare.Slith.slithr1sl'
				Icon=i_pfp
				Mesh=LodMesh'Firetrucks.PFP'
}
