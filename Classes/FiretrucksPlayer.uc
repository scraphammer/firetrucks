//=============================================================================
// FiretrucksPlayer.
//=============================================================================
class FiretrucksPlayer extends FemaleOne; //to be fixed later

/**
A custom player class necessary for handling a lot of input related tasks.
*/

var bool acceptInput;
var bool cinematic;
var bool pcaInput;
var bool isWaitingForClick;
var bool didClick;
var bool didChoose;
var bool choosing;
var byte selectedChoice;
var bool switchready;
var bool forceWalking;
var DialogueNode currentDN;
var Journal j;
var string textEventString;
var Actor viewTargetController;
var float oldFOV;
var Attachment attachlist;
var SwordBack swordFX; //mfd

var bool inCombatUI;
var float pcaMouseX, pcaMouseY; //note - offset from center
var float pcaBoundsX, pcaBoundsY;

var bool queuePCAFire;

function setPCABounds(float x, float y) {
  pcaBoundsX = x;
  pcaBoundsY = y;
  boundMouse();
}

function boundMouse() {
  if (pcaMouseX * 2 > pcaBoundsX) pcaMouseX = pcaBoundsX / 2;
  else if (pcaMouseX * 2 + pcaBoundsX < 0) pcaMouseX = -pcaBoundsX / 2;
  if (pcaMouseY * 2 > pcaBoundsY) pcaMouseY = pcaBoundsY / 2;
  else if (pcaMouseY * 2 + pcaBoundsY < 0) pcaMouseY = -pcaBoundsY / 2;
}

function resetPCAPosition() {
  pcaMouseX = 0;
  pcaMouseY = 0;
}

function toggleCombatUI() {
  inCombatUI = !inCombatUI;
}

function setCombatUI(bool b) {
  inCombatUI = b;
}

function tick(float DeltaTime){
  super.tick(DeltaTime);
}

function PostBeginPlay() {
  super.postBeginPlay();
  log("pp desired fov "@desiredFOV);
  oldFOV = desiredFOV;
  enable('Tick');
}

function bool AddInventory(inventory NewItem) {
  local bool b;
  b = super.addInventory(newitem);
  if (b && Journal(newItem) != none) j = Journal(newItem);
  if (b && FiretrucksPickup(newItem) != none) addAttachment((FiretrucksPickup(newItem)).attachmentClass);
  return b;
}


function bool DeleteInventory(inventory Item) {
  local bool b;
  b = super.DeleteInventory(item);
  if (b && Journal(item) != none) j = none;
  if (b && FiretrucksPickup(item) != none) removeAttachment((FiretrucksPickup(item)).attachmentClass);
  return b;
}

function addAttachment(class<Attachment> attachmentClass) {
  local Attachment a;
  if (attachmentClass == none) return;
  a = spawn(attachmentClass, self);
  a.setBase(self);
  a.next = attachlist;
  attachlist = a;
}

event preRender(Canvas c) {
  local MouseTriggers mt;
  setPCABounds(c.clipx, c.clipy);
  foreach allActors(class'MouseTriggers', mt) {
    if (!mt.active || !mt.enabled) continue;
    if (!mt.highlightTarget) continue;
    if (mt.ignoreHiddenTarget && mt.targetActor != none &&
        mt.targetActor.bHidden) continue;
    if (pcaTrace(c, mt)) mt.highlight();
  }
  super.preRender(c);
}

event postRender(Canvas c) {
  local MouseEventAssociator mea;
  if (queuePCAFire) {
    foreach allActors(class'MouseEventAssociator', mea) {
      if (!mea.enabled) continue;
      if (!mea.active) continue;
      if (mea.targetActor == none) continue;
      if (mea.ignoreHiddenTarget && mea.targetActor.bHidden) continue;
      if (mea.eventType != 0) continue;
      if (pcaTrace(c, mea)) mea.fire(self);
    }
  }
  queuePCAFire = false;
  super.postRender(c);
}

function removeAttachment(class<Attachment> attachmentClass) {
  local Attachment a, prev;
  prev = none;
  if (attachmentClass == none) return;
  for (a = attachList; a != none; a = a.next) {
    if (a.class == attachmentClass) {
      if (prev == none) {
        attachlist = a.next;
      } else {
        prev.next = a.next;
      }
      a.destroy();
      break;
    }
    prev = a;
  }
}

simulated function dialogue(DialogueNode dn) {
    currentDN = dn;
}

// The player wants to active selected item
exec function ActivateItem() {
  local UseEventAssociator uea;
  if (cinematic) {
    if (currentDN != none && isWaitingForClick) {
      isWaitingForClick = false;
      currentDN.click();
    } else if (currentDN != none && choosing) {
      choosing = false;
      didChoose = true;
      currentDN.choose(selectedChoice);
    } else if (j != none && j.bActive == true) j.gotoState('Deactivated');
    return;
  }
  foreach allactors(class'UseEventAssociator', uea) if (uea.useTarget != none && (!uea.ignoreHiddenTarget || !uea.useTarget.bhidden) && uea.enabled && (vsizesq(location - uea.useTarget.location + uea.useOffset) < square(uea.useDistance))) {
    if (!uea.precise || angleBetween(uea.useTarget) < uea.precision) {
      uea.fire(self);
      return;
    }
  }
  
  super.activateItem();
}

