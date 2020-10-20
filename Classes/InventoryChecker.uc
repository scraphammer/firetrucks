class InventoryChecker extends Triggers nousercreate;

#exec texture import file=Textures\InventoryChecker.pcx name=i_checker group=Icons mips=Off flags=2

/**
This class was deprecated in favor of the new and greater improved
InventoryChecker2. It continues to exist in its original state to allow for
backwards compatibility. Avoid using it in future endeavors!
*/

var() class<Inventory> prototype; //The Inventory class to look for.
var() bool not; //If true, fire its event if it doesn't find the item, instead of when it does.

function Trigger(actor Other, pawn EventInstigator) {
  local bool b;
  local PlayerPawn p;
  local Inventory i;
  if (not) b = true;
  else b = false;
  foreach AllActors(class'PlayerPawn', p) for (i = p.inventory; i != none; i = i.inventory) if (i.class == prototype) b = !b;
  if (b) triggerEvent(event, Self, Instigator);
}

