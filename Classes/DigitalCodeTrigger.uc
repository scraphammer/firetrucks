//=============================================================================
// DigitalCodeTrigger. For making digital keypads.
//=============================================================================
class DigitalCodeTrigger extends MultiInputTriggers;

#exec texture import file=Textures\i_digitalCodeTrigger.pcx name=i_digitalCodeTrigger group=Icons mips=Off flags=2

/**
227 has a built-in code trigger but it's married to ElevatorMover and doesn't
have the ability to randomize it's code or integrate with KvStore.
 */

enum ECheckScope {
  CS_CASCADING,
  CS_GLOBAL,
  CS_PERSONAL,
};

struct DCT_Digit {
  var() editconst string digit;
  var() name DigitEvent;
};

var(KvStore) String KvStoreWriteKey;
var(KvStore) ECheckScope KvStoreReadScope;
var(KvStore) String KvStoreReadKey;
var(KvStore) bool bIgnoreCase;

var(events) editconst Array<DCT_Digit> Digits;
var(events) name FailEvent;
var(events) name ResetEvent;
var(events) name SubmitEvent;

var() bool bEnabled;
var() bool bDisableAfterSuccess;
var() bool bAutoSubmit;
var() bool bAutoReset;
var() String Code; // if KvStoreReadKey is set it will use that, otherwise this is the code (alphanumeric only pls!)

var string buffer;
var bool initialized;
var ASMD asmd;
var string kvStoreClassName;

static final postoperator bool NotBlank (name n) {
  return n != '';
}

static final postoperator bool NotBlank (String s) {
  return s != "";
}

function initialize() {
  local DCT_Digit digit;
  if (initialized) return;
  foreach Digits(digit) {
    log("spawning dummy for digit="$digit.digit$" if digit event is not blank?"@(digit.DigitEvent NotBlank));
    if (digit.DigitEvent NotBlank) spawn(class'MultiInputTriggerDummy', self, digit.DigitEvent,,); 
  }
  spawn(class'MultiInputTriggerDummy', self, ResetEvent,,);
  spawn(class'MultiInputTriggerDummy', self, SubmitEvent,,);
  asmd = new (outer) class'ASMD';
  initialized = true;
}

function postBeginPlay() {
  if (!initialized) initialize();
}

function tick(float delta) {
  if (!initialized) initialize();
}


state() OtherTriggerToggles {
  function Trigger(actor Other, pawn EventInstigator) {
    bEnabled = !bEnabled;
  }
}

state() OtherTriggerTurnsOff {
  function Trigger(actor Other, pawn EventInstigator) {
    bEnabled = false;
  }
}

state() OtherTriggerTurnsOn {
  function Trigger(actor Other, pawn EventInstigator) {
    bEnabled = true;
  }
}

function resetCode(actor Other, pawn EventInstigator) {
  buffer = "";
  writeBufferToKvs(other, eventInstigator);
}

function submit(actor Other, pawn EventInstigator) {
  local String codeToUse;

  codeTouse = getCodeToUse(other, EventInstigator);
  
  log("Sumission time! code entered:"@buffer@" codeToUse:"@codeToUse);

  if (buffer == codeToUse) {
    if (bDisableAfterSuccess) bEnabled = false;
    if (bAutoReset) resetCode(Other, EventInstigator);
    triggerEvent(event, Self, Instigator);
  } else {
    if (bAutoReset) resetCode(Other, EventInstigator);
    triggerEvent(FailEvent, Self, Instigator);
  }
}

function string getCodeToUse(actor Other, pawn EventInstigator) {
  local Class<Inventory> kvsClass;
  local Inventory inventory, kvs;
  local String codeToUse, codeFromKvs;

  codeTouse = code;

  if (KvStoreReadKey NotBlank) {
    kvsClass = class<Inventory>(DynamicLoadObject(kvStoreClassName, class'Class'));
    log("KvStoreReadKey is not blank, looking for kvs"@KvStoreReadKey);
    inventory = EventInstigator.inventory;
    while (inventory != none) {
      if (inventory.class == kvsClass) {
        kvs = inventory;
        break;
      }
      inventory = inventory.inventory;
    }
    if (kvs != none) {
      asmd.bIsAnArmor = false;
      asmd.autoSwitchPriority = KvStoreReadScope;
      asmd.bActivatable = bIgnoreCase;
      asmd.itemName = KvStoreReadKey;
      codeFromKvs = kvs.inventoryCapsString('', none, asmd);
      if (codeFromKvs NotBlank) codeToUse = codeFromKvs;
    }
  }

  return codeToUse;
}

function writeBufferToKvs(actor Other, pawn EventInstigator) {
  local Class<Inventory> kvsClass;
  local Inventory inventory, kvs;

  if (KvStoreWriteKey NotBlank) {
    kvsClass = class<Inventory>(DynamicLoadObject(kvStoreClassName, class'Class'));
    inventory = EventInstigator.inventory;
    while (inventory != none) {
      if (inventory.class == kvsClass) {
        kvs = inventory;
        break;
      }
      inventory = inventory.inventory;
    }
    if (kvs != none) {
      asmd.bIsAnArmor = true;
      asmd.autoSwitchPriority = 2;
      asmd.M_Activated = buffer;
      asmd.itemName = KvStoreWriteKey;
      kvs.inventoryCapsString('', none, asmd);
    }
  }
}

function DummyCallback(Actor other, Pawn EventInstigator, name eventThatFired) {
  local DCT_Digit digit;

  if (!bEnabled) return;

  if (eventThatFired == SubmitEvent) {
    submit(other, EventInstigator);
  } else if (eventThatFired == ResetEvent) {
    resetCode(other, EventInstigator);
  }

  foreach Digits(digit) {
    if (digit.DigitEvent NotBlank && digit.DigitEvent == eventThatFired) {
      buffer $= left(digit.digit, 1);
      log("event was a digit, new buffer is"@buffer);
      writeBufferToKvs(other, eventInstigator);
    }
  }

  if (bAutoSubmit && len(buffer) == len(getCodeToUse(other, EventInstigator))) {
    submit(other, EventInstigator);
  }
}

defaultproperties {
  Digits=((digit="0"),(digit="1"),(digit="2"),(digit="3"),(digit="4"),(digit="5"),(digit="6"),(digit="7"),(digit="8"),(digit="9"),(digit="a"),(digit="b"),(digit="c"),(digit="d"),(digit="e"),(digit="f"),(digit="g"),(digit="h"),(digit="i"),(digit="j"),(digit="k"),(digit="l"),(digit="m"),(digit="n"),(digit="o"),(digit="p"),(digit="q"),(digit="r"),(digit="s"),(digit="t"),(digit="u"),(digit="v"),(digit="w"),(digit="x"),(digit="y"),(digit="z"))
  bEnabled=true
  bDisableAfterSuccess=true;
  bAutoSubmit=true
  bAutoReset=true
  buffer=""
  Texture=Texture'i_digitalCodeTrigger'
  kvStoreClassName="KvStore.KvStore"
  KvStoreReadScope=CS_GLOBAL;
}