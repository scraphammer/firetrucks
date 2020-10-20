//=============================================================================
// FiretrucksHUD.
//=============================================================================
class FiretrucksHUD extends UnrealHUD;

/**
A new HUD class.
*/

#exec Font Import File=Textures\OllOutline.pcx Name=WeedrowSmallFont

#exec texture import file=Textures\TextEventShadow_0.pcx name=te_shadow1 group=UI mips=Off
#exec texture import file=Textures\TextEventShadow_1.pcx name=te_shadow2 group=UI mips=Off
#exec texture import file=Textures\TextEventShadow_2.pcx name=te_shadow3 group=UI mips=Off

#exec texture import file=Textures\UIDarkGrey.pcx name=ui_dg group=UI mips=Off
#exec texture import file=Textures\dggrad.pcx name=ui_dgrad group=UI mips=Off
#exec texture import file=Textures\dggrad2.pcx name=ui_dgrad2 group=UI mips=Off
#exec texture import file=Textures\ui_select.pcx name=ui_select group=UI mips=Off

#exec texture import file=Textures\firetruckscrosshair.pcx name=ui_crosshair group=UI mips=Off

#exec texture import name=ui_cursor file=Textures\ui_cursor.pcx group=UI mips=off flags=2
#exec texture import name=ui_cursor_flash file=Textures\ui_cursor_flash.pcx group=UI mips=off flags=2

#exec texture import name=ui_fhealth file=Textures\i_fhealth.pcx group=UI mips=off
#exec texture import name=ui_farmor file=Textures\i_farmor.pcx group=UI mips=off
#exec texture import name=ui_farmors file=Textures\i_farmors.pcx group=UI mips=off
#exec texture import name=ui_fammo file=Textures\i_fammo.pcx group=UI mips=off

var DialogueNode lastDN;
var() localized string clickMessage; //the message to be displayed when waiting for a click
var() localized string playerName; //The name of the player.
var() float invShowDelay; //Controls the behaviour of some UI elements.
var() Color accessoryColor; //Sets the color of some UI elements.
var() Color tertiaryColor; //Sets the color of some UI elements.
var() float vSizeCutoff; //cutoff between full size and reduced UI
var() Font smallUIFont; //font to use at unfairly small resolutions
var() Font fullUIFont; //font to use at reasonable resolutions
var() bool combatMode; //whether or not to EVER display combat information (health, weapons, ammo...)
var() Texture fCrosshair; //A special crosshair.
var() Texture cursor;
var() Texture cursorFlash;
var() Texture healthIndicator;
var() Texture armorIndicator;
var() Texture armorShieldIndicator;
var() Texture ammoIndicator;
var float edgeSpacing;
var string tes;

var float barHeight;
var float invHeight;
var Font useFont;
var bool smallUIMode;

var bool showBars;
var float barPosition;
var bool showInv;
var float invPosition;
var bool modifyTextEventBrightness;
var float textEventBrightnessMultiplier;
var bool showCombat;
var float combatPosition;
var bool increaseCharCount;
var int charCount;
var float sineResult;

var() float animationTime; //The time taken to complete most UI animations.
var() float charsPerSec; //How fast text scrolls;

var float sineRunning;
var float charRunning;
var float textEventTimer;
var bool showingTextEvent;

var localized string uiDeadString;

enum DialogueType {
   RT_AUTO,
   RT_CLICK,
   RT_CHOICE,
   RT_RITA_PLEASE_RESPOND
};

