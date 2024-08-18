//=============================================================================
// InventoryUnpacker. Causes any InventoryGobbler to give back it's gobbled
// inventory.
//=============================================================================
class InventoryUnpacker extends Triggers;

#exec texture import file=Textures\blocc.pcx name=i_InventoryUnpacker group=Icons mips=Off flags=2

var() bool bInstigatorOnly;

function trigger(actor Other, pawn EventInstigator) {
  local InventoryGobbler ig;
  local PlayerPawn pp;
  if (bInstigatorOnly) {
    foreach EventInstigator.allInventory(Class'InventoryGobbler', ig, false) 
      ig.activate();
  } else {
    foreach allActors(Class'PlayerPawn', pp) 
      foreach EventInstigator.allInventory(Class'InventoryGobbler', ig, false) 
        ig.activate();
  }

  if (event != '') triggerEvent(event, other, eventInstigator);
}

defaultproperties {
  bInstigatorOnly=true
  Texture=Texture'Firetrucks.Icons.i_InventoryUnpacker'
}
