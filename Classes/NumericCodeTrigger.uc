//=============================================================================
// NumericCodeTrigger. For making digital keypads.
//=============================================================================
class NumericCodeTrigger extends MultiInputTriggers;

var(events) name DigitEvents[10];
var(events) name FailEvent;
var(events) name ResetEvent;
var(events) name SubmitEvent;

var() bool bEnabled;
var() bool bDisableAfterSuccess;
var() bool bAutoSubmit;
var() bool bRandom;
var() int Digits; // if bRandom this is how many digits to generate, otherwise this is the exact code

var bool initialized;

// TODO check that 227 doesn't have a built in for this

function initialize() {
  local name e;
  if (initialized) return;
  foreach DigitEvents(e) {
    spawn(class'MultiInputTriggerDummy', self, e,,); 
  }
  spawn(class'MultiInputTriggerDummy', self, FailEvent,,);
  spawn(class'MultiInputTriggerDummy', self, ResetEvent,,);
  spawn(class'MultiInputTriggerDummy', self, SubmitEvent,,);
  spawn(class'MultiInputTriggerDummy', self, SubmitEvent,,);
  initialized = true;
}

function DummyCallback(Actor other, Pawn eventInsitgator, name eventThatFired) {
  //todo
}

defaultproperties {
  bEnabled=true
  bRandom=true
  Digits=5
}