simulated function tick(float delta) {
  super.tick(delta);
  //set sine result
  sineResult = sin(sineRunning * 3);
  sineRunning += delta;
  if (sineRunning > PI * 2) sineRunning -= PI * 2;
  //bar position
  if (showBars && barPosition != 1) {
    barPosition += delta / animationTime;
    barPosition = fmin(1, barPosition);
  } else if (!showBars && barPosition != 0) {
    barPosition -= delta / animationTime;
    barPosition = fmax(0, barPosition);
  }
  //inv position
  if (showInv && invPosition != 1) {
    invPosition += delta / animationTime;
    invPosition = fmin(1, invPosition);
  } else if (!showInv && invPosition != 0) {
    invPosition -= delta / animationTime;
    invPosition = fmax(0, invPosition);
  }
  //combat position
  if (showCombat && combatPosition != 1) {
    combatPosition += delta / animationTime;
    combatPosition = fmin(1, combatPosition);
  } else if (!showCombat && combatPosition != 0) {
    combatPosition -= delta / animationTime;
    combatPosition = fmax(0, combatPosition);
  }
  //text event brightness
  if (modifyTextEventBrightness && textEventBrightnessMultiplier != 0) {
    textEventBrightnessMultiplier -= delta / animationTime;
    textEventBrightnessMultiplier = fmax(0, textEventBrightnessMultiplier);
  } else if (!modifyTextEventBrightness && textEventBrightnessMultiplier != 1) {
    textEventBrightnessMultiplier += delta / animationTime;
    textEventBrightnessMultiplier = fmin(1, textEventBrightnessMultiplier);
  }
  
  //char count
  if (increaseCharCount) {
    charcount += int(charRunning * charsPerSec);
    charRunning += delta;
  }
}

simulated function timer() {
  if (!showBars) showInv = true;
}

simulated function PostRender(canvas Canvas) {
  local FiretrucksPlayer p;
  local UseEventAssociator uea;
  local Inventory a;
  local Journal j;
  local float XL, YL;

  HUDSetup(canvas);
  
  //stock bits
  if (PlayerPawn(Owner) != None) {
    if (PlayerPawn(Owner).PlayerReplicationInfo == None) return;
  	
    if (PlayerPawn(Owner).bShowMenu) {
  		DisplayMenu(Canvas);
  		return;
    }
    
  	if ((PlayerPawn(Owner).Weapon != None) && (Level.LevelAction == LEVACT_None)) {
  		Canvas.Font = Font'WhiteFont';
  		PlayerPawn(Owner).Weapon.PostRender(Canvas);
  	}
  	
	  if (PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds) DisplayProgressMessage(Canvas);
  }
  
  if (FiretrucksPlayer(owner) != none) p = FiretrucksPlayer(owner);
  else return;
  
  //set font to use
  if (canvas.clipy > vSizeCutoff) {
    useFont = fullUIFont;
    edgeSpacing = 8;
  } else {
    useFont = smallUIFont;
    edgeSpacing = 2;
    smallUIMode = true;
  }
  
  //determine appropriate heights
  canvas.font = useFont;
  canvas.strLen("TEST!", XL, YL);
  barHeight = max(canvas.clipy / 6, (7 * YL) + edgeSpacing);
  
  invHeight = min(256, max(canvas.clipy / 12.5, 32));

  //pre-overlay
  firetrucksPreOverlay(canvas);
  
  //statics
  drawStatic(canvas);
  
  //draw black bars
  if (!p.cinematic) {
    showBars = false;
    showInv = true;
    showCombat = p.inCombatUI;
  } else {
    showBars = true;
    showInv = false;
    showCombat = false;
  }
  drawBlackBars(Canvas);
  
  if (lastDN != p.currentDN) {
    //wipeFrames = 0;
    charCount = 0;
  }

  //draw text event
  if (p.textEventString != "") {
    tes = p.textEventString;
    modifyTextEventBrightness = false;
  } else {
    modifyTextEventBrightness = true;
  }
  drawTextEventString(canvas, tes);
  
  //inventory
  drawWeedrowInventory(canvas);
  
  //display weapon and ammo indicators
  if (combatMode) {
    firetrucksHealth(canvas);
    firetrucksWeapons(canvas);
    firetrucksAmmo(canvas);
    firetrucksExtraCombatHUD(canvas);
  }
 
 if (!p.cinematic) {
    
    HUDSetup(canvas);
  	
    //display use target
    uea = p.checkTarget();
    if (uea != none) drawTarget(canvas, uea);
    else fCrosshair = default.fCrosshair;
    
    //display item triggers
    drawItemTriggers(canvas);
    
    //draw cross hair
    if (!p.pcaInput) firetrucksCrosshair(canvas);
    else {
      firetrucksCursor(canvas, p);
      firetrucksPCAText(canvas);
    }
  }
  

  //draw convo
  if (p.cinematic && p.currentDN != none) {
    lastDN = p.currentDN;
    drawConvo(canvas, p);
  } else if (!p.cinematic) {
    lastDN = none;
    charCount = 0;
    charRunning = 0;
  }
  
  // Draw Journal Icon and call to journal
	for (a = Owner.Inventory; a != None; a = a.Inventory) {
    if (Journal(a)!=None ) {
      j = Journal(a);
		  if(j.bActive) {
        j.drawJournal(canvas);
        break;
      }
		}
  }
  
  
  
  HUDSetup(canvas);
  
  // Message of the Day / Map Info Header
	if (MOTDFadeOutTime != 0.0) DrawMOTD(Canvas);  
}

