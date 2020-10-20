class Repositioner extends Triggers;
/**
Kind of an awesome class. Lets you change the position or rotation of an
actor in a variety of ways.
*/

#exec texture import file=Textures\i_rep00.pcx name=i_rep00 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep01.pcx name=i_rep01 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep02.pcx name=i_rep02 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep03.pcx name=i_rep03 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep04.pcx name=i_rep04 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep10.pcx name=i_rep10 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep11.pcx name=i_rep11 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep12.pcx name=i_rep12 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep13.pcx name=i_rep13 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep14.pcx name=i_rep14 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep20.pcx name=i_rep20 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep21.pcx name=i_rep21 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep22.pcx name=i_rep22 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep23.pcx name=i_rep23 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep24.pcx name=i_rep24 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep30.pcx name=i_rep30 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep31.pcx name=i_rep31 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep32.pcx name=i_rep32 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep33.pcx name=i_rep33 group=Icons flags=2 mips=off
#exec texture import file=Textures\i_rep34.pcx name=i_rep34 group=Icons flags=2 mips=off

var() enum RRType {
  RRT_NONE,
  RRT_ADD,
  RRT_REPLACE,
  RRT_MATCH,
  RRT_FACE
} rotateType; //How to interract with the target's rotation. RRT_FACE faces the targetOfTarget
var() enum RLType {
  RLT_NONE,
  RLT_ADD,
  RLT_REPLACE,
  RLT_MATCH
} locationType; //How to interract the targetActor's location. RRT_MATCH copies the targetOfTarget
var() Actor targetActor; //The target actor to reposition
var() Actor targetOfTarget; //Used by some modes
var() Vector literalVector; //used for RLT_ADD or RLT_REPLACE
var() Rotator literalRotator; //used for RRT_ADD or RRT_REPLACE

var localized string errstr;

function trigger(actor o, pawn ei) {
  if (targetActor == none) return;

  switch (locationType) {
    case RLT_NONE: //don't do anything
      break;
    case RLT_ADD:
      targetActor.setLocation(targetActor.location + literalVector);
      break;
    case RLT_REPLACE:
      targetActor.setLocation(literalVector);
      break;
    case RLT_MATCH:
      if (targetOfTarget == none) {
        warn(self@errstr);
        break;
      }
      targetActor.setLocation(targetOfTarget.location);
      break;
  }

  switch(rotateType) {
    case RRT_NONE:
      break;
    case RRT_ADD:
      targetActor.setRotation(targetActor.rotation + literalRotator);
      break;
    case RRT_REPLACE:
      targetActor.setRotation(literalRotator);
      break;
    case RRT_MATCH:
      if (targetOfTarget == none) {
        warn(self@errstr);
        break;
      }
      targetActor.setRotation(targetOfTarget.rotation);
      break;
    case RRT_FACE:
      if (targetOfTarget == none) {
        warn(self@errstr);
        break;
      }
      targetActor.setRotation(rotator(targetOfTarget.location - targetActor.location));
      break;
  }
}

event DrawEditorSelection(Canvas c){
  //replace icons because jet is a baddie
  switch (locationType) {
    case RLT_NONE:
      switch(rotateType) {
        case RRT_NONE:
          texture=Texture'i_rep00';
          break;
        case RRT_ADD:
          texture=Texture'i_rep03';
          break;
        case RRT_REPLACE:
          texture=Texture'i_rep02';
          break;
        case RRT_MATCH:
          texture=Texture'i_rep04';
          break;
        case RRT_FACE:
          texture=Texture'i_rep01';
          break;
      }
      break;
    case RLT_ADD:
      switch(rotateType) {
        case RRT_NONE:
          texture=Texture'i_rep20';
          break;
        case RRT_ADD:
          texture=Texture'i_rep23';
          break;
        case RRT_REPLACE:
          texture=Texture'i_rep22';
          break;
        case RRT_MATCH:
          texture=Texture'i_rep24';
          break;
        case RRT_FACE:
          texture=Texture'i_rep21';
          break;
      }
      break;
    case RLT_REPLACE:
      switch(rotateType) {
        case RRT_NONE:
          texture=Texture'i_rep10';
          break;
        case RRT_ADD:
          texture=Texture'i_rep13';
          break;
        case RRT_REPLACE:
          texture=Texture'i_rep12';
          break;
        case RRT_MATCH:
          texture=Texture'i_rep14';
          break;
        case RRT_FACE:
          texture=Texture'i_rep11';
          break;
      }
      break;
    case RLT_MATCH:
      switch(rotateType) {
        case RRT_NONE:
          texture=Texture'i_rep30';
          break;
        case RRT_ADD:
          texture=Texture'i_rep33';
          break;
        case RRT_REPLACE:
          texture=Texture'i_rep32';
          break;
        case RRT_MATCH:
          texture=Texture'i_rep34';
          break;
        case RRT_FACE:
          texture=Texture'i_rep31';
          break;
      }
      break;
  }
}

defaultproperties {
  Texture=i_rep00
  bEditorSelectRender=true
  errstr=" has targetOfTarget equal to none. Likely mapper error."
}

