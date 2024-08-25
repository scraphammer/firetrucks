//=============================================================================
// Scaler. Adjusts draw scale of target actor(s). Optionall collision size too.
//=============================================================================
class Scaler extends Triggers;

#exec texture import file=Textures\iScaler.pcx name=i_ftscaler group=Icons flags=2 mips=off

var() name TargetTag; //The tag of the target actor(s).
var() vector DrawScaleToUse;
var() vector MinDrawScale;
var() vector MaxDrawScale;
var() bool bLimitDrawScale; // for ST_ADD and SET_MULTIPLY
var() enum ScalerType {
  ST_SET,
  ST_ADD,
  ST_MULTIPLY,
} ScaleType; //Controls how to scale the target(s)
var() enum HideTargetType {
  TT_TAG, //All actors matching tag
  TT_TARGET, //Direct Actor reference
  TT_PROTOTYPE, //All actors matching class
} TargetType; //Controls how this actor acquires its targets.
var() Actor ScaleTarget; //The exact target, if the targeting mode is set to use an exact target.
var() class<Actor> Prototype; //The class of actors to toggle, if set to that mode.

function Trigger(actor Other, pawn EventInstigator) {
  local Actor a;
  switch(targetType) {
    case TT_TAG:
      foreach allactors(class'Actor', a, targetTag) scaleMain(a);
      break;
    case TT_TARGET:
      scaleMain(ScaleTarget);
      break;
    case TT_PROTOTYPE:
      foreach allactors(protoType, a) scaleMain(a);
      break;
  }
  triggerEvent(event, other, eventInstigator);
}

function scaleMain(Actor a) {
  if (a != none) {
    switch(ScaleType) {
      case ST_SET:
        a.drawScale3D = DrawScaleToUse;
        break;
      case ST_ADD:
        a.drawScale3D.x = bLimitDrawScale ? fmax(fmin(a.drawScale3D.x + DrawScaleToUse.x, MaxDrawScale.x), MinDrawScale.x): a.drawScale3D.x + DrawScaleToUse.x;
        a.drawScale3D.y = bLimitDrawScale ? fmax(fmin(a.drawScale3D.y + DrawScaleToUse.y, MaxDrawScale.y), MinDrawScale.y): a.drawScale3D.y + DrawScaleToUse.y;
        a.drawScale3D.z = bLimitDrawScale ? fmax(fmin(a.drawScale3D.z + DrawScaleToUse.z, MaxDrawScale.z), MinDrawScale.z): a.drawScale3D.z + DrawScaleToUse.z;
        break;
      case ST_MULTIPLY:
        a.drawScale3D.x = bLimitDrawScale ? fmax(fmin(a.drawScale3D.x * DrawScaleToUse.x, MaxDrawScale.x), MinDrawScale.x): a.drawScale3D.x * DrawScaleToUse.x;
        a.drawScale3D.y = bLimitDrawScale ? fmax(fmin(a.drawScale3D.y * DrawScaleToUse.y, MaxDrawScale.y), MinDrawScale.y): a.drawScale3D.y * DrawScaleToUse.y;
        a.drawScale3D.z = bLimitDrawScale ? fmax(fmin(a.drawScale3D.z * DrawScaleToUse.z, MaxDrawScale.z), MinDrawScale.z): a.drawScale3D.z * DrawScaleToUse.z;
        break;
    }
  }
}

defaultproperties {
  DrawScaleToUse=(x=1,y=1,z=1)
  MinDrawScale=(x=0.5,y=0.5,z=0.5)
  MaxDrawScale=(x=2,y=2,z=2)
  ScaleType=ST_SET
  TargetType=TT_TARGET;
	Texture=Texture'Firetrucks.Icons.i_ftscaler'
}