simulated function firetrucksPCAText(Canvas c) {
  local PCAText pcat;
  local byte oldStyle;
  local Vector v;
  local float XL, YL, zd;
  oldStyle = c.style;
  c.style = 2;
  foreach allActors(class'PCAText', pcat) {
    if (!pcat.active) continue;
    else {
      v = c.worldToScreen(pcat.location, zd);
      if (v.z < 0) continue;
      c.strLen(pcat.text, xl, yl);
      c.setPos(v.x - (xl / 2), v.y - (yl / 2));
      drawTextWithShadow(c, pcat.text);
    }
  }
  c.style = oldStyle;
}

simulated function firetrucksCursor(Canvas c, FiretrucksPlayer fp) {
  local byte oldStyle;
  local MouseTriggers mt;
  local TooltipAssociator ta;
  local Texture t;
  oldStyle = c.style;

  c.style = 2;
  
  c.setPos(c.clipx / 2 + fp.pcaMouseX, c.clipy / 2 + fp.pcaMouseY);

  t = cursor;

  foreach allActors(class'MouseTriggers', mt) {
    if (!mt.active || !mt.enabled) continue;
    if (!fp.pcaTrace(c, mt)) continue;
    if (mt.overrideCursor == 1) t = cursorFlash;
    ta = TooltipAssociator(mt);
  }
  
  c.drawIcon(t, 1);

  if (ta != none) {
    c.setPos(c.clipx / 2 + fp.pcaMouseX + 32,
             c.clipy / 2 + fp.pcaMouseY);
    drawTextWithShadow(c, ta.tooltipString);
  }

  c.style = oldStyle;
}

simulated function firetrucksPreOverlay(Canvas c);

simulated function firetrucksHealth(Canvas c) {
  local PlayerPawn p;
  local int armorTotal;
  local Inventory i;
  local float xl, yl;
  local bool shielded;
  if (combatPosition == 0) return;
  p = PlayerPawn(owner);

  shielded = false;

  //[[health UI]]
  c.setPos(edgeSpacing - 64 * (1 - combatPosition), c.clipy - edgeSpacing - invHeight);
  if (p.health < p.default.health / 4) c.drawColor = makeColor(255, 0, 0);
  else c.drawColor = makeColor(180, 180, 180);
  c.style = 3;
  c.drawIcon(healthIndicator, 1);
  c.style = 2;
  c.strLen("TEST!", xl, yl);
  c.setPos(edgeSpacing * 2 + 32 - 64 * (1 - combatPosition), c.clipy - edgespacing - invHeight + 16 - yl/2);
  if (p.health > 0) drawTextWithShadow(c, p.health$"");
  else drawTextWithShadow(c, uiDeadString);
  
  //[[armor UI]]
  //determine total armor, return if 0

  armorTotal = 0;
  for (i = p.Inventory; i != none; i = i.Inventory) {
    if (i.bIsAnArmor) {
      armorTotal += i.charge;
      if (i.armorAbsorption >= 100) shielded = true;
    }
  }

  if (armorTotal == 0) return;

  c.setPos(edgeSpacing - 64 * (1 - combatPosition), c.clipy - edgeSpacing * 2 - 32 - invHeight);
  c.drawColor = makeColor(180, 180, 180);
  c.style = 3;
  if (shielded) c.drawIcon(armorShieldIndicator, 1);
  else c.drawIcon(armorIndicator, 1);
  c.style = 2;
  c.setPos(edgeSpacing * 2 + 32 - 64 * (1 - combatPosition), c.clipy - edgeSpacing * 2 - 32 - invHeight + 16 - yl/2);
  drawTextWithShadow (c, armorTotal$"");
}

