//=============================================================================
// Collider.
//=============================================================================
class Collider extends Triggers;

#exec texture import file=Textures\collider.pcx name=i_collider group=Icons mips=Off flags=2

/**
  When triggered, can toggle collision of a specified actor.
 */

var() name targetTag; //The tag of the target actor(s).
var() enum ColliderType {
  CT_ON,
  CT_OFF,
  CT_TOGGLE,
} collideType; //Controls whether collision is enabled, disabled, or toggled.
var() enum CollideTargetType {
  TT_TAG, //SLOW AVOID USE
  TT_TARGET, //this is *hella* fast!
  TT_PROTOTYPE, //SLOW AVOID USE
} targetType; //Controls how this actor acquires its targets. Using tags or prototypes is very slow and should be used sparingly. If there are ten things you want to toggle collision for, it is faster during runtime to use ten Collider actors set to TT_TARGET than it is to use one with a tag.
var() Actor collideTarget; //The exact target, if the targeting mode is set to use an exact target.
var() class<Actor> prototype; //The class of actors to toggle, if set to that mode.

function Trigger(actor Other, pawn EventInstigator) {
  local Actor a;
  switch(targetType) {
    case TT_TAG:
      foreach allactors(class'Actor', a, targetTag) colliderMain(a);
      break;
    case TT_TARGET:
      colliderMain(collideTarget);
      break;
    case TT_PROTOTYPE:
      foreach allactors(protoType, a) colliderMain(a);
      break;
  }
  if (event != '') triggerEvent(event, other, eventInstigator);
}

function colliderMain(Actor a) {
  if (a != none) {
    switch(collideType) {
      case CT_ON:
        a.setCollision(true, true, true);
        break;
      case CT_OFF:
        a.setCollision(false, false, false);
        break;
      case CT_TOGGLE:
        a.setCollision(!a.bCollideActors, !a.bcollideActors, !a.bblockPlayers);
        break;
    }
  }
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_collider'
}
