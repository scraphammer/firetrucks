class FlatSheet expands Decoration;
/**
A flat square deco mesh. Panel is too high poly and uh whatever.
*/

#exec MESH IMPORT MESH=FlatSheet ANIVFILE=MODELS\FlatSheet_a.3d DATAFILE=MODELS\FlatSheet_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=FlatSheet X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=FlatSheet SEQ=All       STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=FlatSheet SEQ=FLATSHEET STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=FlatSheet MESH=FlatSheet
#exec MESHMAP SCALE MESHMAP=FlatSheet X=0.1 Y=0.1 Z=0.2

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=FlatSheet
}