simulated function firetrucksWeapons(Canvas c);

//[[AMMO]]
simulated function firetrucksAmmo(Canvas c) {
  local PlayerPawn p;
  local float xl, yl;
  if (combatPosition == 0) return;
  p = PlayerPawn(owner);
  if (p.weapon == none) return;
  
  c.setPos(c.clipX - edgespacing - 32 + 64 * (1 - combatPosition), c.clipy - edgeSpacing * 2 - 32 - invHeight);
  c.drawColor = makeColor(180, 180, 180);
  c.style = 3;
  c.drawIcon(AmmoIndicator, 1);
  c.style = 2;
  if (p.weapon.ammoType != none) c.strLen(p.weapon.ammoType.ammoAmount, xl, yl);
  else c.strLen("0", xl, yl);
  c.setPos(c.clipX - edgeSpacing * 2 - xl - 32 + 64 * (1 - combatPosition), c.clipy - edgeSpacing * 2 - 32 - invHeight + 16 - yl / 2);
  c.strLen(p.weapon.itemName, xl, yl);
  if (p.weapon.ammoType != none) drawTextWithShadow(c, p.weapon.ammoType.ammoAmount,, true);
  else drawTextWithShadow(c, "0",, true);
  c.setPos(c.clipX - edgeSpacing - xl + 64 * (1 - combatPosition), c.clipy - edgeSpacing - invHeight - yl / 2);
  drawTextWithShadow(c, p.weapon.itemName,, true);
}

simulated function firetrucksExtraCombatHUD(Canvas c);

simulated function firetrucksCrosshair(Canvas c) {
  local byte oldStyle;
  if (PlayerPawn(Owner) == none || Level.LevelAction != LEVACT_None || (PlayerPawn(Owner).Weapon != None && PlayerPawn(Owner).Weapon.bOwnsCrossHair)) return;
  oldStyle = c.style;
  if (fCrosshair == none) DrawCrossHair(c, 0.5 * c.ClipX - 8, 0.5 * c.ClipY - 8); 
  else {
    c.style = 3;
    c.setPos(0.5 * c.ClipX - 8, 0.5 * c.ClipY - 8);
    c.drawrect(fCrosshair, 16, 16);
  }
  c.style = oldStyle;
}

simulated function drawItemTriggers(Canvas c) {
  local ItemTrigger it;
  local string s;
  local bool b, a;
  local float xl, yl;
  
  c.font = useFont;
  
  foreach owner.TouchingActors(class'ItemTrigger', it) {
    if (!it.enabled) continue;
    a = true;
    if (it.onScreenNotification) {
      if (!b) b = true;
      else s $= ", ";
      s $= it.getUseName() $ ": " $ it.itemName;
    }
  }
  
  if (!a) return;
  
  c.drawColor = makeColor(127, 127, 127);
  c.strLen(s, xl, yl);
  c.setPos((c.clipx / 2) - (xl / 2), c.clipy - invHeight - yl * 2);
  c.drawText(s, false);
}

