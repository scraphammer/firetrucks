class Firetruck expands Decoration;

#exec MESH IMPORT MESH=firetruckdeco ANIVFILE=MODELS\firetruckdeco_a.3d DATAFILE=MODELS\firetruckdeco_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=firetruckdeco X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=firetruckdeco SEQ=All           STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=firetruckdeco SEQ=FIRETRUCKDECO STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jfiretruckdeco1 FILE=MODELS\firetruckdeco1.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=Jfiretruckdeco2 FILE=MODELS\firetruckdeco2.PCX GROUP=Skins

#exec MESHMAP NEW   MESHMAP=firetruckdeco MESH=firetruckdeco
#exec MESHMAP SCALE MESHMAP=firetruckdeco X=0.02 Y=0.02 Z=0.04

#exec MESHMAP SETTEXTURE MESHMAP=firetruckdeco NUM=1 TEXTURE=Jfiretruckdeco1

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=firetruckdeco
}
