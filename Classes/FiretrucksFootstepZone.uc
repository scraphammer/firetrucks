//=============================================================================
// FiretrucksFootstepZone
//=============================================================================
class FiretrucksFootstepZone extends ZoneInfo;

#exec TEXTURE IMPORT FILE="Textures\scr_ZoneStep.pcx" NAME="FiretrucksFootstepZone" GROUP="Icons" MIPS=Off FLAGS=2

/**
Overrides footstep sounds for players within the zone.
*/

var() sound Defaults[3]; //The default player footstep noises. In most cases this should not be changed.
var() sound Overrides[3]; //The new footstep noises to use.
var() sound DefaultLand; //The default player landing noise. In most cases this should not be changed.
var() sound OverrideLand; //The new player landing noise. Leave as none to just use the default.

event ActorEntered (Actor Other) {
  super.ActorEntered(other);
  footstepOverwrite(Overrides, OverRideLand, UnrealIPlayer(Other));
}

event ActorLeaving (Actor Other) {
  super.ActorEntered(other);
  footstepOverwrite(Defaults, DefaultLand, UnrealIPlayer(Other));
}

function footstepOverwrite(Sound step[3], Sound land, UnrealIPlayer uip) {
  if (uip == None) return;

  uip.footstep1 = step[0];
  uip.footstep2 = step[1];
  uip.footstep3 = step[2];
  if (land != none) uip.land = land;
  else uip.land = DefaultLand;

  return;
}

defaultproperties
{
				Defaults(0)=Sound'UnrealShare.Female.stwalk1'
				Defaults(1)=Sound'UnrealShare.Female.stwalk2'
				Defaults(2)=Sound'UnrealShare.Female.stwalk3'
				DefaultLand=Sound'UnrealShare.Generic.Land1'
				Texture=Texture'Firetrucks.Icons.FiretrucksFootstepZone'
}