simulated function drawStatic(Canvas c) {
  local OverlayField of;
  local float q;
  local int color;
  local Texture t;
  foreach owner.TouchingActors(class'OverlayField', of) {
    if (of.gradualDistribution) q = (1 - ((vSizeSQ(owner.location - of.location)) / (of.sphereRadius * of.sphereRadius))) * of.alpha;
    else q = of.alpha;
    q *= 255.0;
    color = max(min(255, q), 0);
    c.drawColor = makeColor(color, color, color);
    c.style = 3;
    c.setPos(0, 0);
    t = of.overlayTexture;
    c.drawrect(t, c.clipx, c.clipy);
  }
}

static final function float VSizeSq(vector A) {
  return Square(A.X) + Square(A.Y) + Square(A.Z);
}

simulated function drawWeedrowInventory(Canvas c) {
  local Inventory i;
  local int iCount, charge;
  local FiretrucksPlayer p;
  local Translator t;
  local string s;
  local float offset, lenx, leny;
  
  if (invPosition == 0) {
    if (!showBars) setTimer(invShowDelay, false);
    return;
  }
  
  if (FiretrucksPlayer(owner) == none) return;
  p = FiretrucksPlayer(owner);
  
  if (p.inventory == none) return;
  
  for (i = p.inventory; i != none; i = i.inventory) {
    if (Translator(i) != none) t = Translator(i);
    if (i.bIsAnArmor && !i.bActivatable) continue;
    if (i.bDisplayableInv) iCount++;
  }
  
  //translator
  if (t != none && t.bCurrentlyActivated) {
    HUDSetup(c);
    t.DrawTranslator(c);
    HUDSetup(c);
  }
  
  //draw the items
  if (iCount == 0) return;
  if (iCount > 32) return; //problem case, fix later
  offset = (float(iCount) / 2.0) * invHeight;
  c.style = 2;
  c.strLen("TEST!", lenx, leny);
  for (i = p.inventory; i != none; i = i.inventory) {
    if (!i.bDisplayableInv) continue;
    if (i.bIsAnArmor && !i.bActivatable) continue;
    if (i == p.selectedItem) {
      c.drawColor = makeColor(0, 0, 0);
      c.setPos((c.clipx / 2) - offset - invHeight / 2 - edgeSpacing, c.clipy - (invHeight * invPosition) - 2 * edgeSpacing);
      c.drawrect(i.icon, invHeight + edgeSpacing * 2, invHeight + edgeSpacing * 2);
      c.drawColor = makeColor(255, 128, 128);
    } else c.drawColor = makeColor(255, 255, 255);
    c.setPos((c.clipx / 2) - offset - invHeight / 2, c.clipy - (invHeight * invPosition) - edgeSpacing);
    c.drawrect(i.icon, invHeight, invHeight);
    if (Pickup(i) != none && Pickup(i).bCanHaveMultipleCopies && Pickup(i).numCopies > 0) {
      c.drawColor = makeColor(255, 255, 255);
      c.font = useFont;
      s = (Pickup(i).numCopies + 1) $ "";
      c.strLen(s, lenx, leny);
      c.setPos((c.clipx / 2) - offset - (lenx/2), c.clipy - (invHeight * invPosition) - 3 * edgeSpacing - leny);
      drawTextWithShadow(c, s);
    } else if (i.charge > 0) {
      c.drawColor = makeColor(255, 255, 255);
      c.font = useFont;
      charge = int((float(i.charge) / float(i.default.charge)) * 100);
      s = charge$"%";
      c.strLen(s, lenx, leny);
      c.setPos((c.clipx / 2) - offset - (lenx/2), c.clipy - (invHeight * invPosition) - 3 * edgeSpacing - leny);
      drawTextWithShadow(c, s);
    }
    offset -= invHeight;
  }
}

simulated function drawTextEventString(Canvas c, string s) {
  local int color;
  local float xl, yl;
  
  if (textEventBrightnessMultiplier == 0) return;
  
  c.Font = useFont;
  color = max(0, min(255 * textEventBrightnessMultiplier, 255));
  c.strLen(" ("$s$") ", xl, yl);
  c.drawColor = makeColor(color, color, color);
  
  c.setPos((c.clipx / 2) - (xl / 2), c.clipy - barHeight - yl - edgeSpacing);
  
  drawTextWithShadow(c, " ("$s$") ");
}

