//=============================================================================
// Identitron3000.
//=============================================================================
class Identitron3000 extends Triggers;

#exec texture import file=Textures\identitron.pcx name=i_identitron group=Icons flags=2 mips=Off

/**
A handy class for changing the model, skin, sounds, etc of the player.
*/

var() enum triggerNotification {
  TN_TRIGGER,
  TN_POSTBEGINPLAY,
  TN_TICK
} listenOn; //Controls when the changes take place.
var() bool resetAllToDefault; //Whether or not this Identitron3000 should reset the targets to their defaults.
var() bool targetEveryone; //Whether or not this Identitron3000 should affect everyone or not.
var() class<UnrealIPlayer> copyFrom; //class to copy from. If left blank it will use the manual settings below.
var() string playerName; //allows overriding the player's name in the HUD, makes a difference in dialogue I guess
var() bool copyFromPlayerConfig; //if true the above will be ignored and the player's preferences will be used instead.

var(Visuals) Mesh forcedMesh;
var(Visuals) class<Carcass> forcedCarcassType;
var(Visuals) Texture forcedMultiSkins[10];
var(Visuals) Texture forcedSkin;

var(Sounds) Sound breathagain;
var(Sounds) Sound Die;
var(Sounds) Sound Die2;
var(Sounds) Sound Die3;
var(Sounds) Sound Die4;
var(Sounds) Sound drown;
var(Sounds) Sound GaspSound;
var(Sounds) Sound HitSound1;
var(Sounds) Sound HitSound2;
var(Sounds) Sound HitSound3;
var(Sounds) Sound HitSound4;
var(Sounds) Sound JumpSound;
var(Sounds) Sound Land;
var(Sounds) Sound LandGrunt;
var(Sounds) Sound UWHit1;
var(Sounds) Sound UWHit2;
var(Sounds) Sound WaterStep;

function tick(float d) {
  super.tick(d);
  if (listenOn != TN_TICK) return;
  id3kmain(true);
}

function postBeginPlay() {
  super.postBeginPlay();
  if (listenOn != TN_POSTBEGINPLAY) return;
  id3kmain(true);
}

function trigger(actor Other, pawn EventInstigator) {
  if (listenOn != TN_TRIGGER) return;
  id3kmain(targetEveryone, EventInstigator);
}

function id3kmain(bool everyone, optional Pawn ei) {
  local UnrealIPlayer p;
  local IdentitronIdentifier ii;
  if (everyone) {
    foreach allActors(class'UnrealIPlayer', p) {
      if (copyFromPlayerConfig) {
        //step 1: get the IdentitronIdentifier
        //This algorithm uses O(n^2) time when it could have easily used
        //O(n log n) instead, but the miserable stain who worked on this was too
        //lazy and couldn't be bothered to actually refactor the existing
        //Identitron3000 code. Seriously what a miserable pile of excrement and
        //refuse. Worthless nodevs like that who squander and throw away their
        //skills contibute nothing to society.
        foreach allactors(class'IdentitronIdentifier', ii) {
          if (ii.pp == p) break;
        }
        //step 2: The last step took so long to implement because there was a
        //game of pro dota 2 on and our terrible coder got distracted. What a
        //loser.
        if (ii != none) forcePlayer(p, class<UnrealIPlayer>(ii.desiredClass),
            ii.desiredSkin);
      } else if (resetAllToDefault) resetPlayer(p);
      else forcePlayer(p, copyFrom);
    }
  } else if (ei == none) return;
  else if (UnrealIPlayer(ei) != none){
    foreach allActors(class'UnrealIPlayer', p) if (p == UnrealIPlayer(ei)) {
      if (copyFromPlayerConfig) {
        foreach allactors(class'IdentitronIdentifier', ii) {
          if (ii.pp == p) break;
        }
        if (ii != none) forcePlayer(p, class<UnrealIPlayer>(ii.desiredClass),
            ii.desiredSkin);
      } else if (resetAllToDefault) resetPlayer(p);
      else forcePlayer(p, copyFrom);
      break;
    }
  }
}

