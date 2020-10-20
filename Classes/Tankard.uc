//=============================================================================
// Tankard.
//=============================================================================
class Tankard expands Decoration;
/**
A tankard. Some people drink from them but this one is just for decoration.
*/

#exec MESH IMPORT MESH=tankard ANIVFILE=MODELS\tankard_a.3d DATAFILE=MODELS\tankard_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=tankard X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=tankard SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=tankard SEQ=TANKARD STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jtankard1 FILE=MODELS\tankard1.PCX GROUP=Skins DETAIL=grittyDetail4

#exec MESHMAP NEW   MESHMAP=tankard MESH=tankard
#exec MESHMAP SCALE MESHMAP=tankard X=0.01 Y=0.01 Z=0.02

#exec MESHMAP SETTEXTURE MESHMAP=tankard NUM=1 TEXTURE=Jtankard1

defaultproperties
{
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.Tankard'
}