simulated static function drawTextWithShadow(Canvas c, coerce string s, optional bool CR, optional bool clip) {
  local float xl, yl;
  local byte oldStyle;
  
  c.strLen(s, xl, yl);
  
  oldStyle = c.style;
  c.style = 4;
  
  c.drawrect(Texture'te_shadow1', yl / 2, yl);
  
  c.drawrect(Texture'te_shadow2', max(0, xl - yl), yl);
  
  c.drawrect(Texture'te_shadow3', yl / 2, yl);
  
  c.style = oldStyle;
  
  c.setPos(c.curX - xl, c.curY);
  if (!clip) c.drawText(s, CR);
  else c.drawTextClipped(s, CR);
}

simulated function drawTarget(Canvas c, UseEventAssociator uea) {
  local string s;
  local float len, yl;
  
  c.Font = useFont;
  c.drawColor = accessoryColor;
  
  s = uea.getUseName() $ ":";
  c.strLen(s, len, yl);
  c.setPos((c.clipx / 2) - (len / 2), (c.clipy / 2) + 32);
  drawTextWithShadow(c, s);
  
  c.drawColor = makeColor(255, 255, 255);
  s = uea.targetName;
  c.strLen(s, len, yl);
  c.setPos((c.clipx / 2) - (len / 2), (c.clipy / 2) + 32 + yl);
  drawTextWithShadow(c, s);
  
  fCrosshair = uea.getIcon();
}

simulated function drawBlackBars(Canvas c) {
  local Texture t;
  c.drawColor = makeColor(0, 0, 0);
  
  if (barPosition == 0) return;
  
  t = Texture'ui_dg';
  c.style = 4;
  
  c.setPos(0, 0 - barheight + barheight * barPosition);
  c.drawrect(t, c.clipx, barheight);
  c.setPos(0, barheight * barPosition);
  c.drawrect(Texture'ui_dgrad', c.clipx, 16);
  
  c.setPos(0, c.clipy - barheight + barheight * (1 - barPosition));
  c.drawrect(t, c.clipx, barheight);
  c.setPos(0, c.clipy - 16 - barheight + barheight * (1 - barPosition));
  c.drawrect(Texture'ui_dgrad2', c.clipx, 16);
  
  c.style = 2;
}

