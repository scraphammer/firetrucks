class PCADumper extends Triggers;

/**
Foricibly ends any PointAndClick event that might be active and has the option of teleporting the player to this location and/or adjusting player rotation.
*/

#exec texture import file=Textures\i_pcadump.pcx name=i_pcadump group=Icons flags=2 mips=off

var() bool teleportPlayer; //Whether or not to teleport the player
var() bool adjustPlayerRotation; //Whether or not to adjust the player's rotation

function trigger(actor o, pawn ei) {
  local PlayerPawn p;
  local PointAndClickEvent pace;
  
  foreach allActors(class'PointAndClickEvent', pace) {
    if (pace.isActive) pace.trigger(o, ei);
  }

  if (teleportPlayer) {
    foreach allActors(class'PlayerPawn', p) {
      p.setLocation(location); //could get messy
    }
  }

  if (adjustPlayerRotation) {
    foreach allActors(class'PlayerPawn', p) {
      p.setRotation(rotation);
    }
  }

}

defaultproperties {
  texture=i_pcadump
  teleportPlayer=true
  adjustPlayerRotation=true
  bDirectional=true
}

