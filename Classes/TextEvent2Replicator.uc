//=============================================================================
// TextEvent2Replicator: If I had a dollar... well then I'd have a dollar.
//=============================================================================
class TextEvent2Replicator extends Inventory nousercreate;

replication {
  reliable if (Role == ROLE_Authority)
    giveToMyOwner;
}

simulated function giveToMyOwner(TextEvent2 textEvent2, String formatted) {
  local TextEvent2HUDOverlay hudOverlay;
  if (PlayerPawn(owner) == none) return;
  if (owner != none && PlayerPawn(owner).myHUD != none) {
    hudOverlay = TextEvent2HUDOverlay(PlayerPawn(owner).myHUD.addOverlay(textEvent2.textEventStyle, true));
    hudOverlay.add(textEvent2, formatted);
    if (textEvent2.audio != none) owner.PlaySound(textEvent2.audio, SLOT_None);
  }
}

defaultproperties {
  bAlwaysRelevant=true
  bDisplayableInv=false
	PickupMessage=""
}