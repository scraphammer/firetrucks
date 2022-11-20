//=============================================================================
// EventQueue. A First-in-first-out queue of events that slowly drains.
//=============================================================================
class EventQueue expands MultiInputTriggers;

#exec texture import file=Textures\i_SlowFunnel.pcx name=i_SlowFunnel group=Icons mips=Off flags=2

var() bool bEnabled;
var() bool bDelayFirstEvent;
var() float DelayBetweenEvents;
var() map<name, name> EventMap;

struct S_QueuedFunnelEvent {
  var Actor other;
  var Pawn eventInstigator;
  var name eventThatFired;
};

var Array<S_QueuedFunnelEvent> eventQueue;
var int queueSize;
var bool ready;
var bool initialized;

function initialize() {
  local name e,t;
  if (initialized) return;
  foreach EventMap(e,t) {
    spawn(class'MultiInputTriggerDummy', self, e,,);
  }
  initialized = true;
}

function postBeginPlay() {
  if (!initialized) initialize();
}

function tick(float delta) {
  if (!initialized) initialize();
}

function Trigger(actor Other, pawn EventInstigator) {
  bEnabled = !bEnabled;

  if (ready && bEnabled && !bDelayFirstEvent) timer();
  else if (ready && bEnabled) setTimer(DelayBetweenEvents, false);

  if (event != '') triggerEvent(event, other, eventInstigator);
}

event timer() {
  local S_QueuedFunnelEvent eventFromQueue;
  local int i;
  if (bEnabled && queueSize > 0) {
    ready = false;
    foreach eventQueue(eventFromQueue, i) break;
    eventQueue.remove(0);
    queueSize--;
    triggerEvent(EventMap[eventFromQueue.eventThatFired], eventFromQueue.other, eventFromQueue.eventInstigator);
    setTimer(DelayBetweenEvents, false);
  } else {
    ready = true;
  }
}

static function S_QueuedFunnelEvent buildEventQueueEntry(Actor other, Pawn eventInstigator, name eventThatFired) {
  local S_QueuedFunnelEvent queuedEvent;
  queuedEvent.other = other;
  queuedEvent.eventInstigator = eventInstigator;
  queuedEvent.eventThatFired = eventThatFired;
  return queuedEvent;
}

function DummyCallback(Actor other, Pawn eventInsitgator, name eventThatFired) {
  eventQueue.add(buildEventQueueEntry(other, eventInsitgator, eventThatFired));
  queueSize++;

  if (ready && bEnabled && !bDelayFirstEvent) timer();
  else if (ready && bEnabled) setTimer(DelayBetweenEvents, false);
}

defaultproperties {
  bEnabled=true
  ready=true
  bDelayFirstEvent=true
  Texture=Texture'i_SlowFunnel'
  DelayBetweenEvents=1.000
}