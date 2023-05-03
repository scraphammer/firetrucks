//=============================================================================
// PulsingBoxUEAHUDOverlay: Draws a pulsing box around the mesh
//=============================================================================
class PulsingBoxUEAHUDOverlay extends UseEventAssociator2HUDOverlay;

var() float DefaultBoxSize;
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

static final function int getVertsOfActorMesh(out array<vector> rawPoints, Actor a) {
  a.allFrameVerts(rawPoints);
  return a.getVertexCount();
}

simulated event drawUeaOverlay(Canvas canvas, UseEventAssociator2 UseEventAssociator2, optional float overrideAnimAlpha) {
  local Array<vector> points;
  local vector average, v;
  local float alpha;
  local float width, depth, height;
  local float minX, maxX, minY, maxY, minZ, maxZ;
  local float xl, yl;
  local int pointCount, i;

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
    // if the UEA has no mesh treat it as a (DefaultBoxSize * 2)^3 box
    pointCount = 8;
    width = DefaultBoxSize;
    depth = DefaultBoxSize;
    height = DefaultBoxSize;
    average = chomp(canvas.worldToScreen(UseEventAssociator2.getTarget().location));
  } else {
    pointCount = getVertsOfActorMesh(points, UseEventAssociator2.getTarget());
  
    // get min/max xyz for drawBox bounds, observing actor rotation too!
    minX = 3e38; minY = 3e38; minZ = 3e38;
    maxX = -3e38; maxY = -3e38; maxZ = -3e38;
    for (i = 0; i < pointCount; i++) {
      v = (points[i] - UseEventAssociator2.getTarget().location) << UseEventAssociator2.getTarget().rotation;
      if (v.x < minX) minX = v.x;
      if (v.y < minY) minY = v.y;
      if (v.z < minZ) minZ = v.z;
      if (v.x > maxX) maxX = v.x;
      if (v.y > maxY) maxY = v.y;
      if (v.z > maxZ) maxZ = v.z;
    }
    width = (maxX - minX) / 2;
    depth = (maxY - minY) / 2;
    height = (maxZ - minZ) / 2;
    average = chomp(canvas.worldToScreen(averageVector(points, pointCount)));
  }


  canvas.drawColor = UseEventAssociator2.UseColor / 2;
  drawBox(canvas, UseEventAssociator2.getTarget().location, width + animScalar * edgeSpacing * sin(2 * PI * alpha),
                                                            depth + animScalar * edgeSpacing * sin(2 * PI * alpha),
                                                            height + animScalar * edgeSpacing * sin(2 * PI * alpha),
                                                            edgeSpacing * 2, UseEventAssociator2.getTarget().rotation);
  canvas.drawColor = UseEventAssociator2.UseColor;
  drawBox(canvas, UseEventAssociator2.getTarget().location, width, depth, height, edgeSpacing * 2, UseEventAssociator2.getTarget().rotation);

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

static simulated function drawBox(Canvas canvas, vector location, float radius, float length, float height, float cornerSizeUU, optional rotator rotatr) {
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,length,height) >> rotatr), location + (makeVector(radius - cornerSizeUU,length,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,length,height) >> rotatr), location + (makeVector(radius,length - cornerSizeUU,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,length,height) >> rotatr), location + (makeVector(radius,length,height - cornerSizeUU) >> rotatr));

  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,length,-height) >> rotatr), location + (makeVector(radius - cornerSizeUU,length,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,length,-height) >> rotatr), location + (makeVector(radius,length - cornerSizeUU,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,length,-height) >> rotatr), location + (makeVector(radius,length,-height + cornerSizeUU) >> rotatr));

  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,length,height) >> rotatr), location + (makeVector(-radius + cornerSizeUU,length,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,length,height) >> rotatr), location + (makeVector(-radius,length - cornerSizeUU,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,length,height) >> rotatr), location + (makeVector(-radius,length,height - cornerSizeUU) >> rotatr));

  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,length,-height) >> rotatr), location + (makeVector(-radius + cornerSizeUU,length,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,length,-height) >> rotatr), location + (makeVector(-radius,length - cornerSizeUU,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,length,-height) >> rotatr), location + (makeVector(-radius,length,-height + cornerSizeUU) >> rotatr));

  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,-length,height) >> rotatr), location + (makeVector(radius - cornerSizeUU,-length,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,-length,height) >> rotatr), location + (makeVector(radius,-length + cornerSizeUU,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,-length,height) >> rotatr), location + (makeVector(radius,-length,height - cornerSizeUU) >> rotatr));

  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,-length,-height) >> rotatr), location + (makeVector(radius - cornerSizeUU,-length,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,-length,-height) >> rotatr), location + (makeVector(radius,-length + cornerSizeUU,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(radius,-length,-height) >> rotatr), location + (makeVector(radius,-length,-height + cornerSizeUU) >> rotatr));
                                                                                               
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,-length,height) >> rotatr), location + (makeVector(-radius + cornerSizeUU,-length,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,-length,height) >> rotatr), location + (makeVector(-radius,-length + cornerSizeUU,height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,-length,height) >> rotatr), location + (makeVector(-radius,-length,height - cornerSizeUU) >> rotatr));

  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,-length,-height) >> rotatr), location + (makeVector(-radius + cornerSizeUU,-length,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,-length,-height) >> rotatr), location + (makeVector(-radius,-length + cornerSizeUU,-height) >> rotatr));
  canvas.draw3dline(canvas.drawColor, location + (makeVector(-radius,-length,-height) >> rotatr), location + (makeVector(-radius,-length,-height + cornerSizeUU) >> rotatr));
}

defaultproperties {
  DefaultBoxSize=32;
  AnimRate=1.0;
  AnimScalar=0.25;
  vSizeCutoff=650
  smallUIFont=Font'WeedrowSmallFont'
  fullUIFont=Font'WeedrowFont'
  ReplicatorClass=Class'PulsingBoxUeaHudOverlayReplicator'
}