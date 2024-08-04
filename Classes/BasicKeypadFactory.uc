class BasicKeypadFactory extends Actor;

#exec TEXTURE IMPORT NAME=ebdKeypadBlank FILE=TEXTURES\KEYPAD\diceraw.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad0 FILE=TEXTURES\KEYPAD\dice0.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad1 FILE=TEXTURES\KEYPAD\dice1.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad2 FILE=TEXTURES\KEYPAD\dice2.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad3 FILE=TEXTURES\KEYPAD\dice3.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad4 FILE=TEXTURES\KEYPAD\dice4.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad5 FILE=TEXTURES\KEYPAD\dice5.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad6 FILE=TEXTURES\KEYPAD\dice6.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad7 FILE=TEXTURES\KEYPAD\dice7.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad8 FILE=TEXTURES\KEYPAD\dice8.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdKeypad9 FILE=TEXTURES\KEYPAD\dice9.PCX GROUP=Skins
#exec TEXTURE IMPORT NAME=ebdBlobbyTexture FILE=TEXTURES\KEYPAD\blob.PCX GROUP=Skins FLAGS=2 DETAIL=Dirty

#exec AUDIO IMPORT FILE="Sounds\keypad0.wav" NAME="ebdKeypad0" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad1.wav" NAME="ebdKeypad1" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad2.wav" NAME="ebdKeypad2" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad3.wav" NAME="ebdKeypad3" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad4.wav" NAME="ebdKeypad4" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad5.wav" NAME="ebdKeypad5" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad6.wav" NAME="ebdKeypad6" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad7.wav" NAME="ebdKeypad7" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad8.wav" NAME="ebdKeypad8" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypad9.wav" NAME="ebdKeypad9" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypadPass.wav" NAME="ebdKeypadPass" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypadFail.wav" NAME="ebdKeypadFail" GROUP="Keypad"
#exec AUDIO IMPORT FILE="Sounds\keypadReset.wav" NAME="ebdKeypadReset" GROUP="Keypad"

var() string code;
var() vector MakeOffset;
var() string TagPrefix;
var() Button<"Produce Keypad"> MakeButton;

var int counter;
var Array<vector> buttonOffsets;
var vector baseScale3d;
var vector buttonScale3d;
var vector screenScale3d;
var vector screenOffset;
var vector eventOffset;
var vector ueaOffset;
var vector UseBoxDimensions;
var vector UseBoxOffset;
var rotator screenRotation;

function UseEventAssociator2 makeUea2(Actor target, String prompt, String useName, name eventToUse, vector baseLocation, vector offset) {
  local UseEventAssociator2 uea2;
  uea2 = spawn(Class'UseEventAssociator2',,, baseLocation + getRotOffset(ueaOffset), rotation);
  uea2.OptionalTarget = target;
  uea2.UsePrompt = prompt;
  uea2.UseName = useName;
  uea2.event = eventToUse;
  uea2.DrawScale = 0.25;
  uea2.bUseBox = true;
  uea2.UseBoxDimensions = UseBoxDimensions;
  uea2.UseBoxOffset = UseBoxOffset;
  return uea2;
}

function SpecialEvent makeSpecialEvent(name tagToUse, Sound sound, vector baseLocation, vector offset) {
  local SpecialEvent specialEvent;
  specialEvent = spawn(Class'SpecialEvent',,tagToUse, baseLocation + getRotOffset(MakeOffset + offset));
  specialEvent.InitialState = 'PlaySoundEffect';
  specialEvent.sound = sound;
  specialEvent.DrawScale = 0.25;
  return specialEvent;
}

