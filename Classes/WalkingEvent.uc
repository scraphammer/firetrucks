//=============================================================================
// WalkingEvent.
//=============================================================================
class WalkingEvent extends Triggers;

#exec TEXTURE IMPORT FILE="Textures\walktrigger.pcx" NAME="i_WalkingEvent" GROUP="Icons" MIPS=Off FLAGS=2

/**
An event that forces the player to walk.
*/

var() float duration; //The duration of the event. Set to 0 to make it last until triggered again.
var bool isActive;

function Trigger(actor Other, pawn EventInstigator) {
  local FiretrucksPlayer p;
  if (isActive) {
    foreach allActors(class'FiretrucksPlayer', p) p.forceWalking = false;
    setTimer(0, false);
  } else {
    foreach allActors(class'FiretrucksPlayer', p) p.forceWalking = true;
    if (duration > 0) setTimer(duration, false);
  }
  isActive = !isActive;
  if (event != '') triggerEvent(event, other, eventInstigator);
}

function timer() {
  local FiretrucksPlayer p;
  foreach allActors(class'FiretrucksPlayer', p) p.forceWalking = false;
  isActive = false;
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_WalkingEvent'
}