function forcePlayer(UnrealIPlayer p, optional class<UnrealIPlayer> c,
    optional Texture s, optional string n) {
  if (p == none) return;
  if (c != none) {
    p.mesh = c.default.mesh;
    p.carcassType = c.default.carcassType;
    p.multiskins[0] = c.default.MultiSkins[0];
    if (s == none) p.multiskins[1] = c.default.MultiSkins[1];
    else p.multiskins[1] = s;
    p.multiskins[2] = c.default.MultiSkins[2];
    p.multiskins[3] = c.default.MultiSkins[3];
    p.multiskins[4] = c.default.MultiSkins[4];
    p.multiskins[5] = c.default.MultiSkins[5];
    p.multiskins[6] = c.default.MultiSkins[6];
    p.multiskins[7] = c.default.MultiSkins[7];
    //p.multiskins[8] = c.default.MultiSkins[8];
    //p.multiskins[9] = c.default.MultiSkins[9];
    if (s == none) p.skin = c.default.Skin;
    else p.skin = s;
    
    p.breathAgain = c.default.breathAgain;
    p.die = c.default.die;
    p.die2 = c.default.die2;
    p.die3 = c.default.die3;
    p.die4 = c.default.die4;
    p.drown = c.default.drown;
    p.gaspSound = c.default.gaspSound;
    p.hitSound1 = c.default.hitSound1;
    p.hitSound2 = c.default.hitSound2;
    p.hitSound3 = c.default.hitSound3;
    p.hitSound4 = c.default.hitSound4;
    p.jumpSound = c.default.jumpSound;
    p.land = c.default.land;
    p.landGrunt = c.default.landGrunt;
    p.UWHit1 = c.default.UWHit1;
    p.UWHit2 = c.default.UWHit2;
    p.waterStep = c.default.waterStep;
  } else {
    p.mesh = forcedMesh;
    p.carcassType = forcedCarcassType;
    p.multiskins[0] = forcedMultiSkins[0];
    if (s == none) p.multiskins[1] = forcedMultiSkins[1];
    else p.multiskins[1] = s;
    p.multiskins[2] = forcedMultiSkins[2];
    p.multiskins[3] = forcedMultiSkins[3];
    p.multiskins[4] = forcedMultiSkins[4];
    p.multiskins[5] = forcedMultiSkins[5];
    p.multiskins[6] = forcedMultiSkins[6];
    p.multiskins[7] = forcedMultiSkins[7];
    //p.multiskins[8] = forcedMultiSkins[8];
    //p.multiskins[9] = forcedMultiSkins[9];
    if (s == none) p.skin = forcedSkin;
    else p.skin = s;
    
    p.breathAgain = breathAgain;
    p.die = die;
    p.die2 = die2;
    p.die3 = die3;
    p.die4 = die4;
    p.drown = drown;
    p.gaspSound = gaspSound;
    p.hitSound1 = hitSound1;
    p.hitSound2 = hitSound2;
    p.hitSound3 = hitSound3;
    p.hitSound4 = hitSound4;
    p.jumpSound = jumpSound;
    p.land = land;
    p.landGrunt = landGrunt;
    p.UWHit1 = UWHit1;
    p.UWHit2 = UWHit2;
    p.waterStep = waterStep;
  }

  if (n != "" && FiretrucksHUD(p.myHUD) != none) {
    FiretrucksHUD(p.myHUD).playerName = n;
  } else if (playerName != "" && FiretrucksHUD(p.myHUD) != none) {
    FiretrucksHUD(p.myHUD).playerName = playerName;
  }
}

function resetPlayer(UnrealIPlayer p) {
  if (p == none) return;
  
  p.mesh = p.default.mesh;
  p.carcassType = p.default.carcassType;
  p.multiskins[0] = p.default.multiSkins[0];
  p.multiskins[1] = p.default.multiSkins[1];
  p.multiskins[2] = p.default.multiSkins[2];
  p.multiskins[3] = p.default.multiSkins[3];
  p.multiskins[4] = p.default.multiSkins[4];
  p.multiskins[5] = p.default.multiSkins[5];
  p.multiskins[6] = p.default.multiSkins[6];
  p.multiskins[7] = p.default.multiSkins[7];
  p.multiskins[8] = p.default.multiSkins[8];
  p.multiskins[9] = p.default.multiSkins[9];
  p.skin = p.default.skin;
  
  p.breathAgain = p.default.breathAgain;
  p.die = p.default.die;
  p.die2 = p.default.die2;
  p.die3 = p.default.die3;
  p.die4 = p.default.die4;
  p.drown = p.default.drown;
  p.gaspSound = p.default.gaspSound;
  p.hitSound1 = p.default.hitSound1;
  p.hitSound2 = p.default.hitSound2;
  p.hitSound3 = p.default.hitSound3;
  p.hitSound4 = p.default.hitSound4;
  p.jumpSound = p.default.jumpSound;
  p.land = p.default.land;
  p.landGrunt = p.default.landGrunt;
  p.UWHit1 = p.default.UWHit1;
  p.UWHit2 = p.default.UWHit2;
  p.waterStep = p.default.waterStep;
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_identitron'
}
