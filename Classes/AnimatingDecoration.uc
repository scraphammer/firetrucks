//=============================================================================
// AnimatingDecoration.
//=============================================================================
class AnimatingDecoration extends Decoration;

/**
  An animating decoration that I thought mappers might find useful or fun.
*/

var() name animationToLoop; //The animation to be looped. Make sure the <span>mesh</span> specified has the animation you desire.

auto state Looping {
  begin:
  loopAnim(animationToLoop);
}

defaultproperties
{
				animationToLoop="'"
				bStatic=False
				DrawType=DT_Mesh
				Mesh=LodMesh'UnrealI.Squid1'
}
