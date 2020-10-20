//=============================================================================
// Key.
//=============================================================================
class Key expands Decoration;
/**
A decorative key.
*/

#exec MESH IMPORT MESH=key ANIVFILE=MODELS\key_a.3d DATAFILE=MODELS\key_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=key X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=key SEQ=All STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=key SEQ=KEY STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jkey1 FILE=MODELS\key1.PCX GROUP=Skins DETAIL=grittyDetail6

#exec MESHMAP NEW   MESHMAP=key MESH=key
#exec MESHMAP SCALE MESHMAP=key X=0.01 Y=0.01 Z=0.02

#exec MESHMAP SETTEXTURE MESHMAP=key NUM=1 TEXTURE=Jkey1

defaultproperties
{
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.Key'
}
