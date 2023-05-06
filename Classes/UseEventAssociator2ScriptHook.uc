class UseEventAssociator2ScriptHook extends ScriptHook;

function initialize() {
  SetHook(PlayerPawn.Grab, _grab);
  SetHook(class'UseEventAssociator2'.static.tick, _tick);
}

function bool _tick(UseEventAssociator2 uea2, float delta) {

  if (uea2.dummy == none) {
    uea2.dummy = uea2.spawn(class'UseEventAssociatorTargetDummy', uea2,,uea2.getTarget().location + uea2.UseOffset);
    uea2.dummy.setCollisionSize(uea2.UseDistance, uea2.UseDistance, true);
    uea2.dummy.uea2 = uea2;
  }

  return true; 
}

function bool _grab(PlayerPawn W) {
  local UseEventAssociator2 useEventAssociator2;

  useEventAssociator2 = Class'UseEventAssociator2'.static.getBestFit(W);

  if (useEventAssociator2) {
    if (useEventAssociator2.event != '') useEventAssociator2.triggerEvent(useEventAssociator2.event, useEventAssociator2, W);
    if (useEventAssociator2.bDisableAfterUse) useEventAssociator2.bEnabled = false;
  }

  return true;
}