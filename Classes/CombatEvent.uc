class CombatEvent extends Triggers;
/**
Toggles the combat UI for the FiretrucksHUD
*/

#exec texture import name=i_ce file=Textures\i_ce.pcx group=Icons flags=2 mips=off

var() enum TriggerAction {
  TA_ENABLE,
  TA_DISABLE,
  TA_TOGGLE
} onTrigger; //How this actor should behave when triggered

var() bool enabled; //Whether or not it is enabled
var() bool disableAfterUse; //should it disable itself after use?


function trigger(actor Other, pawn EventInstigator) {
  local FiretrucksPlayer fp;
  if (!enabled) return;

  foreach allActors(class'FiretrucksPlayer', fp) {
    switch (onTrigger) {
      case TA_ENABLE:
        fp.inCombatUI = true;
        break;
      case TA_DISABLE:
        fp.inCombatUI = false;
        break;
      case TA_TOGGLE:
        fp.inCombatUI = !fp.inCombatUI;
        break;
    }
  }

  if (disableAfterUse) enabled = false;
  if (event != '') triggerEvent(event, other, eventInstigator);
}

defaultproperties {
  enabled=true
  disableAfterUse=false
  texture=i_ce
}

