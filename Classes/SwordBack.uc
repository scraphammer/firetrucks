//=============================================================================
// SwordBack.
//=============================================================================
class SwordBack extends Attachment;
/**
Attachs a badass sword to the player's back. Awesome right? jk it detaches
 from the player sometimes and looks like ass.
*/

#exec MESH IMPORT MESH=swordback ANIVFILE=MODELS\swordback_a.3d DATAFILE=MODELS\swordback_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=swordback X=135 Y=-60 Z=-127

#exec MESH SEQUENCE MESH=swordback SEQ=All       STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=swordback SEQ=SWORDBACK STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=swordback MESH=swordback
#exec MESHMAP SCALE MESHMAP=swordback X=0.06 Y=0.06 Z=0.12

#exec MESHMAP SETTEXTURE MESHMAP=swordback NUM=1 TEXTURE=Jsword1

defaultproperties
{
				Mesh=LodMesh'Firetrucks.SwordBack'
}
