//=============================================================================
// Bottle2.
//=============================================================================
class Bottle2 expands Decoration;
/**
Sometimes one bottle isn't enough;
*/

#exec MESH IMPORT MESH=bottle2 ANIVFILE=MODELS\bottle2_a.3d DATAFILE=MODELS\bottle2_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bottle2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=bottle2 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=bottle2 SEQ=BOTTLE2 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jbottle21 FILE=MODELS\bottle21.PCX GROUP=Skins DETAIL=grittyDetail4

#exec MESHMAP NEW   MESHMAP=bottle2 MESH=bottle2
#exec MESHMAP SCALE MESHMAP=bottle2 X=0.01 Y=0.01 Z=0.02

#exec MESHMAP SETTEXTURE MESHMAP=bottle2 NUM=1 TEXTURE=Jbottle21

defaultproperties
{
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.Bottle2'
}
