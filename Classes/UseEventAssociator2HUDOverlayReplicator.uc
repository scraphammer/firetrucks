//=============================================================================
// UseEventAssociator2HUDOverlayReplicator: Every 60 seconds, one minute passes.
//=============================================================================
class UseEventAssociator2HUDOverlayReplicator extends Inventory abstract;

replication {
  reliable if (Role == ROLE_Authority)
    giveToMyOwner;
}

var() Class<UseEventAssociator2HUDOverlay> hudOverlay;

function touch(Actor other) {
  super.touch(other);
  giveToMyOwner();
}

function giveTo(Pawn other) {
  super.giveTo(other);
  giveToMyOwner();
}

simulated function bool giveToMyOwner() {
  if (PlayerPawn(owner) == none) return true;
  if (owner != none && PlayerPawn(owner).myHUD != none) {
    PlayerPawn(owner).myHUD.addOverlay(hudOverlay, true);
    return true;
  } else return false;
}

defaultproperties {
  bDisplayableInv=false
	PickupMessage=""
}