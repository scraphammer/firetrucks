//=============================================================================
// FiretrucksCamera.
//=============================================================================
class FiretrucksCamera extends Pawn;

#exec MESH IMPORT MESH=FiretrucksCamera ANIVFILE=MODELS\MadCamera_a.3d DATAFILE=MODELS\MadCamera_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=FiretrucksCamera X=0 Y=0 Z=0 YAW=63 PITCH=0 ROLL=0

#exec MESH SEQUENCE MESH=FiretrucksCamera SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=FiretrucksCamera SEQ=CAMERA STARTFRAME=0 NUMFRAMES=1

#exec texture import file=Textures\UIWhite.pcx name=AllWhiteWonderTex group=Misc mips=Off
#exec texture import file=Textures\UIBlack.pcx name=SolidBlackTexture group=Misc mips=Off
#exec texture import file=Models\MadCamera1.pcx name=jFiretrucksCamera1 group=Skins

#exec MESHMAP NEW   MESHMAP=FiretrucksCamera MESH=MadCamera
#exec MESHMAP SCALE MESHMAP=FiretrucksCamera X=0.01 Y=0.01 Z=0.02

#exec MESHMAP SETTEXTURE MESHMAP=FiretrucksCamera NUM=1 TEXTURE=jFiretrucksCamera1

/**
Camera actor used by CameraEvent actors and DialogueNode actors. It is invisible in-game, but has a mesh in the editor you can tell which way it is pointing, even if it isn't selected.
*/

var() float fov; //The camera's field of vision.

function Trigger(actor Other, pawn EventInstigator) {
  setPhysics(PHYS_INTERPOLATING);
  bInterpolating = true;
}

defaultproperties
{
				FOV=90.000000
				bHidden=True
				DrawType=DT_Mesh
				Mesh=LodMesh'Firetrucks.FiretrucksCamera'
				bUnlit=True
				bCollideActors=False
				bCollideWorld=False
				bBlockActors=False
				bBlockPlayers=False
}
