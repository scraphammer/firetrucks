//=============================================================================
// UseEventAssociator.
//=============================================================================
class UseEventAssociator extends Triggers nousercreate;

#exec texture import file=Textures\useEvent.pcx name=i_useEvent group=Icons flags=2 mips=Off

#exec texture import file=Textures\ui_use.pcx name=i_use group=UseIcons mips=Off
#exec texture import file=Textures\ui_talk.pcx name=i_talk group=UseIcons mips=Off
#exec texture import file=Textures\ui_act.pcx name=i_act group=UseIcons mips=Off
//press
//whack
//poke
#exec texture import file=Textures\ui_eat.pcx name=i_eat group=UseIcons mips=Off
#exec texture import file=Textures\ui_drink.pcx name=i_drink group=UseIcons mips=Off
//search
#exec texture import file=Textures\ui_take.pcx name=i_take group=UseIcons mips=Off
#exec texture import file=Textures\ui_open.pcx name=i_open group=UseIcons mips=Off
#exec texture import file=Textures\ui_read.pcx name=i_read group=UseIcons mips=Off
#exec texture import file=Textures\ui_magnify.pcx name=i_magnify group=UseIcons mips=Off
#exec texture import file=Textures\ui_close.pcx name=i_close group=UseIcons mips=Off
#exec texture import file=Textures\ui_rotate.pcx name=i_rotate group=UseIcons mips=Off
#exec texture import file=Textures\ui_lock.bmp name=i_lock group=UseIcons mips=Off
#exec texture import file=Textures\ui_deny.pcx name=i_deny group=UseIcons mips=Off

#exec texture import file=Textures\ui_question.pcx name=i_question group=UseIcons mips=Off

/**
This is a relatively elegant solution to being able to "use" things within the level. When the player is within range and presses their use/activate item key, an event is called instead. The design could have come to me in a dream, exacept I was busy staying up all night listening to Green Day while disliking peace and love. If you didn't understand the reference in the previous statement do an image search for "ecstasy aka darks."
*/

var() localized string targetName; //The name of the target to display when in range.
var() Actor useTarget; //The target actor that gets "used."
var editconst private name eventOnUse; //When the target is "used" this is the event is called. marked for death
var() bool disableAfterUse; //If true, this actor disables itself after being used.
var() bool enabled; //Whether or not this actor is enabled.
var() enum TriggerAction {
  TA_IGNORE,
  TA_ENABLE,
  TA_DISABLE,
  TA_TOGGLE
} onTrigger; //How this actor should behave when it gets triggered by other events (not the player's use key).
var() enum UsageType {
  UT_USE,
  UT_TALK,
  UT_ACTIVATE,
  UT_PRESS,
  UT_WHACK,
  UT_POKE,
  UT_EAT,
  UT_DRINK,
  UT_SEARCH,
  UT_TAKE,
  UT_OPEN,
  UT_READ,
  UT_EXAMINE,
  UT_CLOSE,
  UT_ROTATE,
  UT_LOCKED,
  UT_NONE,
} useType; //The text to display on screen when in range to use the object. Select from one of many fun types!
var() bool precise; //If true, check the player's view rotation to ensure they are actually looking at the target.
var() float precision; //If <span>precise</span> is set to true, this is the maximum angle between a direct line to the actor's center and the player's view rotation for the player to be able to trigger the UseEventAssociator. The angle is measured in radians.
var() localized string useTypeCustom; //If set, ignores the <span>useType</span> and instead uses this text. This is discouraged, however.
var() bool ignoreHiddenTarget; //If true, it will prevent interraction with targets that are hidden.

var() vector useOffset; //Allows the end-user (that's you!) to specify an offset from the target's center
var() float useDistance; //Controls how close the player must be in order to use the object.
var() Texture useIconCustom; //Texture to replace the crosshair.

var Texture fallbackTexture;

var(Advanced) editconst Texture baseTexture; //marked for death
var Texture scriptedIcon; //marked for death
var localized string useNames[17];
var localized Texture useIcons[17];

