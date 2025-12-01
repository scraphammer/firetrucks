//=============================================================================
// NandTrigger. Only triggers its event if the internal state is NOT bEnabled
//=============================================================================
class NandTrigger extends MultiInputTriggers;

#exec texture import file=Textures\i_nandTrigger.pcx name=i_nandTrigger group=Icons mips=Off flags=2

var(events) name Tag2; // tag that controls internal state
var(events) name EventOnDisabled; // If not enabled and is triggered, will fire this event instead
var() bool bEnabled;

var bool initialized;

function initialize() {
  if (initialized) return;
  spawn(class'MultiInputTriggerDummy', self, Tag2,,);
  initialized = true;
}

function postBeginPlay() {
  if (!initialized) initialize();
}

function tick(float delta) {
  if (!initialized) initialize();
} //UnTriggerEvent(Event,Other,Other.Instigator,TriggerLevelID);

function trigger(Actor other, Pawn eventInstigator) {
  if (!bEnabled && event != '') {
    triggerEvent(event, other, eventInstigator);
  } else if (EventOnDisabled != '') {
    triggerEvent(EventOnDisabled, other, eventInstigator);
  }
}

auto state() TriggerControl {
  function DummyCallback(Actor other, Pawn eventInstigator, name eventThatFired) {
    bEnabled = true;
  }

  function DummyUnCallback(Actor other, Pawn eventInstigator, name eventThatFired) {
    bEnabled = false;
  }
}

state() TriggerUnControl {
  function DummyCallback(Actor other, Pawn eventInstigator, name eventThatFired) {
    bEnabled = false;
  }

  function DummyUnCallback(Actor other, Pawn eventInstigator, name eventThatFired) {
    bEnabled = true;
  }
}

state() OtherTriggerTurnsOn {
  function DummyCallback(Actor other, Pawn eventInstigator, name eventThatFired) {
    bEnabled = true;
  }
}

state() OtherTriggerTurnsOff {
  function DummyCallback(Actor other, Pawn eventInstigator, name eventThatFired) {
    bEnabled = false;
  }
}

state TriggerToggle {
  function DummyCallback(Actor other, Pawn eventInstigator, name eventThatFired) {
    bEnabled = !bEnabled;
  }
}

defaultProperties {
  bEnabled=false
  Texture=Texture'i_nandTrigger'
}