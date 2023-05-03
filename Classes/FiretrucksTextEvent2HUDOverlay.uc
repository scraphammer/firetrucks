//=============================================================================
// FiretrucksTextEvent2HUDOverlay: A very basic HUD overlay for TextEvent2 that
// draws in the lower half of the screen, similar to the Firetrucks TextEvent.
//=============================================================================
class FiretrucksTextEvent2HUDOverlay extends TextEvent2HUDOverlay;

#exec Font Import File=Textures\WeedrowFontItalic.pcx Name=WeedrowFontItalic

#exec texture import file=Textures\TextEventShadow_0inverted.pcx name=te_shadow1inverted group=UI mips=Off
#exec texture import file=Textures\TextEventShadow_1inverted.pcx name=te_shadow2inverted group=UI mips=Off
#exec texture import file=Textures\TextEventShadow_2inverted.pcx name=te_shadow3inverted group=UI mips=Off

var color PURE_WHITE;
var int EVENT_QUEUE_SIZE;
var float animAlphas[6];
var TextEvent2 enqueuedTextEvents[6];
var string enqueuedTextCache[6];

var float specialAnimAlpha;

var() int minBrightness;
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

function add(TextEvent2 textEvent2, String formatted) {
  local TextEvent2 previous, swap;
  local float previousAlpha, swapAlpha;
  local string previousText, swapText;
  local int i;
  previousAlpha = 0;
  previous = textEvent2;
  previousText = formatted;
  for (i = 0; i < EVENT_QUEUE_SIZE; i++) {
    swap = enqueuedTextEvents[i];
    swapAlpha = animAlphas[i];
    swapText = enqueuedTextCache[i];
    enqueuedTextCache[i] = previousText;
    enqueuedTextEvents[i] = previous;
    animAlphas[i] = previousAlpha;
    previous = swap;
    previousAlpha = swapAlpha;
    previousText = swapText;
    if (previous == none) break;
  }
}

simulated function bool isValid(int index) {
  if (index >= EVENT_QUEUE_SIZE) return false;
  if (index < 0) return false;
  if (enqueuedTextEvents[index] == none) return false;
  return animAlphas[index] < enqueuedTextEvents[index].fadeInTime + enqueuedTextEvents[index].fadeOutTime + enqueuedTextEvents[index].duration;
}

