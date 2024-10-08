//=============================================================================
// PulsingJarvisUEAHUDOverlay: Draws a pulsing outline around the mesh
//=============================================================================
class PulsingJarvisUEAHUDOverlay extends UseEventAssociator2HUDOverlay;

struct Line {
  var vector start;
  var vector end;
};

var() float AnimScalar;
var() float vSizeCutoff; //cutoff between full size and reduced UI
var() Font smallUIFont; //font to use at unfairly small resolutions
var() Font fullUIFont; //font to use at reasonable resolutions

var float animAlpha;

var Font useFont;
var float edgeSpacing;
var bool smallUIMode;

event tick(float delta) {
  animAlpha += delta * animRate;
  if (animAlpha >= 1.0) animAlpha -= 1.0;
}

static final function vector chomp(vector a) {
  return makeVector(int(a.x), int(a.y), 16);
}

static final function vector averageVector(out array<vector> a, int length) {
  local float sumX, sumY, sumZ;
  local int i;
  for (i = 0; i < length; i++) {
    sumX += a[i].x;
    sumY += a[i].y;
    sumZ += a[i].z;
  }
  return makeVector(sumX/length,sumY/length,sumZ/length);
}

static final function int getVertsOfActorMesh(out Array<vector> rawPoints, Actor a) {
  a.allFrameVerts(rawPoints);
  return a.getVertexCount();
}

static final function bool isLeft(vector p, vector a, vector b) {
  return ((a.y - p.y) * (b.x - a.x) - (a.x - p.x) * (b.y - a.y)) < 0;
}

static final function int jarvis(out Array<vector> points, out Array<Line> lines, int length) { // length = length of points
  local int i, j;
  local vector current, next;
  // shamelessly borrowed from wikipedia

  current = points[0];
  for (i = 1; i < length; i++) if (points[i].x < current.x) current = points[i];
  i = 0;
  do {
    lines[i].start = current;
    next = points[0];
    for (j = 0; j < length; j++) {
      if (next == current || isLeft(points[j], current, next)) {
        next = points[j];
      }
    }
    lines[i].end = next;
    current = next;
    i++;
  } until (next == lines[0].start);
  return i;
}

static final function Array<vector> validate(Canvas canvas, Array<vector> points, out int pointCount) {
  local int validCount;
  local int i;
  local Array<Vector> validPoints;
  validCount = 0;
  for (i = 0; i < pointCount; i++) {
    if (points[i].x < canvas.clipx && points[i].x > 0 &&
        points[i].y < canvas.clipy && points[i].y > 0) {
      validPoints[validCount++] = points[i];
    }
  }
  pointCount = validCount;
  return validPoints;
}

simulated event drawUeaOverlay(Canvas canvas, float hudScale, UseEventAssociator2 UseEventAssociator2, optional float overrideAnimAlpha) {
  local Array<vector> points;
  local Array<vector> chomped;
  local Array<Line> lines;
  local vector average;
  local float alpha;
  local float z, xl, yl;
  local int pointCount, lineCount, i;
  local float hudScale2d;

   if (int(level.engineVersion) >= 227 && int(level.EngineSubVersion) > 10) {
    // 2d drawing functions are fixed in 227k so we don't need to scale them up
    hudScale2d = 1;
  } else hudScale2d = hudScale;

  if (overrideAnimAlpha > 0.0 && overrideAnimAlpha <= 1.0) alpha = overrideAnimAlpha;
  else alpha = animAlpha;

  if (canvas.clipy > vSizeCutoff) {
    useFont = fullUIFont;
    edgeSpacing = 8;
  } else {
    useFont = smallUIFont;
    edgeSpacing = 2;
  }

  if (UseEventAssociator2.getTarget().mesh == none) {
    // this needs a mesh to work
    return;
  }

  pointCount = getVertsOfActorMesh(points, UseEventAssociator2.getTarget());

  for (i = 0; i < pointCount; i++) {
    chomped[i] = chomp(canvas.worldToScreen(points[i] + UseEventAssociator2.UseOffset, z));
  }

  chomped = validate(canvas, chomped, pointCount);

  average = averageVector(chomped, pointCount);

  lineCount = jarvis(chomped, lines, pointCount);

  for (i = 0; i < lineCount; i++) {
    canvas.draw2dLine(UseEventAssociator2.UseColor / 2, (lines[i].start + normal(lines[i].start - average) * animScalar * edgeSpacing * sin(2 * PI * alpha)) * hudScale2d * hudScale2d,
      (lines[i].end + normal(lines[i].end - average) * animScalar * edgeSpacing  * sin(2 * PI * alpha)) * hudScale2d * hudScale2d);
  }

  for (i = 0; i < lineCount; i++) {
    canvas.draw2dLine(UseEventAssociator2.UseColor, lines[i].start * hudScale2d * hudScale2d, lines[i].end * hudScale2d * hudScale2d);
  }

  canvas.style = 1;
  canvas.font = useFont;
  canvas.drawColor = UseEventAssociator2.UseColor;
  canvas.strLen(UseEventAssociator2.UsePrompt $ ":", xl, yl);
  canvas.setPos(average.x - xl/2, average.y - yl - edgeSpacing/2);
  Class'FiretrucksHUD'.static.drawTextWithShadow(canvas, UseEventAssociator2.UsePrompt $ ":",, true);
  canvas.drawColor = makeColor(255,255,255);
  canvas.strLen(UseEventAssociator2.UseName, xl, yl);
  canvas.setPos(average.x - xl/2, average.y + edgeSpacing/2);
  Class'FiretrucksHUD'.static.drawTextWithShadow(canvas, UseEventAssociator2.UseName,, true);
  
  if (UseEventAssociator2.OptionalUseIcon != none) {
    canvas.style = UseEventAssociator2.UseIconRenderStyle;
    canvas.setPos(average.x - UseEventAssociator2.OptionalUseIcon.UClamp/2, average.y - UseEventAssociator2.OptionalUseIcon.VClamp - yl - edgeSpacing);
    canvas.DrawTileStretched(UseEventAssociator2.OptionalUseIcon,
      average.x - UseEventAssociator2.OptionalUseIcon.UClamp/2, average.y - UseEventAssociator2.OptionalUseIcon.VClamp - yl - edgeSpacing,
      average.x + UseEventAssociator2.OptionalUseIcon.UClamp/2, average.y - yl - edgeSpacing);
  }
}

defaultproperties {
  AnimRate=1.0;
  AnimScalar=2;
  vSizeCutoff=650
  smallUIFont=Font'WeedrowSmallFont'
  fullUIFont=Font'WeedrowFont'
  ReplicatorClass=Class'PulsingJarvisUeaHudOverlayReplicator'
}