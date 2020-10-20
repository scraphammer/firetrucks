//=============================================================================
// PFP.
//=============================================================================
class PFP expands Decoration;
/**
"firetrucks" is itself a stupid reference joke.
*/

//firetrucks

#exec MESH IMPORT MESH=pfp ANIVFILE=MODELS\pfp_a.3d DATAFILE=MODELS\pfp_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=pfp X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=pfp SEQ=All STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=pfp SEQ=PFP STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jpfp1 FILE=MODELS\pfp1.PCX GROUP=Skins

#exec MESHMAP NEW   MESHMAP=pfp MESH=pfp
#exec MESHMAP SCALE MESHMAP=pfp X=0.01 Y=0.01 Z=0.02

#exec MESHMAP SETTEXTURE MESHMAP=pfp NUM=1 TEXTURE=Jpfp1

defaultproperties
{
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.PFP'
}
