class MultiCam extends FiretrucksCamera;

/**A camera that can be triggered in a number of ways to change where it is looking. Uses a dummy class to receive multiple events.
*/

#exec texture import file=Models\MadCamera2.pcx name=jFiretrucksCamera2 group=Skins

var() name positionTags[12]; //Tags for the literal postions. These go from top to bottom in a clockwise fashion.
var() name lookUpTag; //Looking up rotates the camera up about 30 degrees
var() name lookDownTag; //Same, but down
var() name lookLeftTag; //Rotates left 90 degrees
var() name lookRightTag; //Rotates right 90 degrees
var() localized editconst String notice; //"The internal Event field resets the camera."

var Rotator originalRot;
var byte myPosition;

function trigger(Actor o, Pawn ei) {
  setRotation(originalRot);
  myPosition = 4;
}

function postBeginPlay() {
  local byte i;
  local MultiCamDummy mcd;

  originalRot = rotation;

  for (i = 0; i < 12; i++) {
    if (positionTags[i] == '') continue;
    mcd = spawn(class'MultiCamDummy', self, positionTags[i],,);
    mcd.dir = i;
  }

  if (lookUpTag != '') {
    mcd = spawn(class'MultiCamDummy', self, lookUpTag,,);
    mcd.dir = 12;
  }
  if (lookDownTag != '') {
    mcd = spawn(class'MultiCamDummy', self, lookDownTag,,);
    mcd.dir = 13;
  }
  if (lookLeftTag != '') {
    mcd = spawn(class'MultiCamDummy', self, lookLeftTag,,);
    mcd.dir = 14;
  }
  if (lookRightTag != '') {
    mcd = spawn(class'MultiCamDummy', self, lookRightTag,,);
    mcd.dir = 15;
  }
}

function dummyCallback(byte i) {
  local Rotator r;
  r.pitch = 0;
  r.yaw = 0;
  r.roll = 0;
  switch(i) {
    //0-11 position "literals"
    case 0:
      myPosition = 0;
      r.pitch = 5460;
      setRotation(originalRot + r);
      break;
    case 1:
      myPosition = 1;
      r.pitch = 5460;
      r.yaw = 16383;
      setRotation(originalRot + r);
      break;
    case 2:
      myPosition = 2;
      r.pitch = 5460;
      r.yaw = -16383;
      setRotation(originalRot + r);
      break;
    case 3:
      myPosition = 3;
      r.pitch = 5460;
      setRotation(originalRot + r);
      break;
    case 4:
      myPosition = 4;
      setRotation(originalRot);
      break;
    case 5:
      myPosition = 5;
      r.yaw = 16383;
      setRotation(originalRot + r);
      break;
    case 6:
      myPosition = 6;
      r.yaw = 32767;
      setRotation(originalRot + r);
      break;
    case 7:
      myPosition = 7;
      r.yaw = -16383;
      setRotation(originalRot + r);
      break;
    case 8:
      myPosition = 8;
      r.pitch = -5460;
      setRotation(originalRot + r);
      break;
    case 9:
      myPosition = 9;
      r.pitch = -5460;
      r.yaw = 16383;
      setRotation(originalRot + r);
      break;
    case 10:
      myPosition = 10;
      r.pitch = -5460;
      r.yaw = 32768;
      setRotation(originalRot + r);
      break;
    case 11:
      myPosition = 11;
      r.pitch = -5460;
      r.yaw = -16383;
      setRotation(originalRot + r);
      break;
    case 12: //up
      if (myPosition < 4) break;
      myPosition -= 4;
      r.pitch = 5460;
      setRotation(rotation + r);
      break;
    case 13: //down
      if (myPosition > 7) break;
      myPosition += 4;
      r.pitch = -5460;
      setRotation(rotation + r);
      break;
    case 14: //left
      if (myPosition == 0) myPosition = 3;
      else if (myPosition == 4) myPosition = 7;
      else if (myPosition == 8) myPosition = 11;
      else myPosition--;
      r.yaw = -16383;
      setRotation(rotation + r);
      break;
    case 15: //right
      if (myPosition == 3) myPosition = 0;
      else if (myPosition == 7) myPosition = 4;
      else if (myPosition == 11) myPosition = 8;
      else myPosition++;
      r.yaw = 16383;
      setRotation(rotation + r);
      break;
  }
}

defaultproperties {
  myPosition=4;
  MultiSkins[1]=jFiretrucksCamera2;
  notice="The internal Event field resets the camera."
}

