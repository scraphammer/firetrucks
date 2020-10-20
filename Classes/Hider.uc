//=============================================================================
// Hider.
//=============================================================================
class Hider extends Triggers;

#exec texture import file=Textures\hider.pcx name=i_hider group=Icons mips=Off flags=2

/**
Toggles the visibility of the specified actor(s).
*/

var() name targetTag; //The tag of the target actor(s).
var() enum HiderType {
  HT_HIDE,
  HT_SHOW,
  HT_TOGGLE,
} hideType; //Controls whether visibility is enabled, disabled, or toggled.
var() enum HideTargetType {
  TT_TAG, //SLOW AVOID USE
  TT_TARGET, //this is *hella* fast!
  TT_PROTOTYPE, //SLOW AVOID USE
} targetType; //Controls how this actor acquires its targets. Using tags or prototypes is very slow and should be used sparingly. If there are ten things you want to toggle visibility for, it is faster during runtime to use ten Hider actors set to TT_TARGET than it is to use one with a tag.
var() Actor hideTarget; //The exact target, if the targeting mode is set to use an exact target.
var() class<Actor> prototype; //The class of actors to toggle, if set to that mode.
var() class<Effects> effectToSpawn; //If set, this effect will be spawned after toggling the visibility of the target.

function Trigger(actor Other, pawn EventInstigator) {
  local Actor a;
  switch(targetType) {
    case TT_TAG:
      foreach allactors(class'Actor', a, targetTag) hiderMain(a);
      break;
    case TT_TARGET:
      hiderMain(hideTarget);
      break;
    case TT_PROTOTYPE:
      foreach allactors(protoType, a) hiderMain(a);
      break;
  }
  triggerEvent(event, other, eventInstigator);
}

function timer() {
  local Actor a;
  switch(targetType) {
    case TT_TAG:
      foreach allactors(class'Actor', a, targetTag) a.setLocation(a.location - vect(0, 0, 0.001));
      break;
    case TT_TARGET:
      hideTarget.setLocation(hideTarget.location - vect(0, 0, 0.001));
      break;
    case TT_PROTOTYPE:
      foreach allactors(protoType, a)a.setLocation(a.location - vect(0, 0, 0.001));
      break;
  }
}

function hiderMain(Actor a) {
  if (a != none) {
    switch(hideType) {
      case HT_HIDE:
        a.bHidden = true;
        a.bNoDynamicShadowCast = true;
        break;
      case HT_SHOW:
        a.bHidden = false;
        a.bNoDynamicShadowCast = false;
        break;
      case HT_TOGGLE:
        a.bHidden = !a.bHidden;
        a.bNoDynamicShadowCast = !a.bNoDynamicShadowCast;
        break;
    }
    a.setLocation(a.location + vect(0, 0, 0.0001));
    setTimer(0.001, false);
    if (EffectToSpawn != none) spawn(effectToSpawn,,,a.Location,);
  }
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_hider'
}
