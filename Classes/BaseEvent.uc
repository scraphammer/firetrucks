//=============================================================================
// BaseEvent.
//=============================================================================
class BaseEvent extends Triggers;

#exec texture import file=Textures\attachevent.pcx name=i_baseevent group=Icons mips=Off flags=2

/**
For those times when you need to attach something on the fly, or when an attachment is misbehaving
*/

var() bool forceTick; //Whether or not to enable tick() when triggered.
var() name childTag; //Optional tag of child Actor(s).
var() Actor child; //A direct reference to the child. Needed by tick(), but not trigger().
var() Actor parent; //A direct reference to the parent.
var() bool enableTick; //Whether or not tick() is enabled at the start.
var() editconst localized string warning; //"Tick() ignores childTag, must use child"

function tick(float delta) {
  super.tick(delta);
  if (enableTick || parent == none || child == none) return;
  child.setBase(parent);
}

function trigger(Actor other, Pawn eventInstigator) {
  local Actor a;
  if (parent == none) return;
  if (child != none) child.setBase(parent);
  
  if (childTag != '') foreach AllActors(class'Actor', a, childTag) {
    a.setBase(parent);
  }
  
  if (forceTick) enableTick = true;
}

defaultproperties
{
				Warning="Tick() ignores childTag, must use child"
				Texture=Texture'Firetrucks.Icons.i_baseevent'
}
