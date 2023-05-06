class UseEventAssociatorTargetDummy extends Actor nousercreate;

var UseEventAssociator2 uea2;

event touch(Actor other) {
  local Inventory i;
  if (uea2 == none) return;
  if (uea2.HUDOverlay == none) return;
  if (PlayerPawn(other) == none) return;
  i = PlayerPawn(other).inventory;

  while (i != none) {
    if (i.class == uea2.HUDOverlay.default.ReplicatorClass) return;
    i = i.inventory;
  }
  i = other.spawn(uea2.HUDOverlay.default.ReplicatorClass, other);
  i.touch(other);
  UseEventAssociator2HUDOverlayReplicator(i).giveToMyOwner();
}

defaultproperties {
  bHidden=true
  Texture=Texture'Firetrucks.Icons.i_AmbleZone'
  bCollideActors=true
}