function Trigger(actor Other, pawn EventInstigator) {
  switch(onTrigger) {
    case TA_IGNORE:
      break;
    case TA_ENABLE:
      enabled = true;
      break;
    case TA_DISABLE:
      enabled = false;
      break;
    case TA_TOGGLE:
      enabled = !enabled;
      break;
  }
}

function fire(optional Pawn i) {
  triggerEvent(event, Self, i);
  if (disableAfterUse) enabled = false;
}

function string getUseName() {
  if (useTypeCustom != "") return useTypeCustom;
  return useNames[useType];
}

function Texture getIcon() {
  if (useIconCustom != none) return useIconCustom;
  else if (useTypeCustom != "") return fallbackTexture;
  return useIcons[useType];
}

event DrawEditorSelection(Canvas c){
  local Actor a;
  local Font f;
  
  f = c.font;
  
  c.font = font'WeedrowFont';
  c.setPos(2, c.clipy - 16);
  c.drawText(name, false);
    
  c.drawColor = makeColor(127, 127, 127);
  c.setPos(2, c.clipy - 32);
  c.drawText(getUseName()$":", false);
  
  c.setPos(96, c.clipy - 32);
  if (useTarget == none) c.drawColor = makeColor(255, 0, 0);
  else c.drawColor = makeColor(255, 255, 0);
  c.drawText(useTarget, false);
  
  if (useTarget !=  none) c.Draw3DLine(MakeColor(255, 255, 0),Location, useTarget.Location);
  if (event !=  '') foreach AllActors(Class'Actor', a, event) c.Draw3DLine(MakeColor(255, 0, 255),Location, a.Location);
  
  c.font = f;
  
  texture = default.texture;
  scriptedIcon = none;
  if (eventOnUse != '') event = eventOnUse;
  eventOnUse = '';
  baseTexture = default.baseTexture;
}

defaultproperties
{
	Enabled=True
	precise=True
	precision=0.400000
	useDistance=128.000000
	FallbackTexture=Texture'Firetrucks.UseIcons.i_question'
	baseTexture=Texture'Firetrucks.Icons.i_useEvent'
	useNames(0)="Use"
	useNames(1)="Talk"
	useNames(2)="Activate"
	useNames(3)="Press"
	useNames(4)="Whack"
	useNames(5)="Poke"
	useNames(6)="Eat"
	useNames(7)="Drink"
	useNames(8)="Search"
	useNames(9)="Take"
	useNames(10)="Open"
	useNames(11)="Read"
	useNames(12)="Examine"
	useNames(13)="Close"
	useNames(14)="Rotate"
        useNames(15)="Locked"
        useNames(16)="No Access"
	UseIcons(0)=Texture'Firetrucks.UseIcons.i_use'
	UseIcons(1)=Texture'Firetrucks.UseIcons.i_talk'
	UseIcons(2)=Texture'Firetrucks.UseIcons.i_act'
	UseIcons(3)=Texture'Firetrucks.UseIcons.i_use'
	UseIcons(4)=Texture'Firetrucks.UseIcons.i_use'
	UseIcons(5)=Texture'Firetrucks.UseIcons.i_use'
	UseIcons(6)=Texture'Firetrucks.UseIcons.i_eat'
	UseIcons(7)=Texture'Firetrucks.UseIcons.i_drink'
	UseIcons(8)=Texture'Firetrucks.UseIcons.i_magnify'
	UseIcons(9)=Texture'Firetrucks.UseIcons.i_take'
	UseIcons(10)=Texture'Firetrucks.UseIcons.i_open'
	UseIcons(11)=Texture'Firetrucks.UseIcons.i_read'
	UseIcons(12)=Texture'Firetrucks.UseIcons.i_magnify'
	UseIcons(13)=Texture'Firetrucks.UseIcons.i_close'
	UseIcons(14)=Texture'Firetrucks.UseIcons.i_rotate'
	UseIcons(15)=Texture'Firetrucks.UseIcons.i_lock'
	UseIcons(16)=Texture'Firetrucks.UseIcons.i_deny'
	bEditorSelectRender=True
	Style=STY_Masked
	Texture=Texture'Firetrucks.Icons.i_useEvent'
}
