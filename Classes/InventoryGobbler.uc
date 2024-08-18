//=============================================================================
// InventoryGobbler. This is probably not what you want to place in maps.
// You do you though. When picked up it gobbles up all inventory. Use a trigger
// to give it back.
//=============================================================================
class InventoryGobbler extends Inventory;

var() travel bool bRegenerate; //If destroyed it will make a copy of itself and give itself to the nearest PlayerPawn
var() travel Array<Class<Inventory> > Prototypes;
var() travel Array<Class<Inventory> > Excludes; //Don't gobble these items!

struct Gobbled {
  var travel String prototype;
  var travel int charge;
  var travel int numCopies;
};

var travel bool bIsEmpty;
var travel Array<Gobbled> gobbledInventory;


function Destroyed() {
  local InventoryGobbler gobbler;
  if (bRegenerate && !bIsEmpty) {
    gobbler = spawn(Class'InventoryGobbler');
  }
  super.destroyed();
}

function GiveTo(Pawn other) {
  local Inventory i;
  local Class<Inventory> prototype, exclude;
  local bool excluded;
  local Gobbled g;
  local Array<Inventory> toBeRemoved;
  foreach Prototypes(prototype) {
    foreach other.allInventory(prototype, i, false) {
      excluded = false;
      foreach Excludes(exclude) {
        if (i.class == exclude) {
          excluded = true;
          break;
        }
      }
      if (!excluded) {
        g.prototype = i.class$"";
        g.numCopies = (Pickup(i) != none) ? Pickup(i).numCopies : 1;
        g.charge = i.charge;
        gobbledInventory.add(g);
        toBeRemoved.add(i);
        bIsEmpty = false;
      }
    }
  }
  foreach toBeRemoved(i) other.deleteInventory(i);
  if (bIsEmpty) {
    destroy();
  } else {
    super.giveTo(other);
  }
}


function Activate() {
  local Gobbled g;
  local Class<Inventory> clazz;
  local Inventory i;
  if (PlayerPawn(owner) == none) return;
  foreach gobbledInventory(g) {
    clazz = class<Inventory>(DynamicLoadObject(g.protoType, class'Class'));
    if (clazz == none) {
      warn("invalid prototype stored in"@self@g.protoType);
      continue;
    }
    i = spawn(clazz);
    i.charge = g.charge;
    if (Pickup(i) != none) Pickup(i).numCopies = g.numCopies;
    i.touch(owner);
  }
  bIsEmpty = true;
  destroy();
}

auto state Pickup {
  function Touch(actor Other) {
    if (!ValidTouch(other)) {
      destroy();
    } else {
      super.touch(other);
    }
  }

  function tick(float delta) {
    local PlayerPawn p;
    foreach allactors(class'PlayerPawn', p) {
      touch(p);
      return;
    }
  }
}


defaultproperties {
  prototypes=(Class'Pickup',Class'Weapon')
  excludes=(Class'UnrealShare.Translator')
  bHidden=true
  bRegenerate=false
  bDisplayableInv=false
  Icon=Texture'S_inventory'
}