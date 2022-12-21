class UseEventAssociator2ScriptHook extends ScriptHook;

function initialize() {
  SetHook(PlayerPawn.Grab, _grab);
  SetHook(class'UseEventAssociator2'.static.tick, _tick);
}

function bool _tick(UseEventAssociator2 uea2, float delta) {
  local PlayerPawn playerPawn;
  local Inventory inventory;
  foreach uea2.allActors(Class'PlayerPawn', playerPawn) {
    inventory = playerPawn.inventory;
    while (inventory != none) {
      if (inventory.class == uea2.HUDOverlay.default.ReplicatorClass) break;
      inventory = inventory.inventory;
    }
    if (inventory == none) {
      inventory = playerPawn.spawn(uea2.HUDOverlay.default.ReplicatorClass, playerPawn);
      inventory.touch(playerPawn);
    }
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