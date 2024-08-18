//=============================================================================
// Destroyer.
//=============================================================================
class Destroyer extends Triggers;

#exec texture import file=Textures\destroyer.pcx name=i_destroyer group=Icons mips=Off flags=2

/**
 When triggered, destroys the specified actor(s). It has the option to spawn an effect in its place, if you desire. Unleash your destructive side!
 */

var() name targetTag; //The tag of the target actor(s).
var() enum DestroyerTargetType {
  TT_TAG, //SLOW AVOID USE
  TT_TARGET, //this is *hella* fast!
  TT_PROTOTYPE, //SLOW AVOID USE
} targetType; //Controls how this actor acquires its targets. Using tags or prototypes is very slow and should be used sparingly. If there are ten things you want to destroy, it is faster during runtime to use ten Destroyer actors set to TT_TARGET than it is to use one with a tag.
var() Actor destroyTarget; //The exact target, if the targeting mode is set to use an exact target.
var() class<Actor> prototype; //The class of actors to destroy, if set to that mode.
var() class<Effects> effectToSpawn; //If set, this effect will be spawned after destroying the target.

function Trigger(actor Other, pawn EventInstigator) {
  local Actor a;
  switch(targetType) {
    case TT_TAG:
      if (targetTag == '') {
        warn("improperly configured Destroyer actor:"@self);
        break;
      }
      foreach allactors(class'Actor', a, targetTag) destroyerMain(a);
      break;
    case TT_TARGET:
      destroyerMain(destroyTarget);
      break;
    case TT_PROTOTYPE:
      foreach allactors(protoType, a) destroyerMain(a);
      break;
  }
  if (event != '') triggerEvent(event, other, eventInstigator);
}

function destroyerMain(Actor a) {
  if (a != none) {
    a.destroy();
    if (EffectToSpawn != none) spawn(effectToSpawn,,,a.Location,);
  }
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_destroyer'
}
