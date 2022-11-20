//=============================================================================
// TextEvent2HUDOverlay: Abstract class for TextEvent2Overlays
//=============================================================================
class TextEvent2HUDOverlay extends HUDOverlay abstract;

function add(TextEvent2 textEvent2, String formatted) {}

static final operator(16) color / (color c, int b) {
  return makeColor(c.r / b, c.g / b, c.b / b);
}

static final function color invertColor(color c) {
  return makeColor(255 - c.r, 255 - c.g, 255 - c.b);
}

simulated static function vector jitterErp(float alpha) {
  /*local vector v;
  v.x = (1.0 - alpha) * sin((alpha * 32.0) ** 2);
  v.y = (1.0 - alpha) * cos((alpha * 32.0) ** 2);
  return v;*/
  return radialErp(fRand()) * (1 - alpha);
}

simulated static function vector radialErp(float alpha) {
  local rotator r;
  r.yaw = alpha * 65535;
  return vect(1.0,0.0,0.0) >> r;
}