//=============================================================================
// PlainUeaHudOverlay: Doesn't draw any outline, just the text and icon.
//=============================================================================
class PlainUeaHudOverlay extends UseEventAssociator2HUDOverlay;

var() float vSizeCutoff; //cutoff between full size and reduced UI
var() Font smallUIFont; //font to use at unfairly small resolutions
var() Font fullUIFont; //font to use at reasonable resolutions

var Font useFont;
var float edgeSpacing;
var bool smallUIMode;

static final function vector chomp(vector a) {
  return makeVector(int(a.x), int(a.y), 16);
}

simulated event drawUeaOverlay(Canvas canvas, UseEventAssociator2 UseEventAssociator2, optional float overrideAnimAlpha) {
  local vector average;
  local float xl, yl;

  if (canvas.clipy > vSizeCutoff) {
    useFont = fullUIFont;
    edgeSpacing = 8;
  } else {
    useFont = smallUIFont;
    edgeSpacing = 2;
  }

  average = chomp(canvas.worldToScreen(UseEventAssociator2.location));

  canvas.style = 1;
  canvas.font = useFont;
  canvas.drawColor = UseEventAssociator2.UseColor;
  canvas.strLen(UseEventAssociator2.UsePrompt $ ":", xl, yl);
  canvas.setPos(average.x - xl/2, average.y - yl - edgeSpacing/2);
  Class'FiretrucksHUD'.static.drawTextWithShadow(canvas, UseEventAssociator2.UsePrompt $ ":");
  canvas.drawColor = makeColor(255,255,255);
  canvas.strLen(UseEventAssociator2.UseName, xl, yl);
  canvas.setPos(average.x - xl/2, average.y + edgeSpacing/2);
  Class'FiretrucksHUD'.static.drawTextWithShadow(canvas, UseEventAssociator2.UseName);
  
  if (UseEventAssociator2.OptionalUseIcon != none) {
    canvas.style = UseEventAssociator2.UseIconRenderStyle;
    canvas.setPos(average.x - UseEventAssociator2.OptionalUseIcon.UClamp/2, average.y - UseEventAssociator2.OptionalUseIcon.VClamp - yl - edgeSpacing);
    canvas.DrawTileStretched(UseEventAssociator2.OptionalUseIcon,
      average.x - UseEventAssociator2.OptionalUseIcon.UClamp/2, average.y - UseEventAssociator2.OptionalUseIcon.VClamp - yl - edgeSpacing,
      average.x + UseEventAssociator2.OptionalUseIcon.UClamp/2, average.y - yl - edgeSpacing);
  }
  
}

defaultproperties {
  vSizeCutoff=800
  smallUIFont=Font'WeedrowSmallFont'
  fullUIFont=Font'WeedrowFont'
  ReplicatorClass=Class'PlainUeaHudOverlayReplicator'
}