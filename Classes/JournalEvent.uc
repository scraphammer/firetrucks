//=============================================================================
// JournalEvent.
//=============================================================================
class JournalEvent extends Triggers;

#exec TEXTURE IMPORT NAME=i_JournalEvent FILE=Textures\oll_icon_journalevent.pcx GROUP="Icons" MIPS=OFF FLAGS=2

/**
Events for the Journal. Like TranslatorEvents, but a million times better.
*/

struct JournalEventEntry {
  var() localized String entryName;
  var() bool indent;
  var() localized String entryText;
};

struct JournalImageEventEntry {
  var() texture image;
  var() ERenderStyle drawStyle;
  var() int height;
  var() int width;
};

var() localized JournalEventEntry eventEntry; //The message to be displayed.
var JournalListEntry entry;
var() float reTriggerDelay; //A delay before this JournalEvent can be triggered again.
var() enum SuperEntryType {
  SET_IMAGE_ONLY,
  SET_PLAIN,
  SET_SCRIBBLE,
  SET_CLEAN,
  SET_EXTRA,
} entryType; //Controls how the entry is displayed by the UI.
var() JournalImageEventEntry images; //Allows you to set and image to be displayed with the message.
var() bool forceJournalOpen; //Whether or not to force the journal open when triggered.

var bool recentlyTriggered;
var transient float triggerTime;
var transient bool busy;

var Journal j;

function postBeginPlay() {
  local JournalListEntry jle;
  jle = new (Outer) class'JournalListEntry';
  jle.entryName = eventEntry.entryName;
  jle.indent = eventEntry.indent;
  jle.entryText = eventEntry.entryText;
  jle.image = images.image;
  jle.height = images.height;
  jle.width = images.width;
  jle.drawStyle = images.drawStyle;
  jle.entryType = entryType;
  entry = jle;
}

function Trigger(actor Other, pawn EventInstigator) {
	local PlayerPawn pp;
  local Journal j;

	foreach allActors(class'PlayerPawn', pp) touch(pp);
	if (!forceJournalOpen) return;
	foreach allActors(class'Journal', j) if (j.owner != none) j.gotoState('Activated');
  
  if (event != '') triggerEvent(event, other, eventInstigator);
}

function UnTrigger(actor Other, pawn EventInstigator) {
	UnTouch(Other);
}


function Timer() {
	recentlyTriggered = False;
	busy = false;
}

function Touch( actor Other) {

  local inventory Inv;

  if (PlayerPawn(Other) == None) {/*log("Touched an actor that isn't a playerpawn");*/ return;}
  if (recentlyTriggered){/*log("recentlyTriggered");*/ return;}
  if (entry == none){/*log("blank entry");*/ return;}
  if (ReTriggerDelay > 0 ) {
		if (Level.TimeSeconds - TriggerTime < ReTriggerDelay) return;
		TriggerTime = Level.TimeSeconds;
	}
  if (busy) return;

	busy = true;

  for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory) {
		if (Journal(Inv)!= None) {
      j = Journal(Inv);

      j.journalMessage(entry, self);

      recentlyTriggered = true;
      setTimer(reTriggerDelay, false);
      busy = false;
			return;
		}
  }

  busy = false;
}

function UnTouch(actor Other) {
	recentlyTriggered = False;
}

function Destroyed() {
   entry = None; //null object reference
}

defaultproperties
{
				ReTriggerDelay=1.000000
				entryType=SET_PLAIN
				forceJournalOpen=True
				Texture=Texture'Firetrucks.Icons.i_JournalEvent'
				bCollideWorld=True
}
