//=============================================================================
// TextEvent2HUDOverlay: Abstract class for TextEvent2Overlays
//=============================================================================
class TextEvent2HUDOverlay extends HUDOverlay abstract;

function add(TextEvent2 textEvent2) {}

static final operator(16) color / (color c, int b) {
  return makeColor(c.r / b, c.g / b, c.b / b);
}

static final operator(16) color * (color c, float s) {
  return makeColor(max(0, min(255, c.r * s)), max(0, min(255, c.g * s)), max(0, min(255, c.b * s)));
}

static final operator(20) color - (color a, color b) {
  return makeColor(max(0, min(255, a.r - b.r)), max(0, min(255, a.g - b.g)), max(0, min(255, a.b - b.b)));
}

static final operator(20) color + (color a, color b) {
  return makeColor(max(0, min(255, a.r + b.r)), max(0, min(255, a.g + b.g)), max(0, min(255, a.b + b.b)));
}

simulated static function vector jitterErp(float alpha) {
  local vector v;
  v.x = (1.0 - alpha) * sin((alpha * 32.0) ** 2);
  v.y = (1.0 - alpha) * cos((alpha * 32.0) ** 2);
  return v;
}

simulated static function vector radialErp(float alpha) {
  local rotator r;
  r.yaw = alpha * 65535;
  return vect(1.0,0.0,0.0) >> r;
}