simulated function drawConvo(Canvas c, FiretrucksPlayer p) {
  local Texture t;
  local float clipx, clipy, xl, yl, ypos, blue;
  local int i, offset, tlen;
  local string s;
  t = Texture'ui_select';
  clipx = c.clipx;
  clipy = c.clipy;
  
  offset = 0;
  
  c.Font = useFont;
  c.style = 2;

  if (p.currentDN.responseType == RT_CHOICE && !p.choosing && p.didChoose) {
    tlen = len(p.currentDN.responses[p.selectedChoice].optionText);
  } else tlen = len(p.currentDN.prompt);
  
  if(charCount < tlen) increaseCharCount = true;
  else increaseCharCount = false;
  
  c.setPos(edgeSpacing, c.clipy - barHeight + edgeSpacing);
  
  c.drawColor = accessoryColor;
  
  if (p.currentDN.responseType == RT_CHOICE && !p.choosing && p.didChoose) s = playerName $ ": ";
  else s = p.currentDN.speakerName$": ";
  c.strLen(s, xl, yl);
  drawTextWithShadow(c, s, false);
  
  c.drawColor = makeColor(255, 255, 255);
  c.setPos(edgeSpacing + xl, c.clipy - barHeight + edgeSpacing);
  if (p.currentDN.responseType == RT_CHOICE && !p.choosing && p.didChoose) s = left(p.currentDN.responses[p.selectedChoice].optionText, charCount);
  else s = left(p.currentDN.prompt, charCount);
  drawTextWithShadow(c, s, false);
  
  //draw choices or click to continue
  ypos = 0;
  //c.setPos(32 + xl, c.clipy - (c.clipy / 6) + 48);
  if (p.isWaitingForClick) {
    blue = (sineResult + 1) * 0.25 + 0.25;
    c.drawColor = makeColor(max(0, min(255, int(blue * accessoryColor.r))), max(0, min(255, int(blue * accessoryColor.g))), max(0, min(255, int(blue * accessoryColor.b))));
    c.setPos(0, c.clipy - barHeight + edgeSpacing + yl * 2);
    c.drawrect(t, c.clipx, yl);
    c.drawColor = makeColor(255, 255, 255);
    c.setPos(edgeSpacing * 3, c.clipy - barHeight + edgeSpacing + yl * 2);
    //draw shadow
    drawTextWithShadow(c, clickMessage, false);
  } else if (p.choosing) {
    //render choices
    for (i = 0; i < 5; i++) {
      if (p.currentDN.responses[i].optionText != "") {
        if (p.selectedChoice == i) {
          blue = (sineResult + 1) * 0.25 + 0.25;
          c.drawColor = makeColor(max(0, min(255, int(blue * accessoryColor.r))), max(0, min(255, int(blue * accessoryColor.g))), max(0, min(255, int(blue * accessoryColor.b))));
          c.setPos(0, c.clipy - barHeight + edgeSpacing + yl * 2 + offset);
          c.drawrect(t, c.clipx, yl);
          //draw shadow
        }
        c.drawColor = makeColor(255, 255, 255);
        c.setPos(edgeSpacing * 3, c.clipy - barHeight + edgeSpacing + yl * 2 + offset);
        drawTextWithShadow(c, p.currentDN.responses[i].optionText, false);
        offset += yl;
      }
    }
  }
  
  c.clipx = clipx;
  c.clipy = clipy;
}