simulated function float angleBetween(Actor a) {
  local vector v, d;
  d = a.location - location;
  v = vector(viewRotation);
  return acos((d dot v) / (vSize(d) * vSize(v)));
}

function UseEventAssociator CheckTarget() {
  local UseEventAssociator uea;
  if (!acceptInput) return none;
  foreach allactors(class'UseEventAssociator', uea) {
    if (uea.useTarget != none && (!uea.ignoreHiddenTarget || !uea.useTarget.bhidden) && uea.enabled && (vsizesq(location - uea.useTarget.location + uea.useOffset) < square(uea.useDistance)) && (!uea.precise || angleBetween(uea.useTarget) < uea.precision)) return uea;
  } 
  return none;
}

static final function float VSizeSq(vector A) {
  return Square(A.X) + Square(A.Y) + Square(A.Z);
}

simulated function choices(DialogueNode dn) {
    if (dn.responses[0].optionText != "") selectedChoice = 0;
    else if (dn.responses[1].optionText != "") selectedChoice = 1;
    else if (dn.responses[2].optionText != "") selectedChoice = 3;
    currentDN = dn;
    choosing = true;
    didChoose = false;
}

simulated function waitingForClick() {
  didClick = false;
  isWaitingForClick=true;
}

simulated function madeChoice(DialogueNode dn, byte b) {
    currentDN = dn;
}

simulated function textEvent(String s) {
  textEventString = s;
}

exec function nextWeapon() {
  if (j != none && j.bActive) j.mouseWheelUp();
  else if (acceptInput) super.nextWeapon();
  else if (choosing) {
    //next choice
    nextChoice();
  }
}

exec function prevWeapon() {
  if (j != none && j.bActive) j.mouseWheelDown();
  else if (acceptInput) super.prevWeapon();
  else if (choosing) {
    //prev choice
    prevChoice();
  }
}

simulated function nextChoice() {
  clientPlaySound(sound'upDown3');
  ncRecurse();
}

simulated function prevChoice() {
  clientPlaySound(sound'upDown3');
  pcrecurse();
}

simulated function ncrecurse() {
  if (selectedChoice == 4) selectedChoice = 0;
  else selectedChoice++;
  if (currentDN.responses[selectedChoice].optionText == "") ncrecurse();
}

simulated function pcrecurse() {
  if (selectedChoice == 0) selectedChoice = 4;
  else selectedChoice--;
  if (currentDN.responses[selectedChoice].optionText == "") pcrecurse();
}

// The player wants to fire.
//[[FIRE]]
exec function fire(optional float F) {
  if (acceptInput) Super.fire(f);
  else if (cinematic && currentDN == none) return;
  else if (cinematic && isWaitingForClick) {
    isWaitingForClick = false;
    currentDN.click();
  } else if (cinematic && choosing) {
    choosing = false;
    didChoose = true;
    currentDN.choose(selectedChoice);
  } else if (pcaInput) {
    queuePCAFire = true;
  }
}

//[[PCATRACE]]
simulated function bool pcaTrace(Canvas c, MouseTriggers mt, optional bool old, optional bool logg) {
  local float p, y, bx;
  local vector v, b;
  local Rotator r;
  if (mt.targetActor == none) return false;

  if (!old) {
    v = c.worldToScreen(mt.targetActor.location + mt.useOffset, y);
    if (v.z == -1) return false;
    b.x = mt.maxFudge;
    b.y = mt.maxFudge;
    b.z = mt.maxFudge;
    b = b + mt.targetActor.location + mt.useOffset;
    b = c.worldToScreen(b, y);
    //log(mt@"OSD v="@v@"b="@b@" mx="@pcaMouseX@"my="@pcaMouseY);
    bx = square(b.x - v.x) + square(b.x - v.x);
    p = square((pcaBoundsX / 2 + pcaMouseX) - v.x) +
        square((pcaBoundsY / 2 + pcaMouseY) - v.y);
    //log (mt@"bx="@bx@"p="@p);

    //c.drawCircle(myCanvas.makeColor(255, 255, 255), 2, mt.targetActor.location + mt.useOffSet, mt.maxFudge);
    return p <= bx;
  }

  bx = pcaBoundsX / pcaBoundsY;
  p = DesiredFov * -pcaMouseY / pcaBoundsY * 128;
  y = DesiredFov * pcaMouseX / pcaBoundsX * bx * 128;
  r.pitch = p;
  r.yaw = y;
  r.roll = 0;
  if (viewTarget == none) {
    v = location;
    r = r + viewRotation;
  } else {
    v = viewTarget.location;
    r = r + viewTarget.rotation;
  }
  v.z += eyeheight;
  return sphereLineCollision(v, r, mt.targetActor.location +
                             mt.useOffset, mt.maxFudge);
}

