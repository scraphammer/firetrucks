//=============================================================================
// SwordInv.
//=============================================================================
class SwordInv expands FiretrucksPickup;
/**
Actually using a sword would make the main character a mary sue. You can 
carry one around though.
*/

#exec TEXTURE IMPORT NAME=i_sword FILE=Textures\i_sword.PCX GROUP=Icons FLAGS=2 MIPS=OFF

#exec MESH IMPORT MESH=sword_pick ANIVFILE=MODELS\sword_pick_a.3d DATAFILE=MODELS\sword_pick_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=sword_pick X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=sword_pick SEQ=All        STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=sword_pick SEQ=SWORD_PICK STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jsword1 FILE=MODELS\sword1.PCX GROUP=Skins

#exec MESHMAP NEW   MESHMAP=sword_pick MESH=sword_pick
#exec MESHMAP SCALE MESHMAP=sword_pick X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=sword_pick NUM=1 TEXTURE=Jsword1

defaultproperties
{
				eventOnUse="SwordInvEvent"
				attachmentClass=Class'Firetrucks.SwordBack'
				PickupMessage="You got a long sword"
				ItemName="Sword"
				PickupViewMesh=LodMesh'Firetrucks.sword_pick'
				PickupSound=Sound'UnrealShare.General.DispEX1'
				ActivateSound=Sound'UnrealShare.Manta.fly1m'
				Icon=Texture'Firetrucks.Icons.i_sword'
				Mesh=LodMesh'Firetrucks.sword_pick'
}
