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
    triggerEvent(t.event, Self, Instigator);
    owner.PlaySound(ActivateSound, SLOT_Misc);
    if (default.oneUse) {
      if (numCopies > 0) numCopies--;
      else destroy();
    }
    b = true;
  }
  
  if (!b) {
    triggerEvent(default.eventOnUse, Owner, Instigator);
  }
}

defaultproperties
{
  oneUse=True
  bCanHaveMultipleCopies=True
  bActivatable=True
  bDisplayableInv=True
}