simulated static function drawTextWithShadow2(Canvas c, coerce string s, bool CR, bool clip, Texture icon, byte textStyle, color textColor, float animAlpha, float edgeSpacing, bool darkMode, optional float fadeInTime) {
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

  if (fadeInTime == 0) fadeInTime = 1;

  if (darkMode) {
    c.drawrect(Texture'te_shadow1', yl / 2, yl);
    c.drawrect(Texture'te_shadow2', max(0, xl - yl), yl);
    c.drawrect(Texture'te_shadow3', yl / 2, yl);
  } else {
    origin.x = c.curX;
    origin.y = c.curY;
    c.drawrect(Texture'te_shadow1inverted', yl / 2, yl);
    c.drawrect(Texture'te_shadow2inverted', max(0, xl - yl), yl);
    c.drawrect(Texture'te_shadow3inverted', yl / 2, yl);
    c.setPos(origin.x, origin.y);
    c.drawrect(Texture'te_shadow1inverted', yl / 2, yl);
    c.drawrect(Texture'te_shadow2inverted', max(0, xl - yl), yl);
    c.drawrect(Texture'te_shadow3inverted', yl / 2, yl);
  }

  c.style = 1;
  c.setPos(c.curX - xl, c.curY);
  if (icon != none) c.drawrect(icon, yl, yl);
  c.drawColor = textColor;
  switch (textStyle) {
    case 1: // ANIM_Alert
      origin.x = c.curX;
      origin.y = c.curY;
      animated = jitterErp(animAlpha) * 5.5;
      c.setPos(c.curX + animated.x, c.curY + animated.y);
      if (!clip) c.drawText(s, CR);
      else c.drawTextClipped(s, CR);
      c.setPos(origin.x + XL, origin.y);
      break;
    case 2: // ANIM_Wavy
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
    case 3: // ANIM_WipeInFadeOut
      slen = len(s);
      chopped = mid(s, 0, fmin(1, (animAlpha / fadeInTime)) * slen);
      if (!clip) c.drawText(s, CR);
      else c.drawTextClipped(s, CR);
      break;
    case 4: // ANIM_Shaky
      slen = len(s);
      for (i = 0; i < fmin(1, (animAlpha / fadeInTime)) * slen; i++) {
        origin.x = c.curX;
        origin.y = c.curY;
        animated = jitterErp(0.975);
        chopped = mid(s, i, 1);
        c.strLen(chopped, XL, YL);
        c.setPos(c.curX + animated.x * edgeSpacing, c.curY + animated.y * edgeSpacing);
        if (!clip) c.drawText(chopped, CR);
        else c.drawTextClipped(chopped, CR);
        c.setPos(origin.x + XL, origin.y);
      }
      break;
    default: // ANIM_Default and anything else not in the above
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
  local int brightness;
  local color col;
  local int i, j;
  local bool darkMode;

  canvas.pushCanvasScale(class'HUD'.default.HudScaler);

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
      if (enqueuedTextEvents[i].overrideFont != none) canvas.font = enqueuedTextEvents[i].overrideFont;
      else canvas.font = useFont;
      canvas.strLen(enqueuedTextCache[i], XL, YL);
      if (enqueuedTextEvents[i].portrait != none) XL += YL;
      canvas.setPos((canvas.clipx / 2) - (XL / 2), startVerticalOffset + (textHeight + edgeSpacing) * j);
      brightness = max(enqueuedTextEvents[i].textColor.r, max(enqueuedTextEvents[i].textColor.g, enqueuedTextEvents[i].textColor.b));
      darkMode = brightness >= minBrightness;
      switch (enqueuedTextEvents[i].getAnimation()) {
        case 1: // ANIM_Alert
          col = enqueuedTextEvents[i].textColor;
          if (animAlphas[i] < enqueuedTextEvents[i].fadeInTime) animAlphaToUse = animAlphas[i] / enqueuedTextEvents[i].fadeInTime;
          else animAlphaToUse = 1;
          if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime && darkMode) col = enqueuedTextEvents[i].textColor * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeInTime));
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor + invertColor(enqueuedTextEvents[i].textColor) * ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeInTime);
          else col = enqueuedTextEvents[i].textColor;
          break;
        case 2: // ANIM_Wavy
          if (animAlphas[i] < enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor * (animAlphas[i] / enqueuedTextEvents[i].fadeInTime);
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime));
          else col = enqueuedTextEvents[i].textColor;
          animAlphaToUse = animAlphas[i];
          break;
        case 3: // ANIM_WipeInFadeOut
          if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime && darkMode) col = enqueuedTextEvents[i].textColor * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime));
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor + invertColor(enqueuedTextEvents[i].textColor) * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime));
          else col = enqueuedTextEvents[i].textColor;
          animAlphaToUse = animAlphas[i];
          break;
        case 4: // ANIM_Shaky
          if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime && darkMode) col = enqueuedTextEvents[i].textColor * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime));
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor + invertColor(enqueuedTextEvents[i].textColor) * ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime);
          else col = enqueuedTextEvents[i].textColor;
          animAlphaToUse = animAlphas[i];
          break;
        default:
          if (animAlphas[i] < enqueuedTextEvents[i].fadeInTime && darkMode) col = enqueuedTextEvents[i].textColor * (animAlphas[i] / enqueuedTextEvents[i].fadeInTime);
          else if (animAlphas[i] < enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor + invertColor(enqueuedTextEvents[i].textColor) * (1.0 - (animAlphas[i] / enqueuedTextEvents[i].fadeInTime));
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime && darkMode) col = enqueuedTextEvents[i].textColor * (1 - ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime));
          else if (animAlphas[i] > enqueuedTextEvents[i].duration + enqueuedTextEvents[i].fadeInTime) col = enqueuedTextEvents[i].textColor + invertColor(enqueuedTextEvents[i].textColor) * ((animAlphas[i] - enqueuedTextEvents[i].duration - enqueuedTextEvents[i].fadeInTime) / enqueuedTextEvents[i].fadeOutTime);
          else col = enqueuedTextEvents[i].textColor;
          animAlphaToUse = animAlphas[i];
          break;
      }
      drawTextWithShadow2(canvas, enqueuedTextCache[i], false, false, enqueuedTextEvents[i].portrait, enqueuedTextEvents[i].getAnimation(), col, animAlphaToUse, edgeSpacing, darkMode, enqueuedTextEvents[i].fadeInTime);
      j++;
    } 
  }

  canvas.popCanvasScale();
}

defaultproperties {
  smallUIFont=Font'WeedrowSmallFont'
  fullUIFont=Font'WeedrowFont'
  vSizeCutoff=650
  EVENT_QUEUE_SIZE=6
  minBrightness=64
  PURE_WHITE=(R=255,G=255,B=255,A=255)
}