class HUDEvent extends Triggers;

#exec texture import file=Textures\hudev.pcx name=i_hudev group=Icons mips=off flags=2

/**
Allows mappers to change the hud at will.
*/

var() class<HUD> hudToUse; //Which HUD class to use
var() bool targetEveryone; //whether or not this should affect everyone or not

function trigger(actor o, pawn ei) {
  local PlayerPawn pp;
  if (targetEveryone) {
    foreach AllActors(class'PlayerPawn', pp) {
      pp.myHud.destroy();
      pp.myHud = none;
      pp.hudType = hudToUse;
      pp.myHud = spawn(hudToUse, pp);
    }
  } else if (ei != none && PlayerPawn(ei) != none) {
    PlayerPawn(ei).myHud.destroy();
    PlayerPawn(ei).myHud = none;
    PlayerPawn(ei).hudType = hudToUse;
    PlayerPawn(ei).myHud = spawn(hudToUse, ei);
  }
}

defaultproperties {
  targetEveryone=true
  texture=i_hudev
}

