//=============================================================================
// UseEventAssociator2: A usable object
//=============================================================================
class UseEventAssociator2 extends Triggers;

var() class<UseEventAssociator2HUDOverlay> HUDOverlay;
var() bool bEnabled;
var() bool bDisableAfterUse;
var() vector UseOffset;
var() Texture OptionalUseIcon;
var() ERenderStyle UseIconRenderStyle;
var() localized string UsePrompt;
var() localized string UseName;
var() color UseColor;
var() float UseDistance;
var() float UseMinDistance;
var() Actor OptionalTarget;

var() bool bUseBox;
var() vector UseBoxOffset;
var() vector UseBoxDimensions;

var transient UseEventAssociator2HUDOverlay hudOverlayInstance; // used by editor select render
var transient UseEventAssociator2ScriptHook scriptHook;
var UseEventAssociatorTargetDummy dummy;

replication {
  reliable if (Role == ROLE_Authority)
    getFitness, angleBetween, getBestFit, getTarget;
}


function Trigger(actor Other, pawn EventInstigator) {
  bEnabled = !bEnabled;
}

function tick(float delta) {
  // Although this will run on every UEA2, hooking tick() will prevent it from having multiple instances
  level.game.setHooksEnabled(true);
  scriptHook = new class'UseEventAssociator2ScriptHook';
  scriptHook.initialize();
}

simulated function Actor getTarget() {
  if (OptionalTarget.bDeleteMe) OptionalTarget = none;
  if (OptionalTarget != none) return OptionalTarget;
  else return self;
}

simulated function float angleBetween(PlayerPawn p) {
  local vector v, d;
  d = getTarget().location - p.CalcCameraLocation;
  v = vector(p.viewRotation);
  return acos((d dot v) / (vSize(d) * vSize(v)));
}

static function UseEventAssociator2 getBestFit(PlayerPawn playerPawn) {
  local UseEventAssociator2 useEventAssociator2, best;
  local float bestFit, currentFit;

  bestFit = -1;
  foreach playerPawn.allActors(Class'UseEventAssociator2', useEventAssociator2) {
    currentFit = useEventAssociator2.getFitness(playerPawn);
    if (currentFit > bestFit) {
      bestFit = currentFit;
      best = useEventAssociator2;
    }
  }

  if (bestFit > 0 && best != none) return best;
  else return none;
}

simulated static function bool isPointInsideBox(vector point, vector boxCenter, vector boxDimensions) {
  if (point.x > boxCenter.x + boxDimensions.x / 2) return false;
  if (point.x < boxCenter.x - boxDimensions.x / 2) return false;
  if (point.y > boxCenter.y + boxDimensions.y / 2) return false;
  if (point.y < boxCenter.y - boxDimensions.y / 2) return false;
  if (point.z > boxCenter.z + boxDimensions.z / 2) return false;
  if (point.z < boxCenter.z - boxDimensions.z / 2) return false;
  return true;
}

simulated function float getFitness(PlayerPawn playerPawn) {
  local vector v;
  local float f, angle;
  if (!bEnabled) return -1;
  if (bUseBox) {
    v = playerPawn.location - getTarget().location - UseOffset - UseBoxOffset;
    f = vSize(v);
    f = f / max(UseBoxDimensions.x, max(UseBoxDimensions.y, UseBoxDimensions.z));
    if (!isPointInsideBox(playerPawn.location, getTarget().location + UseOffset + UseBoxOffset, UseBoxDimensions)) return -1;
  } else {
    v = playerPawn.location - getTarget().location - UseOffset;
    f = vSize(v);
    if (f > UseDistance) return -1;
    if (f < UseMinDistance) return -1;
    f = f / UseDistance;
  }
  angle = angleBetween(playerPawn);
  if (angle > PI/2) return -1;
  return (PI/2 - angle)**(1.0-f);
}

event DrawEditorSelection(Canvas c) {
  if (hudOverlayInstance != none && hudOverlayInstance.class != HUDOverlay) hudOverlayInstance = none;
  if (hudOverlayInstance == none) hudOverlayInstance = new (self, '', RF_Transient) HUDOverlay;
  hudOverlayInstance.drawUeaOverlay(c, 1.0, self, fRand());

  if (bUseBox) {
    c.drawBox(UseColor, 2, getTarget().location + UseOffset + UseBoxOffset + UseBoxDimensions / 2, getTarget().location + UseOffset + UseBoxOffset - UseBoxDimensions / 2);
  }
}

defaultproperties {
  bUseBox=false
  UseBoxDimensions=(x=64,y=64,z=64)
  bCollideActors=true
  bEnabled=true
  bDisableAfterUse=false
  UsePrompt="Use"
  UseName="Macguffin"
  UseDistance=128
  OptionalUseIcon=Texture'i_use'
  UseIconRenderStyle=STY_Translucent
  HUDOverlay=Class'PulsingJarvisUEAHUDOverlay'
  UseColor=(R=255,G=255,B=0,A=255)
  Mesh=LodMesh'UnrealShare.WoodenBoxM'
  Texture=Texture'Firetrucks.Icons.i_useEvent'
  bHidden=true
  bNoDelete=true
  bEditorSelectRender=True
}