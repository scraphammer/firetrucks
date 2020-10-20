class MouseTriggers extends Triggers abstract;

/**
Parent class for mouse related triggers. In retrospect I probably should have just merged them all into one class.
*/

#exec texture import file=Textures\cursorevent.pcx name=i_cea group=Icons mips=Off flags=2

var PointAndClickEvent pcaEvent;

var() Actor targetActor; //The target actor. Can target self.
var() bool disableAfterUse; //Whether or not to disable after use.
var() bool enabled; //Whether or not this actor is enabled

var() enum TriggerAction {
  TA_TOGGLE,
  TA_ENABLE,
  TA_DISABLE,
  TA_IGNORE,
} onTrigger; //What happens when THIS actor is triggered
var() bool ignoreHiddenTarget; //If true, it will prevent interraction with targets that are hidden.

var() bool highlightTarget; //If true, the target becomes unlit while the mouse is over it

var() vector useOffset; //Allows the end-user (that's you!) to specify an offset from the target's center
var() float maxFudge; //How large (in uu) the target should be to click on. This is actually implemented kind of crappily...

var() enum OverrideCursorType {
  OCT_NOOVERRIDE,
  OCT_FLASH,
} overrideCursor; //Whether or not to override the cursor while mousing over

var enum MouseEventType {
  MET_CLICK,
  MET_ENTER,
  MET_EXIT,
  MET_NONE,
} eventType;

var bool active;

var bool unflash;
var bool targetWasUnlit;

function tick(float d) {
  if (targetActor != none && highlightTarget && unflash) targetActor.bUnlit = targetWasUnlit;
  else unflash = true;
  super.tick(d);
}

function highlight() {
  if (targetActor == none) return;
  targetActor.bUnlit = true;
  unflash = false;
}

function postBeginPlay() {
  if (targetActor != none) targetWasUnlit = targetActor.bUnlit;
  super.postBeginPlay();
}

function trigger(Actor other, Pawn ei) {
  switch(onTrigger) {
    case TA_IGNORE:
      break;
    case TA_ENABLE:
      enabled = true;
      break;
    case TA_DISABLE:
      enabled = false;
      break;
    case TA_TOGGLE:
      enabled = !enabled;
      break; 
  }
}

defaultproperties
{
  highlightTarget=true
				Enabled=True
				maxFudge=16.0
				overrideCursor=OCT_FLASH
				Texture=Texture'Firetrucks.Icons.i_cea'
}
