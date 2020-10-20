//=============================================================================
// ItemTrigger.
//=============================================================================
class ItemTrigger extends Triggers;

#exec texture import file=Textures\ItemTrigger.pcx name=i_trig group=Icons mips=Off flags=2

/**
Enables the use of FiretrucksPickup actors within its collision radius.
*/

var() class<FiretrucksPickup> prototype; //The class of FiretrucksPickup to enable.
var() bool enabled; //Whther or not this actor is enabled.
var() bool onScreenNotification; //Whether or not an on-screen notification should be displayed indicating that the item can be used.
var() enum UsageType {
  UT_USE,
  UT_TALK,
  UT_ACTIVATE,
  UT_PRESS,
  UT_WHACK,
  UT_DISCARD,
  UT_EAT,
  UT_DRINK,
  UT_SEARCH,
  UT_CRUSH,
  UT_OPEN,
  UT_READ,
  UT_EXAMINE,
  UT_WIPE,
  UT_ROTATE,
} useType; //What to display if <span>onScreenNotification</span>==true.
var() localized string useTypeCustom; //If set, ignores the <span>useType</span and instead uses this text. This is discouraged, however.
var() localized string ItemName; //The human-readable name of the item. Not needed if <span>onScreenNotification</span>==false.
var localized string useNames[15];

function string getUseName() {
  if (useTypeCustom != "") return useTypeCustom;
  return useNames[useType];
}

function Trigger(actor Other, pawn EventInstigator) {
  enabled = !enabled;
}

defaultproperties
{
				Enabled=True
				useNames(0)="Use"
				useNames(1)="Talk"
				useNames(2)="Activate"
				useNames(3)="Press"
				useNames(4)="Whack"
				useNames(5)="Discard"
				useNames(6)="Eat"
				useNames(7)="Drink"
				useNames(8)="Search"
				useNames(9)="Crush"
				useNames(10)="Open"
				useNames(11)="Read"
				useNames(12)="Examine"
				useNames(13)="Wipe"
				useNames(14)="Rotate"
				Texture=Texture'Firetrucks.Icons.i_trig'
}