function StaticMeshActor makeStaticMesh(vector scale3D, vector offset) {
  local StaticMeshActor staticMeshActor;
  staticMeshActor = spawn(Class'StaticMeshActor',,, location + getRotOffset(MakeOffset + offset));
  staticMeshActor.SetRotation(rotation);
  staticMeshActor.DrawScale3D = scale3D;
  staticMeshActor.bShadowCast = false;
  staticMeshActor.mesh = LodMesh'DiceM';
  staticMeshActor.bWorldGeometry = false;
  staticMeshActor.bUseMeshCollision = false;
  staticMeshActor.SetCollision(false, false , false, false);
  staticMeshActor.bProjTarget = false;
  staticMeshActor.bPathCollision = false;
  staticMeshActor.bBlockZeroExtentTraces = false;
  staticMeshActor.bBlockNonZeroExtentTraces = false;
  staticMeshActor.bBlockAISight = false;
  staticMeshActor.bBlockTextureTrace = false;
  return staticMeshActor;
}

function onPropertyChange(name property, name parentProperty) {
  local string nameToUse;
  local StaticMeshActor staticMeshActor;
  local UseEventAssociator2 uea2;
  local DigitalCodeTrigger digitalCodeTrigger;
  local SpecialEvent specialEvent;
  local ScriptedTexture ScriptedTexture;
  //local KeypadScriptedTextureNotifier keypadScriptedTextureNotifier;
	if (Property == 'MakeButton') {
    if (TagPrefix == "") nameToUse = name $ "_" $ counter $ "_";
    else nameToUse = TagPrefix;
    counter++;

    digitalCodeTrigger = spawn(Class'DigitalCodeTrigger',,, location + getRotOffset(MakeOffset + Vect(64,0,0)));
    digitalCodeTrigger.digits[0].digitEvent = stringToName(nameToUse $ "0");
    digitalCodeTrigger.digits[1].digitEvent = stringToName(nameToUse $ "1");
    digitalCodeTrigger.digits[2].digitEvent = stringToName(nameToUse $ "2");
    digitalCodeTrigger.digits[3].digitEvent = stringToName(nameToUse $ "3");
    digitalCodeTrigger.digits[4].digitEvent = stringToName(nameToUse $ "4");
    digitalCodeTrigger.digits[5].digitEvent = stringToName(nameToUse $ "5");
    digitalCodeTrigger.digits[6].digitEvent = stringToName(nameToUse $ "6");
    digitalCodeTrigger.digits[7].digitEvent = stringToName(nameToUse $ "7");
    digitalCodeTrigger.digits[8].digitEvent = stringToName(nameToUse $ "8");
    digitalCodeTrigger.digits[9].digitEvent = stringToName(nameToUse $ "9");
    digitalCodeTrigger.bAutoSubmit = false;
    digitalCodeTrigger.bAutoReset = true;
    digitalCodeTrigger.bDisableAfterSuccess = false;
    digitalCodeTrigger.code = code;
    digitalCodeTrigger.failEvent = stringToName(nameToUse $ "fail");
    digitalCodeTrigger.event = stringToName(nameToUse $ "pass");
    digitalCodeTrigger.SubmitEvent = stringToName(nameToUse $ "Submit");
    digitalCodeTrigger.ResetEvent = stringToName(nameToUse $ "Reset");

    //base
    staticMeshActor = makeStaticMesh(baseScale3d, Vect(0,0,0));
    staticMeshActor.multiskins[0] = Texture'ebdBlobbyTexture';

    //keys
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[0]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad7';
    //function UseEventAssociator2 makeUea2(String prompt, String useName, name eventToUse, vector baseLocation, vector offset) {
    uea2 = makeUea2(staticMeshActor, "Press", "'7'", digitalCodeTrigger.digits[7].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad7', staticMeshActor.location, eventOffset);

    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[1]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad8';
    uea2 = makeUea2(staticMeshActor, "Press", "'8'", digitalCodeTrigger.digits[8].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad8', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[2]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad9';
    uea2 = makeUea2(staticMeshActor, "Press", "'9'", digitalCodeTrigger.digits[9].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad9', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[3]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad4';
    uea2 = makeUea2(staticMeshActor, "Press", "'4'", digitalCodeTrigger.digits[4].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad4', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[4]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad5';
    uea2 = makeUea2(staticMeshActor, "Press", "'5'", digitalCodeTrigger.digits[5].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad5', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[5]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad6';
    uea2 = makeUea2(staticMeshActor, "Press", "'6'", digitalCodeTrigger.digits[6].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad6', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[6]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad1';
    uea2 = makeUea2(staticMeshActor, "Press", "'1'", digitalCodeTrigger.digits[1].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad1', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[7]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad2';
    uea2 = makeUea2(staticMeshActor, "Press", "'2'", digitalCodeTrigger.digits[2].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad2', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[8]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad3';
    uea2 = makeUea2(staticMeshActor, "Press", "'3'", digitalCodeTrigger.digits[3].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad3', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[9]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypadBlank';
    uea2 = makeUea2(staticMeshActor, "Press", "'Reset", digitalCodeTrigger.ResetEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypadReset', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[10]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypad0';
    uea2 = makeUea2(staticMeshActor, "Press", "'0'", digitalCodeTrigger.digits[0].digitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(uea2.event, Sound'ebdKeypad0', staticMeshActor.location, eventOffset);
    
    staticMeshActor = makeStaticMesh(buttonScale3d, buttonOffsets[11]);
    staticMeshActor.multiskins[0] = Texture'ebdKeypadBlank';
    uea2 = makeUea2(staticMeshActor, "Press", "'Submit", digitalCodeTrigger.SubmitEvent, staticMeshActor.location, ueaOffset);
    specialEvent = makeSpecialEvent(digitalCodeTrigger.event, Sound'ebdKeypadPass', staticMeshActor.location, eventOffset);
    specialEvent = makeSpecialEvent(digitalCodeTrigger.failEvent, Sound'ebdKeypadFail', staticMeshActor.location, eventOffset * 2);
    
    //screen
  }
}

function vector getRotOffset(vector rawOffset) {
  return rawOffset >> rotation;
}

event DrawEditorSelection(Canvas c) {
  local int i;
  c.drawColor = makeColor(250, 240, 255);
  class'PulsingBoxUEAHUDOverlay'.static.drawBox(c, location + getRotOffset(MakeOffset), baseScale3d.x * 2, baseScale3d.y * 2, baseScale3d.z * 2, 1, rotation);
  c.drawColor = makeColor(230, 255, 41);
  for (i = 0; i < 12; i++) class'PulsingBoxUEAHUDOverlay'.static.drawBox(c, location + getRotOffset(MakeOffset + buttonOffsets[i]), buttonScale3d.x * 2, buttonScale3d.y * 2, buttonScale3d.z * 2, 1, rotation);  
}

defaultproperties {
  bEdShouldSnap=true
  buttonOffsets=((x=9,y=-6,z=8),(x=0,y=-6,z=8),(x=-9,y=-6,z=8),(x=9,y=-6,z=-1),(x=0,y=-6,z=-1),(x=-9,y=-6,z=-1),(x=9,y=-6,z=-10),(x=0,y=-6,z=-10),(x=-9,y=-6,z=-10),(x=9,y=-6,z=-19),(x=0,y=-6,z=-19),(x=-9,y=-6,z=-19))
  ueaOffset=(x=128,y=0,z=0)
  eventOffset=(x=0,y=16,z=0)
  baseScale3d=(x=7,y=2,z=12)
  buttonScale3d=(x=2,y=1,z=2)
  screenOffset=(x=0,y=-5,z=18)
  screenScale3d=(x=0.05,y=0.125,z=1)
  screenRotation=(pitch=270,roll=0,yaw=-90)
  UseBoxDimensions=(x=128,y=128,z=160)
  UseBoxOffset=(x=0,y=-96,z=0)
  code="0451"
  bDirectional=true
  bHidden=true
  bStatic=true
  MakeOffset=(x=0,y=-32,z=0)
  bEditorSelectRender=True
}