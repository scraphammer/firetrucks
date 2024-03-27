//=============================================================================
// NumericCodeTrigger. For making digital keypads.
//=============================================================================
class NumericCodeTrigger extends MultiInputTriggers;

/**
227 has a built-in code trigger but it's married to ElevatorMover and doesn't
have the ability to randomize it's code or integrate with KvStore.
 */

enum ECheckScope {
  CS_CASCADING,
  CS_GLOBAL,
  CS_PERSONAL,
};

var(KvStore) ECheckScope KvStoreWriteScope;
var(KvStore) String KvStoreWriteKey;
var(KvStore) ECheckScope KvStoreReadScope;
var(KvStore) String KvStoreReadKey;
var(KvStore) bool bIgnoreCase;

var(events) name DigitEvents[10];
var(events) name FailEvent;
var(events) name ResetEvent;
var(events) name SubmitEvent;

var() bool bEnabled;
var() bool bDisableAfterSuccess;
var() bool bAutoSubmit;
var() bool bRandom;
var() int Digits; // if bRandom this is how many digits to generate, otherwise this is the exact code

var string buffer;
var bool initialized;

static final postoperator bool NotBlank (name n) {
  return n != '';
}

static final postoperator bool NotBlank (String s) {
  return n != none && n != "";
}

function initialize() {
  local name e;
  local int i, newCode;
  if (initialized) return;
  foreach DigitEvents(e) {
    spawn(class'MultiInputTriggerDummy', self, e,,); 
  }
  spawn(class'MultiInputTriggerDummy', self, FailEvent,,);
  spawn(class'MultiInputTriggerDummy', self, ResetEvent,,);
  spawn(class'MultiInputTriggerDummy', self, SubmitEvent,,);
  spawn(class'MultiInputTriggerDummy', self, SubmitEvent,,);
  if (bRandom) {
    newCode = 0;
    for (i = 0; i < Digits; i++) {
      newCode = 10 * newCode + rand(10);
    }
    Digits = newCode;
  }
  if (KvStoreWriteKey NotBlank) {
    // TODO this needs to be in tick() because init is too soon
  }
  initialized = true;
}

function resetCode() {
  buffer = "";
}

function int getCode() {
  local string codeToUse;
  if (KvStoreReadKey NotBlank) {
    //todo
    // get code from kvstore, if it can be coerced to an int and isn't blank, return it
  }
  return Digits;
}

function DummyCallback(Actor other, Pawn eventInsitgator, name eventThatFired) {
  //todo
}

defaultproperties {
  bEnabled=true
  bRandom=true
  Digits=5
  buffer=""
}