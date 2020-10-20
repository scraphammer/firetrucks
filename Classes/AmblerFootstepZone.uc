//=============================================================================
// AmblerFootstepZone
//=============================================================================
class AmblerFootstepZone extends FiretrucksFootstepZone;

#exec TEXTURE IMPORT FILE="Textures\amblezone.pcx" NAME="i_AmbleZone" GROUP="Icons" MIPS=Off FLAGS=2

/**
A zone that forces the player to walk.
*/

var() bool enabled; //Controls whether or not this zone is enabled. It can be triggered to be disabled.

event actorEntered(Actor other) {
  if (enabled && FiretrucksPlayer(other) != none) FiretrucksPlayer(other).forceWalking = true;
}

event actorLeaving(Actor other) {
  if (enabled && FiretrucksPlayer(other) != none) FiretrucksPlayer(other).forceWalking = false;
}

function Trigger(actor Other, pawn EventInstigator) {
  local FiretrucksPlayer p;
  if (enabled) foreach zoneActors(class'FiretrucksPlayer', p) p.forceWalking = false;
  else foreach zoneActors(class'FiretrucksPlayer', p) p.forceWalking = true;
  enabled = !enabled;
}

defaultproperties
{
				Enabled=True
				Texture=Texture'Firetrucks.Icons.i_AmbleZone'
}