simulated function bool DisplayMessages(Canvas canvas) {
	local float XL, YL;
	local int I, J, YPos;
	local float PickupColor;
	local console Console;
	local MessageStruct ShortMessages[8];
	local string MessageString[8];
	local name MsgType;

	Console = PlayerPawn(Owner).Player.Console;

	Canvas.Font = useFont;

	if (!Console.Viewport.Actor.bShowMenu) DrawTypingPrompt(Canvas, Console);
		
	if (FiretrucksPlayer(Owner) != none && FiretrucksPlayer(Owner).cinematic) return true;

	if ((Console.TextLines > 0) && (!Console.Viewport.Actor.bShowMenu || Console.Viewport.Actor.bShowScores)) {
		MsgType = Console.GetMsgType(Console.TopLine);
		if (MsgType == 'Pickup') {
			Canvas.bCenter = true;
			if (Level.bHighDetailMode) Canvas.Style = ERenderStyle.STY_Translucent;
			else Canvas.Style = ERenderStyle.STY_Normal;
			PickupColor = 42.0 * FMin(6, Console.GetMsgTick(Console.TopLine));
			Canvas.DrawColor.r = PickupColor;
			Canvas.DrawColor.g = PickupColor;
			Canvas.DrawColor.b = PickupColor;
			Canvas.SetPos(4, Console.FrameY - 184);
			Canvas.DrawText( Console.GetMsgText(Console.TopLine), true );
			Canvas.bCenter = false;
			Canvas.Style = 1;
			J = Console.TopLine - 1;
		} 
		else if ((MsgType == 'CriticalEvent') || (MsgType == 'LowCriticalEvent') || (MsgType == 'RedCriticalEvent')) {
			Canvas.bCenter = true;
			Canvas.Style = 1;
			Canvas.DrawColor.r = 0;
			Canvas.DrawColor.g = 128;
			Canvas.DrawColor.b = 255;
			if (MsgType == 'CriticalEvent') Canvas.SetPos(0, Console.FrameY/2 - 32);
			else if (MsgType == 'LowCriticalEvent') Canvas.SetPos(0, Console.FrameY/2 + 32);
			else if (MsgType == 'RedCriticalEvent') {
				PickupColor = 42.0 * FMin(6, Console.GetMsgTick(Console.TopLine));
				Canvas.DrawColor.r = PickupColor;
				Canvas.DrawColor.g = 0;
				Canvas.DrawColor.b = 0;	
				Canvas.SetPos(4, Console.FrameY - 184);
			}

			Canvas.DrawText( Console.GetMsgText(Console.TopLine), true );
			Canvas.bCenter = false;
			J = Console.TopLine - 1;
		} 
		else J = Console.TopLine;

		I = 0;
		while ((I < 8) && (J >= 0)) {
			MsgType = Console.GetMsgType(J);
			if ((MsgType != '') && (MsgType != 'Log')) {
				MessageString[I] = Console.GetMsgText(J);
				if ((MessageString[I] != "") && (Console.GetMsgTick(J) > 0.0)) {
					if ((MsgType == 'Event') || (MsgType == 'DeathMessage')) {
						ShortMessages[I].PRI = None;
						ShortMessages[I].Type = MsgType;
						I++;
					} 
					else if ((MsgType == 'Say') || (MsgType == 'TeamSay')) {
						ShortMessages[I].PRI = Console.GetMsgPlayer(J);
						ShortMessages[I].Type = MsgType;
						I++;
					}
				}
			}
			J--;
		}

		J = 0;
		Canvas.Font = useFont;
		Canvas.StrLen("TEST", XL, YL );
		for (I=0; I<8; I++) if (MessageString[7 - I] != "") {
      YPos = edgeSpacing + YL * J;
      if (!DrawMessageHeader(Canvas, ShortMessages[7 - I], YPos)) {
        if (ShortMessages[7 - I].Type == 'DeathMessage') Canvas.DrawColor = RedColor;
        else {                     
          Canvas.DrawColor.r = 200;
          Canvas.DrawColor.g = 200;
          Canvas.DrawColor.b = 200;
        }                          
        Canvas.SetPos(edgeSpacing, YPos);
      }                            
      if (!SpecialType(ShortMessages[7 - I].Type)) {
        drawTextWithShadow(canvas, MessageString[7-I], false);
        J++;                       
      }
    }
  }
  return true;
}

simulated function DrawTypingPrompt(canvas Canvas, console Console) {
  local string TypingPrompt;
  local float XL, YL;

  if (Console.bTyping) {
    Canvas.DrawColor = accessoryColor;
    if( Console.TypingOffset>=0 && Console.TypingOffset<Len(Console.TypedStr) )
      TypingPrompt = "(> "$Left(Console.TypedStr,Console.TypingOffset)$"_"$Mid(Console.TypedStr,Console.TypingOffset);
    else TypingPrompt = "(> "$Console.TypedStr$"_";
    Canvas.Font = useFont;
    Canvas.StrLen( TypingPrompt, XL, YL );
    Canvas.SetPos( 2, Console.FrameY / 4);
    drawTextWithShadow(canvas, TypingPrompt);
    //Canvas.DrawText( TypingPrompt, false );
  }
}

defaultproperties {
  clickMessage="(Click or Use to continue!)"
  playerName="You"
  invShowDelay=0.5
  accessoryColor=(R=153,G=85,B=238)
  tertiaryColor=(R=255,G=127,B=255)
  vSizeCutoff=800
  smallUIFont=Font'WeedrowSmallFont'
  fullUIFont=Font'WeedrowFont'
  animationTime=0.75
  showBars=false
  showInv=true
  modifyTextEventBrightness=true
  charsPerSec=10
  combatMode=true
  fCrosshair=texture'ui_crosshair'
  cursor=ui_cursor
  cursorFlash=ui_cursor_flash
  healthIndicator=ui_fhealth
  ammoIndicator=ui_fammo
  armorIndicator=ui_farmor
  armorShieldIndicator=ui_farmors
  uiDeadString="DEAD"
}
