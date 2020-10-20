//=============================================================================
// InventoryModifier7.
//=============================================================================
class InventoryModifier7 extends Triggers;

//modifies inventory
//so good I didn't bother to write versions one through six

/**
A class for modifying the player's inventory. So good I didn't bother to write versions one through six.
*/

var() editconst bool buyFromBloblet; //NEVER do this!
var() enum ActionType {
    IM7_SPAWNITEM, //spawns the item
    IM7_DESTROYITEM, //destroys only the specified item
    IM7_DESTROYINVENTORY, //wipes the player's precious inventory
    IM7_DESTROYEVERYTHING //destroys ALL inventory in the level
} action; //How this inventory modifier should behave.
var() class<Inventory> prototype; //The class that should be spawned or destroyed.
var() int count; //The amount of the item to spawn or destroy.

function Trigger(actor Other, pawn EventInstigator) {
    local PlayerPawn p;
    local Inventory inv, inv2;

    switch(action) {
        case IM7_SPAWNITEM:
            if (prototype == none) return;
            foreach allactors(class'PlayerPawn', p) {
                inv = Spawn(prototype);
                if (count > 0 && Pickup(inv) != none && Pickup(inv).bCanHaveMultipleCopies) Pickup(inv).numCopies = count - 1;
                inv.touch(p);
            }
            break;
        case IM7_DESTROYITEM:
            if (prototype == none) return;
            foreach allactors(class'PlayerPawn', p) for (inv = p.inventory; inv != none; inv = inv2) {
                inv2 = inv.inventory;
                if (inv.class == prototype) {
                  if (count > 0 && Pickup(inv) != none && Pickup(inv).bCanHaveMultipleCopies) {
                    Pickup(inv).numCopies -= count;
                    if (Pickup(inv).numCopies < 0) inv.destroy();
                  } else inv.destroy();
                } 
            }
            break;
        case IM7_DESTROYINVENTORY:
            foreach allactors(class'PlayerPawn', p) for (inv = p.inventory; inv != none; inv = inv2) {
                inv2 = inv.inventory;
                inv.destroy();
            }
            break;
        case IM7_DESTROYEVERYTHING:
            foreach allactors(class'inventory', inv) inv.destroy();
            break;
    }
}

defaultproperties
{
				Texture=Texture'Engine.S_Inventory'
}
