//=============================================================================
// PostBeginPlayTrigger.
//=============================================================================
class PostBeginPlayTrigger extends Triggers;

#exec texture import file=Textures\pbptrig.pcx name=i_pbptrig group=Icons mips=Off flags=2

/**
A trigger that fires its event on postBeginPlay(). Very useful for things like intro cutscenes!
*/

var bool once;

function postBeginPlay() {
  if (once) return;
  once = true;
  setTimer(0.001, false);
}

function timer() {
  triggerEvent(event);
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_pbptrig'
}
