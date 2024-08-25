//=============================================================================
// FiretrucksGlass. Tired of setting up movers for breakable glass? Just use a
// mesh lol.
//=============================================================================
class FiretrucksGlass extends BreakingGlass;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	DrawType = DT_Mesh;
}

defaultproperties {
  DrawType=DT_Mesh
  Mesh=LodMesh'ipanel'
  DrawScale=1
  MultiSkins[0]=Texture'DefaultTexture'
  bCollideActors=True
	bCollideWorld=True
	bBlockActors=True
	bBlockPlayers=True
	bShadowCast=Flase
  Style=STY_Translucent
  bUseMeshCollision=True
}