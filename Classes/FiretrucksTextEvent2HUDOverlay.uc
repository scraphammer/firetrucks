//=============================================================================
// FiretrucksTextEvent2HUDOverlay: A very basic HUD overlay for TextEvent2 that
// draws in the lower half of the screen, similar to the Firetrucks TextEvent.
//=============================================================================
class FiretrucksTextEvent2HUDOverlay extends TextEvent2HUDOverlay;

var int EVENT_QUEUE_SIZE;
var float animAlphas[6];
var TextEvent2 enqueuedTextEvents[6];

var float specialAnimAlpha;

var() float vSizeCutoff; //cutoff between full size and reduced UI

var() Font smallUIFont; //font to use at unfairly small resolutions or with the HUD scale cranked
var() Font fullUIFont; //font to use at reasonable resolutions

simulated function tick(float delta) {
  local int i;
  for (i = 0; i < EVENT_QUEUE_SIZE; i++) {
    animAlphas[i] += delta;
  }

  specialAnimAlpha += delta;
  if (specialAnimAlpha > 1.0) specialAnimAlpha -= 1.0;
}

function add(TextEvent2 textEvent2) {
  local TextEvent2 previous, swap;
  local float previousAlpha, swapAlpha;
  local int i;
  log("add called for"@owner@textEvent2@textEvent2.text);
  previousAlpha = 0;
  previous = textEvent2;
  for (i = 0; i < EVENT_QUEUE_SIZE; i++) {
    swap = enqueuedTextEvents[i];
    swapAlpha = animAlphas[i];
    enqueuedTextEvents[i] = previous;
    animAlphas[i] = previousAlpha;
    previous = swap;
    previousAlpha = swapAlpha;
    if (previous == none) break;
  }
}

simulated function bool isValid(int index) {
  if (index >= EVENT_QUEUE_SIZE) return false;
  if (index < 0) return false;
  if (enqueuedTextEvents[index] == none) return false;
  return animAlphas[index] < enqueuedTextEvents[index].fadeInTime + enqueuedTextEvents[index].fadeOutTime + enqueuedTextEvents[index].duration;
}

simulated static function drawTextWithShadow2(Canvas c, coerce string s, bool CR, bool clip, Texture icon, byte textStyle, color textColor, float animAlpha, float edgeSpacing) {
  local float xl, yl;
  local byte oldStyle;
  local color oldColor;
  local vector origin, animated;
  local string chopped;
  local int i, slen;
  
  c.strLen(s, xl, yl);

  if (icon != none) xl += yl;
  
  oldStyle = c.style;
  oldColor = c.drawColor;
  c.style = 4;
  
  c.drawrect(Texture'te_shadow1', yl / 2, yl);
  c.drawrect(Texture'te_shadow2', max(0, xl - yl), yl);
  c.drawrect(Texture'te_shadow3', yl / 2, yl);

  c.style = 1;
  c.setPos(c.curX - xl, c.curY);
  if (icon != none) c.drawrect(icon, yl, yl);
  if (textColor == makeColor(0,0,0)) textColor = makeColor(255,255,255);
  c.drawColor = textColor;
  switch (textStyle) {
    case 1:
      origin.x = c.curX;
      origin.y = c.curY;
      animated = jitterErp(animAlpha) * 4.5;
      c.setPos(c.curX + animated.x, c.curY + animated.y);
      if (!clip) c.drawText(s, CR);
      else c.drawTextClipped(s, CR);
      c.setPos(origin.x + XL, origin.y);
      break;
    case 2:
      slen = len(s);
      for (i = 0; i < slen; i++) {
        origin.x = c.curX;
        origin.y = c.curY;
        animated = radialErp(animAlpha + i * 0.05) * 0.35;
        chopped = mid(s, i, 1);
        c.strLen(chopped, XL, YL);
        c.setPos(c.curX + animated.x * edgeSpacing, c.curY + animated.y * edgeSpacing);
        if (!clip) c.drawText(chopped, CR);
        else c.drawTextClipped(chopped, CR);
        c.setPos(origin.x + XL, origin.y);
      }
      break;
    default: 
      if (!clip) c.drawText(s, CR);
      else c.drawTextClipped(s, CR);
      break;
  }
  c.drawColor = oldColor;
  c.style = oldStyle;
}

simulated event postRender(Canvas canvas) {
  local Font useFont;
  local float XL, YL;
  local float barHeight;
  local float textHeight;
  local float edgeSpacing;
  local float startVerticalOffset;
  local float animAlphaToUse;
  local color col;
  local int i, j;

  //set font to use
  if (canvas.clipy > vSizeCutoff) {
    useFont = fullUIFont;
    edgeSpacing = 8;
  } else {
    useFont = smallUIFont;
    edgeSpacing = 2;
  }
  
  //determine appropriate heights
  canvas.font = useFont;
  canvas.strLen("TEST!", XL, YL);
  barHeight = max(canvas.clipy / 6, ((EVENT_QUEUE_SIZE + 1) * YL) + edgeSpacing);
  textHeight = min(canvas.clipy / 32, YL + edgeSpacing);
  startVerticalOffset = canvas.clipy - (barHeight + edgeSpacing) - ((textHeight + edgeSpacing) * EVENT_QUEUE_SIZE);

  // draw any valid events
  for (i = 0; i < EVENT_QUEUE_SIZE; i++) {
    if (isValid(i)) {
      canvas.strLen(enqueuedTextEvents[i].text, XL, YL);
      if (enqueuedTextEvents[i].portrait != none) XL += YL;
      canvas.setPos((canvas.clipx / 2) - (XL / 2), startVerticalOffset + (textHeight + edgeSpacing) * j);
      switch (enqueuedTextEvents[i].getAnimation()) {
        case 1:
          col = enqueuedTextEvents[i].textColor;
          if (animAlphas[i] < enqueuedTextEvents[i].fadeInTime) animAlphaToUse = 1.0 - (animAlphas[i] / enqueuedTextEvents[i].fadeInTime);
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) animAlphaToUse = (animAlphas[i] - enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime;
          else animAlphaToUse = 1;
          break;
        case 2:
          if (animAlphas[i] < enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor * (animAlphas[i] / enqueuedTextEvents[i].fadeInTime);
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime));
          else col = enqueuedTextEvents[i].textColor;
          animAlphaToUse = specialAnimAlpha;
          break;
        default:
          if (animAlphas[i] < enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor * (animAlphas[i] / enqueuedTextEvents[i].fadeInTime);
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime));
          else col = enqueuedTextEvents[i].textColor;
          animAlphaToUse = animAlphas[i];
          break;
      }
      drawTextWithShadow2(canvas, enqueuedTextEvents[i].text, false, false, enqueuedTextEvents[i].portrait, enqueuedTextEvents[i].getAnimation(), col, animAlphaToUse, edgeSpacing);
      j++;
    } 
  }
}

defaultproperties {
  smallUIFont=Font'WeedrowSmallFont'
  fullUIFont=Font'WeedrowFont'
  vSizeCutoff=800
  EVENT_QUEUE_SIZE=6
}