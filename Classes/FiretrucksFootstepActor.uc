//=============================================================================
// FiretrucksFootstepActor
//=============================================================================
class FiretrucksFootstepActor extends Keypoint;

#exec texture import file=Textures\i_OllFootstepActor.pcx name=FiretrucksFootstepActor group=Icons mips=Off flags=2

/**
Overrides footstep sounds for players within the actor's collision radius. They are problematic if the player can touch two at once.
*/

var() Sound Defaults[3]; //The default player footstep noises. If used inside a FiretrucksFootstepZone, you want these to match to zone's overriden values.
var() Sound Overrides[3]; //The new footstep noises to use.
var() Sound DefaultLand; //If used inside a FiretrucksFootstepZone, you want this to match to zone's overriden value.
var() Sound OverrideLand; //The new player landing noise. Leave as none to just use the default.
var() bool forceThroughTexture; //Forces the footsteps, even if otherwise specified by texture and/or footstep manager settings.

event Touch(Actor other) {
  footstepOverwrite(Overrides, OverrideLand, UnrealIPlayer(Other));
}

event Untouch(Actor other) {
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
				Texture=Texture'Firetrucks.Icons.FiretrucksFootstepActor'
				bCollideActors=True
				bCollideWorld=True
}
