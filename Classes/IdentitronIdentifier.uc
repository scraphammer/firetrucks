class IdentitronIdentifier extends Info nousercreate;

/**
Used by FiretrucksGame to bind PlayerPawns to actual player logins. It also stores other information and is used by Identitron3000 to access actual player configs in a hacky way.
*/

var() string playerName; //The player's name
var() string options; //Their options string. I can't be bothered to use this now but it is smart of collect it.
var() PlayerPawn pp; //A reference to their player pawn.
var() class<PlayerPawn> desiredClass; //The player class that the poor player wanted but couldn't have.
var() Texture desiredSkin;

defaultproperties {
  bHidden=true;
}
