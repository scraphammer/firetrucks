//=============================================================================
// UseEventAssociator2HUDOverlayReplicator: Every 60 seconds, one minute passes.
//=============================================================================
class UseEventAssociator2HUDOverlayReplicator extends Inventory abstract;

replication {
  reliable if (Role == ROLE_Authority)
    giveToMyOwner, initialized;
}

var() Class<UseEventAssociator2HUDOverlay> hudOverlay;

var transient bool initialized;

function giveTo(Pawn other) {
  super.giveTo(other);
}

function tick(float delta) {
  if (!initialized && giveToMyOwner()) initialized = true;
}

simulated event RenderOverlays(Canvas canvas) {
  if (!initialized && giveToMyOwner()) initialized = true;
  super.RenderOverlays(canvas);
}

simulated function bool giveToMyOwner() {
  if (PlayerPawn(owner) == none) return true;
  if (owner != none && PlayerPawn(owner).myHUD != none) {
    PlayerPawn(owner).myHUD.addOverlay(hudOverlay, true);
    return true;
  } else return false;
}

defaultproperties {
  //bAlwaysRelevant=true
  bDisplayableInv=false
	PickupMessage=""
}