//=============================================================================
// UseEventAssociator2HUDOverlay: Abstract class for UEA2 HUD Overlays
//=============================================================================
class UseEventAssociator2HUDOverlay extends HUDOverlay abstract;

var() class<UseEventAssociator2HUDOverlayReplicator> ReplicatorClass;

// built-in vect doesn't work properly for some reason without literals, need to use this
static function vector makeVector(float x, float y, optional float z) {
  local vector v;
  v.x = x;
  v.y = y;
  v.z = z;
  return v;
}

static final operator(16) color / (color c, int b) {
  return makeColor(c.r / b, c.g / b, c.b / b);
}

simulated event postRender(Canvas canvas) {
  local UseEventAssociator2 useEventAssociator2;

  if (PlayerPawn(owner) == none) return;

  useEventAssociator2 = Class'UseEventAssociator2'.static.getBestFit(PlayerPawn(owner));

  if (useEventAssociator2 != none && useEventAssociator2.HUDOverlay == self.class) {
    canvas.pushCanvasScale(class'HUD'.default.HudScaler);
    drawUeaOverlay(canvas, useEventAssociator2);
    canvas.popCanvasScale();
  }
}

simulated event drawUeaOverlay(Canvas canvas, UseEventAssociator2 UseEventAssociator2, optional float overrideAnimAlpha) {
  //subclasses to implement
}