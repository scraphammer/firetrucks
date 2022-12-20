//=============================================================================
// ForEachTrigger. Triggers multiple events at once, with the option to
// override the EventInstigator. Might be useful for coop.
//=============================================================================
class ForEachTrigger extends Triggers;

#exec texture import file=Textures\i_ForEachTrigger.pcx name=i_ForEachTrigger group=Icons mips=Off flags=2

var(Events) Array<name> Events;

var() enum E_SelectionMode {
  SM_PROTOTYPE,
  SM_TAG,
  SM_INSTANCES
} SelectionMode;
var() Class<Actor> SelectionPrototype;
var() Array<Actor> SelectionInstances;
var() name SelectionTag;
var() int Count;
var() bool bOverrideInstigator;
var() bool bRandomizeSelection;
var() bool bRepeatEvents;

function Trigger(actor Other, pawn EventInstigator) {
  local int i, j, tempCount;
  local int numSelections;
  local Actor a;
  local Array<Actor> selections;
  local Array<Actor> pickedSelections;
  local map<int,int> selected;
  local name e;

  // step 1: get a list of all eligible selections
  switch (SelectionMode) {
    case SM_PROTOTYPE:
      foreach allActors(SelectionPrototype, a) selections[numSelections++] = a;
      break;
    case SM_TAG:
      foreach allActors(Class'Actor', a, SelectionTag) selections[numSelections++] = a;
      break;
    case SM_INSTANCES:
      foreach SelectionInstances(a) selections[numSelections++] = a;
      break;
  }

  if (Count <= 0) tempCount = numSelections;
  else tempCount = count;
  
  // step 2: pick Count selections from the list
  while (i < numSelections && i < tempCount) {
    if (bRandomizeSelection) {
      j = -1;
      while (j == -1) {
        j = rand(numSelections);
        if (selected.has(j)) j = -1;
      }
      if (j >= 0) selected[j] = j;
    }
    pickedSelections[i++] = selections[j++];
  }

  // step 3: match selections to events
  // step 4: fire events
  if (bRepeatEvents) {
    i = 0;
    foreach Events(e) i++;
    foreach pickedSelections(a) {
      if (j >= i) j = 0;
      if (bOverrideInstigator && Pawn(a) != none) a.triggerEvent(Events[j], a, Pawn(a));
      else a.triggerEvent(Events[j], a, eventInstigator);
      j++;
    }
  } else {
    j = 0;
    foreach Events(e) {
      if (j >= i) break;
      if (bOverrideInstigator && Pawn(pickedSelections[j]) != none) pickedSelections[j].triggerEvent(e, pickedSelections[j], Pawn(pickedSelections[j]));
      else pickedSelections[j].triggerEvent(e, pickedSelections[j], eventInstigator);
      j++;
    }
  }

  //pass-through on event
  if (event != '') triggerEvent(event, other, eventInstigator);
}

defaultproperties {
  bOverrideInstigator=true
  bRandomizeSelection=true
  bRepeatEvents=true
  SelectionPrototype=class'PlayerPawn'
  Texture=Texture'i_ForEachTrigger'
}