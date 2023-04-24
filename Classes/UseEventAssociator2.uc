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
var() Actor OptionalTarget;

var transient UseEventAssociator2HUDOverlay hudOverlayInstance; // used by editor select render
var transient UseEventAssociator2ScriptHook scriptHook;

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
  d = getTarget().location - p.location;
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

simulated function float getFitness(PlayerPawn playerPawn) {
  local vector v;
  local float f, angle;
  if (!bEnabled) return -1;
  v = playerPawn.location - getTarget().location - UseOffset;
  f = vSize(v);
  if (f > UseDistance) return -1;
  f = f / UseDistance;
  angle = angleBetween(playerPawn);
  if (angle > PI/2) return -1;
  return f * (PI/2 - angle);
}

event DrawEditorSelection(Canvas c) {
  if (hudOverlayInstance != none && hudOverlayInstance.class != HUDOverlay) hudOverlayInstance = none;
  if (hudOverlayInstance == none) hudOverlayInstance = new (self, '', RF_Transient) HUDOverlay;
  hudOverlayInstance.drawUeaOverlay(c, self, fRand());
}

defaultproperties {
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