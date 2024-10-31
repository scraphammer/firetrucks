//=============================================================================
// InventoryChecker2: It checks a players inventory for a certain item and then
// may fire its event depending on specified properties.
//=============================================================================
class InventoryChecker2 extends Triggers;

/**
A full replacement of InventoryChecker. It can do more and is more intuitive to use. It checks a players inventory for a certain item and then may fire its event depending on whether or not it meets the conditions set in this actor's properties.
*/

var() class<Inventory> Prototype; //The class you'd liek to check for.
var() int Quantity; //The quantity you'd like to check for. Only matters if <span>checkType</span> is something other than CT_YES or CT_NO.
var() enum CheckTypeEnum {
  CT_YES,
  CT_NO,
  CT_GREATER,
  CT_GREATEREQUAL,
  CT_EQUAL,
  CT_LESS,
  CT_LESSEQUAL,
} CheckType; //CT_YES and CT_NO simply check if the player has (or does not have) an item. The others compare the quantity of said item to the <span>quantity</span> property.
var() bool bInstigatorOnly; // if true, it will only check the instigator.
var(Events) name EventOnFail;


function Trigger(actor Other, pawn EventInstigator) {
  local PlayerPawn pp;
  local inventory i;
  local int count;

  count = 0;

  if (bInstigatorOnly) {
      i = eventInstigator.inventory;
      while (i != none) {
        if (i.class == prototype) break;
        i = i.inventory;
      }
      if (i != none && i.class == prototype) {
        count += 1;
        if (Pickup(i) != none && Pickup(i).bCanHaveMultipleCopies) {
          count += Pickup(i).numCopies;
        }
      }
  } else {
    foreach allActors(class'PlayerPawn', pp) {
      //they don't think it be like it is but it do
      i = pp.inventory;
      while (i != none) {
        if (i.class == prototype) break;
        i = i.inventory;
      }
      if (i != none && i.class == prototype) {
        count += 1;
        if (Pickup(i) != none && Pickup(i).bCanHaveMultipleCopies) {
          count += Pickup(i).numCopies;
        }
      }
    }
  }

  switch(checkType) {
    case CT_YES:
      if (count > 0) {
        triggerEvent(event, other, eventInstigator);
        return;
      }
      break;
    case CT_NO:
      if (count == 0) {
        triggerEvent(event, other, eventInstigator);
        return;
      }
      break;
    case CT_GREATER:
      if (count > quantity) {
        triggerEvent(event, other, eventInstigator);
        return;
      }
      break;
    case CT_GREATEREQUAL:
      if (count >= quantity) {
        triggerEvent(event, other, eventInstigator);
        return;
      }
      break;
    case CT_EQUAL:
      if (count == quantity) {
        triggerEvent(event, other, eventInstigator);
        return;
      }
      break;
    case CT_LESSEQUAL:
      if (count <= quantity) {
        triggerEvent(event, other, eventInstigator);
        return;
      }
      break;
    case CT_LESS:
      if (count < quantity) {
        triggerEvent(event, other, eventInstigator);
        return;
      }
      break;
  }
  if (eventOnFail != '') triggerEvent(eventOnFail, other, eventInstigator);
}

defaultproperties {
  texture=Texture'i_checker'
}
