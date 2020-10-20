//=============================================================================
// Bottle3.
//=============================================================================
class Bottle3 expands Decoration;
/**
In case hard liquor isn't your thing I modeled this one to look like wine.
*/

#exec MESH IMPORT MESH=bottle3 ANIVFILE=MODELS\bottle3_a.3d DATAFILE=MODELS\bottle3_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bottle3 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=bottle3 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=bottle3 SEQ=BOTTLE3 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jbottle31 FILE=MODELS\bottle31.PCX GROUP=Skins

#exec MESHMAP NEW   MESHMAP=bottle3 MESH=bottle3
#exec MESHMAP SCALE MESHMAP=bottle3 X=0.015 Y=0.015 Z=0.03

#exec MESHMAP SETTEXTURE MESHMAP=bottle3 NUM=1 TEXTURE=Jbottle31

defaultproperties
{
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.Bottle3'
}
