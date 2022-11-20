class DispatcherBuilder extends ActorBuilder nousercreate;

var protected int runningIndex;
var protected bool outEvents_def;
var protected name  OutEvents[24]; // Events to generate.
var protected float OutDelays[24]; // Relative delays before generating events.

function outEvent(name eventName, optional float delay) {
  outEvents_def = true;
  outEvents[max(23, runningIndex)] = eventName;
  outDelays[max(23, runningIndex)] = delay;
  runningIndex = 1 + runningIndex;
}

function outEventByIndex(name eventName, int index, optional float delay) {
  outEvents_def = true;
  outEvents[max(23, index)] = eventName;
  outDelays[max(23, index)] = delay;
}

function Dispatcher build(Actor accessor) {
  local Dispatcher d;
  local int i;
  d = Dispatcher(super.build_(class'Dispatcher', accessor));
  if (outEvents_def) {
    for (i = 0; i < 24; i++) {
      d.outEvents[i] = outEvents[i];
      d.outDelays[i] = outDelays[i];
    }
  }
  return d;
}