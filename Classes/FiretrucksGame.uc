//=============================================================================
// FiretrucksGame.
//=============================================================================
class FiretrucksGame extends UnrealGameInfo;
/**
Custom firetrucks gametype. Forcing the player is very important. Extend if 
you want. WARNING: netplay probably doesn't work at all. I don't care about 
trying to get it working. If you'd like to care, have at it. I'm willing to 
answer questions you might have, I just don't want to spend a milluon years 
choking to death in Unreal Engine 1 netcode. I think it actually be cool if
it all did work, but that's how it is. I have put hundreds of hours into
firetrucks already, but you know the saying: "If you really love her you have 
to let her go."
*/

#exec texture import file=Textures\grit\grittyCombine0.pcx name=grittyDetail0 group=Detail
#exec texture import file=Textures\grit\grittyCombine1.pcx name=grittyDetail1 group=Detail
#exec texture import file=Textures\grit\gritty.pcx name=grittyDetail4 group=Detail
#exec texture import file=Textures\grit\smudgey.pcx name=grittyDetail5 group=Detail
#exec texture import file=Textures\grit\boringgrass.pcx name=grittyDetail6 group=Detail
#exec texture import file=Textures\grit\fibers.pcx name=grittyDetail7 group=Detail
#exec texture import file=Textures\grit\fibers2.pcx name=grittyDetail8 group=Detail


#exec AUDIO IMPORT FILE="Sounds\f_creak.wav" NAME="f_creak" GROUP="Misc"
#exec AUDIO IMPORT FILE="Sounds\f_hard1.wav" NAME="f_hard1" GROUP="Footstep"
#exec AUDIO IMPORT FILE="Sounds\f_hard2.wav" NAME="f_hard2" GROUP="Footstep"
#exec AUDIO IMPORT FILE="Sounds\f_hard3.wav" NAME="f_hard3" GROUP="Footstep"
#exec AUDIO IMPORT FILE="Sounds\f_wood1.wav" NAME="f_wood1" GROUP="Footstep"
#exec AUDIO IMPORT FILE="Sounds\f_wood2.wav" NAME="f_wood2" GROUP="Footstep"
#exec AUDIO IMPORT FILE="Sounds\f_wood3.wav" NAME="f_wood3" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\f_metallnd.wav" NAME="f_metallnd" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\footsteps_metal5_01.wav" NAME="footsteps_metal5_01" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\footsteps_metal5_02.wav" NAME="footsteps_metal5_02" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\footsteps_metal5_03.wav" NAME="footsteps_metal5_03" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\footsteps_metal5_04.wav" NAME="footsteps_metal5_04" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\sstep0f.wav" NAME="f_stone1" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\sstep1f.wav" NAME="f_stone2" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\sstep2af.wav" NAME="f_stone3" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\sstep3f.wav" NAME="f_heels1" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\sstep4f.wav" NAME="f_heels2" GROUP="Footstep"
//#exec AUDIO IMPORT FILE="Sounds\sstep5f.wav" NAME="f_heels3" GROUP="Footstep"

//force default player
event playerpawn Login(string Portal, string Options, out string Error, class<playerpawn> SpawnClass) {
  local PlayerPawn pp;
  local IdentitronIdentifier ii;
  pp = super.Login(Portal, Options, Error, DefaultPlayerClass);

  if (pp == none) return pp;

  ii = spawn(class'IdentitronIdentifier');
  ii.playerName = Left(ParseOption(Options, "Name"), 40);
  ii.setPropertyText("desiredSkin", ParseOption(Options, "Skin"));
  ii.options = options;
  ii.desiredClass = spawnClass;
  ii.pp = pp;

  return pp;
}

defaultproperties
{
  DefaultPlayerClass=Class'Firetrucks.FiretrucksPlayer'
  DefaultWeapon=None
  HUDType=Class'Firetrucks.FiretrucksHUD'
}
