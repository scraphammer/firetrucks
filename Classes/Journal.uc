//=============================================================================
// Journal.
//=============================================================================
class Journal extends FiretrucksPickup;

/**
Originally written for The Oll Stone. Cannabalized for Firetrucks. The Oll Stone wasn't even a dead project. It can't be helped I suppose.
*/

#exec OBJ LOAD FILE=Detail.utx

#exec AUDIO IMPORT FILE="Sounds\oll_journal_pick.wav" NAME="oll_journal_pick" GROUP="Pickups"
#exec AUDIO IMPORT FILE="Sounds\oll_journal_message.wav" NAME="oll_journal_message" GROUP="Pickups"

#exec MESH IMPORT MESH=oll_journal ANIVFILE=MODELS\oll_journal_a.3d DATAFILE=MODELS\oll_journal_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=oll_journal X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=oll_journal SEQ=All  STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=oll_journal SEQ=BOOK STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Joll_journal1 FILE=MODELS\oll_journal1.PCX GROUP=Skins FLAGS=2 DETAIL=Dirty
#exec TEXTURE IMPORT NAME=i_journal FILE=Textures\i_journal.PCX GROUP=Icons FLAGS=2 MIPS=OFF

#exec MESHMAP NEW   MESHMAP=oll_journal MESH=oll_journal
#exec MESHMAP SCALE MESHMAP=oll_journal X=0.02 Y=0.02 Z=0.04

#exec MESHMAP SETTEXTURE MESHMAP=oll_journal NUM=1 TEXTURE=Joll_journal1

var() class<JournalUISystem> UISystem; //What JournalUISystem to use.
var transient JournalUISystem JUIS;

var int length;
var travel JournalListNode allTail;
var travel JournalListNode latest;
var travel JournalListEntry newest;

var localized string firstEntry;
var localized string firstEntryText;

var() Sound newMessageSound; //Specifies the sound to play on a new JournalEvent.
var() Sound oldMessageSound; //Specifies the sound to play on an old JournalEvent.

function activate() {
  super(Pickup).activate();
}

function postBeginPlay() {
  local JournalListEntry e;
  if (UISystem != None) JUIS = new (outer) UISystem;
  if (length == 0) {
    e = new (outer) class'JournalListEntry';
    e.entryName = firstEntry;
    e.indent = false;
    e.entryText = firstEntryText;
    e.entryType = 1;
    journalMessage(e);
  }
  super.postBeginPlay();
}

function journalMessage(JournalListEntry e, optional JournalEvent je) {
  local JournalListNode jln;
  latest = none;
  //having a binary search tree would be faster but I am not that concerned about speed
  latest = class'JournalListNode'.static.linearSearch(allTail, e);

  if(latest != none) {
    if (owner != none) {
      Pawn(Owner).ClientMessage("Journal Entry: " $ e.entryName);
      if (je != none) je.PlaySound(oldMessageSound, SLOT_Misc);
    }
    return;
  }

  if (owner != none) {
    Pawn(Owner).ClientMessage("New Journal Entry: " $ e.entryName);
    if (je != none) je.PlaySound(newMessageSound, SLOT_Misc);
  }

  jln = new (outer) class'JournalListNode';
  jln.entry = e;
  if (allTail == none) {
    allTail = jln;
  } else {
    allTail.next = jln;
    jln.prev = allTail;
    allTail = jln;
  }
  jln.index = length;
  length++;
  latest = jln;
  //log(jln @ "added to journal.");
}

simulated function drawJournal(canvas c) {
  if (JUIS == None) {
    if (UISystem != None) JUIS = new (outer) UISystem;
  }
  if (JUIS != None) JUIS.draw(c, self);
  else warn("Couldn't instantiate Journal UI!");
}

state Activated {
  function BeginState() {
    bActive = true;
    //if (FiretrucksPlayer(Owner) != none) FiretrucksPlayer(owner).acceptInput = true;
  }

  function EndState() {
    bActive = false;
   //if (FiretrucksPlayer(Owner) != none) FiretrucksPlayer(owner).acceptInput = false;
  }
}

state Deactivated {
  function BeginState() {
    bActive = false;
    // if (FiretrucksPlayer(Owner) != none) FiretrucksPlayer(owner).acceptInput = false;
  }
}

function mouseWheelUp() {
  if (latest == none || latest.next == none) return;
  latest = latest.next;
}

function mouseWheelDown() {
  if (latest == none || latest.prev == none) return;
  latest = latest.prev;
}

function destroyed() {
  local JournalListNode tail, prev;
  latest = none;
  newest = none;
  if (JUIS != none) JUIS.currentDisplayNode = none;
  JUIS = none;
  for (tail = allTail; tail != none; tail = prev) {
    tail.entry = none;
    tail.next = none;
    prev = tail.prev;
    tail.prev = none;
  }
  length = 0;
}

defaultproperties
{
  UISystem=Class'Firetrucks.FiretrucksJournalUI'
  firstEntry="About this Journal:"
  firstEntryText="You can use the next and previous weapon bindings (usually mousewheel) to scroll through journal entries."
  NewMessageSound=Sound'Firetrucks.Pickups.oll_journal_message'
  oldMessageSound=Sound'Firetrucks.Pickups.oll_journal_pick'
  oneUse=False
  eventOnUse="JournalInvEvent"
  PickupMessage="You picked up your journal of notes."
  PickupViewMesh=LodMesh'Firetrucks.oll_journal'
  PickupSound=Sound'Firetrucks.Pickups.oll_journal_pick'
  Icon=Texture'Firetrucks.Icons.i_journal'
  Mesh=LodMesh'Firetrucks.oll_journal'
}
