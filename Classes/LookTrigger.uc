//=============================================================================
// LookTrigger.
//=============================================================================
class LookTrigger extends Triggers;

#exec texture import file=Textures\looktrigger.pcx name=i_lookTrigger group=Icons mips=Off flags=2

/**
 A trigger that only fires its event when the player is standing within its radius and looking towards the specified actor.
 */

var() bool Enabled; //Whether or not this actor is enabled.
var() Actor LookTarget; //The target actor for the player to be looking at.
var() bool LookAway; //If true, the trigger fires when the player is looking away from the target, rather than towards the target.
var editconst enum FlashType {
  FT_EITHER,
  FT_FLASHLIGHT,
  FT_NOFLASHLIGHT,
} requireFlashLight; //Whether or not this actor should behave differently when player the player has a WeedrowFlashlight and it is toggled on or off.
var() bool TriggerOnceOnly; //If true, the trigger disables itself after firing once.
var() float ReTriggerDelay; //After triggering, this is the delay before it can trigger again.
var() float Precision; //The maximum (or minimum) angle in radians for the player's viewRotation to deviate from a direct line to the target in order for this actor to trigger.
var() editconst String PrecisionHelpText;

var bool ready;
var bool active;

function tick(Float f) {
  local PlayerPawn p;
  local bool b;
  if (!active) return;
  if (!enabled) return;
  if (!ready) return;
  if (lookTarget == none) return;

  foreach TouchingActors(class'PlayerPawn', p) {
  
    if (lookAway) b = angleBetween(lookTarget, p) > precision;
    else b = angleBetween(lookTarget, p) < precision;
    
    if (b) {
      triggerEvent(event, Self, p);
      if (triggerOnceOnly) enabled = false;
      if (reTriggerDelay > 0) {
        ready = false;
        setTimer(retriggerDelay, false);
      }
      return;
    }
  }
}

function timer() {
  ready = true;
}

function Trigger(actor Other, pawn EventInstigator) {
  enabled = !enabled;
}

simulated function float angleBetween(Actor a, Pawn p) {
  local vector v, d;
  d = a.location - p.location;
  v = vector(p.viewRotation);
  return acos((d dot v) / (vSize(d) * vSize(v)));
}

event Touch(Actor other) {
  if (PlayerPawn(Other) != none) active = true;
}

event Untouch(Actor other) {
  local PlayerPawn p;
  foreach TouchingActors(class'PlayerPawn', p) return;
  active = false;
}

defaultproperties
{
				Enabled=True
        ReTriggerDelay=1
				precision=0.400000
				ready=True
				Texture=Texture'Firetrucks.Icons.i_lookTrigger'
        PrecisionHelpText="It's the maximum angle expressed in radians between the player view rotation and the direct line between the player and the target actor."
}
