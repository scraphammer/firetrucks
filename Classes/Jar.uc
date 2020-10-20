//=============================================================================
// Jar.
//=============================================================================
class Jar expands Decoration;
/**
A decorative jar.
*/

#exec MESH IMPORT MESH=jar ANIVFILE=MODELS\jar_a.3d DATAFILE=MODELS\jar_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=jar X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=jar SEQ=All STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=jar SEQ=JAR STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jjar1 FILE=MODELS\jar1.PCX GROUP=Skins DETAIL=pock

#exec MESHMAP NEW   MESHMAP=jar MESH=jar
#exec MESHMAP SCALE MESHMAP=jar X=0.01 Y=0.01 Z=0.02

#exec MESHMAP SETTEXTURE MESHMAP=jar NUM=1 TEXTURE=Jjar1

defaultproperties
{
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.Jar'
}