simulated static function bool SphereLineCollision(Vector start, 
    Rotator dir, Vector end, float radius) {
  local float result;
  result = (vector(dir) dot (start - end)) ** 2 -
           (start - end) dot (start - end) + 
           radius ** 2;
  return result >= 0;
}

exec function altFire(optional float F) {
  if (acceptInput) Super.altFire(f);
  else if (currentDN == none) return;
}

exec function Jump(optional float F){
  if (acceptInput) Super.jump(f);
  else if (currentDN == none) return;
  else if (isWaitingForClick) {
    isWaitingForClick = false;
    currentDN.click();
  } else if (choosing) {
    choosing = false;
    didChoose = true;
    currentDN.choose(selectedChoice);
  }
}

event playerInput(float DeltaTime) {
  local float st, smoothX, smoothY, absS, absI;

  //general ticking
  if (swordFX != none) swordFX.setBase(self);
  if (!cinematic) oldFOV = defaultFOV;

  if (acceptInput) {
    if (forceWalking) {
    	bWasForward = true;
    	bWasBack = true;
    	bWasLeft = true;
    	bWasRight = true;    
    }
    
    Super.playerInput(DeltaTime);
    return;
  }
  
  if (choosing && switchready) {
    if (aBaseY < 0 || aStrafe > 0) {
      clientPlaySound(sound'upDown3');
      ncRecurse();
    } else if (aBaseY > 0 || aStrafe < 0) {
      clientPlaySound(sound'upDown3');
      pcrecurse();
    }
    
    switchready = false;
    setTimer(0.075, false);
  }
  
  bEdgeForward = false;
  bEdgeBack = false;
  bEdgeLeft = false;
  bEdgeRight = false;
  bWasForward = true;
  bWasBack = true;
  bWasLeft = true;
  bWasRight = true;    
  aStrafe = 0;
  aTurn = 0;
  aForward = 0;
  aLookUp = 0;

  if (pcaInput) {
    if (!bMouseSmoothing) {
      pcaMouseX += aMouseX * 0.01 * MouseSensitivity;
      pcaMouseY -= aMouseY * 0.01 * MouseSensitivity;
    } else {
      st = FMin(0.2, 3 * deltaTime);

      if (aMouseX >= 0) smoothX = aMouseX;
      abss = abs(smoothX);
      absi = abs(aMouseX);
      if (abss < 0.85 * absi || abss > 1.17 * absi) {
        smoothX = 5 * st * aMouseX + (1 - 5 * st) * aMouseX;
      } else smoothX = st * aMouseX + (1 - st) * aMouseX;
      smoothX *= 0.01 * mouseSensitivity;
  
      if (aMouseY >= 0) smoothY = aMouseY;
      abss = abs(smoothY);
      absi = abs(aMouseY);
      if (abss < 0.85 * absi || abss > 1.17 * absi) {
        smoothY = 5 * st * aMouseY + (1 - 5 * st) * aMouseY;
      } else smoothY = st * aMouseY + (1 - st) * aMouseY;
      smoothY *= 0.01 * mouseSensitivity;

      pcaMouseX += smoothX;
      pcaMouseY -= smoothY;
    }
    boundMouse();
  }
}

function timer() {
  switchready = true;
}

function handleWalking() {
  if (!forceWalking) super.handleWalking();
  else bIsWalking = true;
}

function switchPlayerView(FiretrucksCamera cam, Actor a, optional bool PCA) {
  acceptInput = false;
  if (j != none && j.bActive) j.activate();
  if (PCA) {
    cinematic = false;
    pcaInput = true;
  } else {
    pcaInput = false;
    cinematic = true;
  }
  viewTargetController = a;
  viewTarget = cam;
  if (cam != none) setDesiredFOV(cam.FOV);
}

function restorePlayerView(Actor a, optional bool force) {
  if (force) {
    acceptInput = true;
    cinematic = false;
    pcaInput = false;
    resetPCAPosition();
    viewTarget = none;
    viewTargetController = none;
    accelRate = default.accelRate;
    rotationRate = default.rotationRate;
    setDesiredFOV(oldFOV);
    return;
  }
  if (a != viewTargetController) return;
  acceptInput = true;
  cinematic = false;
  pcaInput = false;
  resetPCAPosition();
  viewTarget = none;
  viewTargetController = none;
  accelRate = default.accelRate;
  rotationRate = default.rotationRate;
  setDesiredFOV(oldFOV);
}

defaultproperties {
    acceptInput=true
    cinematic=false
    pcaInput=false
    choosing=false
    isWaitingForClick=false
    switchready=true
    inCombatUI=false
}

