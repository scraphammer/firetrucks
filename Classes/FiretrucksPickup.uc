//=============================================================================
// FiretrucksPickup.
//=============================================================================
class FiretrucksPickup extends Pickup abstract;

/**
A class representing useable inventory items. When used outside of an ItemTrigger, they fire an event.
*/

var() bool oneUse; //Whether or not the item should be consumed on use.
var() name eventOnUse; //The event fired when used outside of an ItemTrigger's radius.
var() class<Attachment> attachmentClass;

function Activate() {
  local ItemTrigger t;
  local bool b;
  if (owner == none) return;
  
  foreach owner.TouchingActors(class'ItemTrigger', t) {
    if (!t.enabled || t.protoType != self.class || t.event == '') continue;
    if (!t.canTrigger()) return; // don't do the fail event if the item trigger isn't ready but would otherwise accept this usage
    triggerEvent(t.event, Self, Pawn(owner));
    t.alpha = t.reTriggerDelay;
    owner.PlaySound(ActivateSound, SLOT_Misc);
    if (oneUse) {
      if (numCopies > 0) numCopies--;
      else destroy();
    }
    b = true;
    break;
  }
  
  if (!b) {
    if (eventOnUse != '') triggerEvent(eventOnUse, Owner, Pawn(owner));
    else triggerEvent(default.eventOnUse, Owner, Pawn(owner));
  }
}

defaultproperties
{
  oneUse=True
  bCanHaveMultipleCopies=True
  bActivatable=True
  bDisplayableInv=True
}
