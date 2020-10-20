//=============================================================================
// Bottle.
//=============================================================================
class Bottle expands Decoration;
/**
A sweet decoration for the drunkard in you!
*/

#exec OBJ LOAD FILE=Liquids.utx

#exec MESH IMPORT MESH=bottle ANIVFILE=MODELS\bottle_a.3d DATAFILE=MODELS\bottle_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=bottle X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=bottle SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=bottle SEQ=BOTTLE STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jbottle1 FILE=MODELS\bottle1.PCX GROUP=Skins DETAIL=grittyDetail5

#exec MESHMAP NEW   MESHMAP=bottle MESH=bottle
#exec MESHMAP SCALE MESHMAP=bottle X=0.015 Y=0.015 Z=0.03

#exec MESHMAP SETTEXTURE MESHMAP=bottle NUM=1 TEXTURE=Jbottle1
#exec MESHMAP SETTEXTURE MESHMAP=bottle NUM=2 TEXTURE=Liquid8

defaultproperties
{
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.Bottle'
}
