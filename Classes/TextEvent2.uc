//=============================================================================
// TextEvent2: Displays text on screen.
// Useful for conveying the main character's thoughts. Or other people's words.
//=============================================================================
class TextEvent2 extends Triggers;

#exec texture import file=Textures\S_Message_textevent.pcx name=i_TextEvent2Icon group=Icons mips=Off flags=2

var() enum ETextAnimation {
  ANIM_Default,
  ANIM_Alert,
  ANIM_Wavy,
  ANIM_WipeInFadeOut,
  ANIM_Shaky,
} TextAnimation;

var() Font OverrideFont;
var() color TextColor;
var() localized string Text; //The text to display.
var() localized float FadeInTime;
var() localized float FadeOutTime;
var() localized float Duration; //How long the message should be displayed, not counting fade-in or fade-out
var() localized Sound Audio; //An optional sound effect to be played when triggered.
var() Texture Portrait; //optional portrait to display with the message
var() class<TextEvent2HUDOverlay> TextEventStyle; // The HUD overlay class used to draw the text events
var() bool bInstigatorOnly; // if true, it will only check the instigator.

replication {
  reliable if (Role == ROLE_Authority)
    getAnimation, getText;
}

enum ECheckScope {
  CS_CASCADING,
  CS_GLOBAL,
  CS_PERSONAL,
};

enum EReplacementOperation {
  OP_REPLACE, // replace text with key's stored value
  OP_PRESENT, // replace text with ReplaceWith if the logic is whatever
  OP_NOT_PRESENT,
  OP_EQUAL,
  OP_GREATER,
  OP_GREATEREQUAL,
  OP_LESS,
  OP_LESSEQUAL,
};

struct KvTemplatedTranslatorEventReplacement {
  var() localized string TargetKey;
  var() localized string DefaultReplacement;
  var() localized string ReplaceWith;
  var() localized string TargetValue;
  var() bool bIgnoreCase;
  var() localized EReplacementOperation ReplacementOperation;
  var() localized ECheckScope CheckScope;
};

var(KvStore) KvTemplatedTranslatorEventReplacement Replacements[8];
var(KvStore) localized string TemplateString;
var string kvStoreClassName;

simulated function byte getAnimation() {
  return textAnimation;
}

static function string fmt(string input, string replace[8], string template) {
  local int i, j;
  local string output;
  i = inStr(input, template);
  while (i != -1 && j < 8) {
    output = output $ left(input, i) $ replace[j++];
    input = mid(input, i + Len(template));
		i = inStr(input, template);
  }
  output = output $ input;
  return output;
}

static final function bool canCoerceBoth(coerce int a, coerce int b) {
  return a != 0 && b != 0;
}

static final operator(24) bool cge (coerce int a, coerce int b) {
  return a >= b;
}

static final operator(24) bool cg (coerce int a, coerce int b) {
  return a > b;
}

static final operator(24) bool cle (coerce int a, coerce int b) {
  return a <= b;
}

static final operator(24) bool cl (coerce int a, coerce int b) {
  return a < b;
}

function String getText(Pawn ownerToUse) {
  local int i;
  local Inventory inventory;
  local Inventory kvs;
  local string value;
  local Class<Inventory> kvsClass;
  local Inventory dummy;
  local bool needReplacement;
  local string replacedStrings[8];

  for (i = 0; i < 8; i++) {
    if (ownerToUse != none && replacements[i].targetKey != "") needReplacement = true;
  }

  if (needReplacement) {
    kvsClass = class<Inventory>(DynamicLoadObject(kvStoreClassName, class'Class'));

    if (ownerToUse != none) {
      inventory = ownerToUse.inventory;
      while (inventory != none) {
        if (inventory.class == kvsClass) {
          kvs = inventory;
          break;
        }
        inventory = inventory.inventory;
      }
    } 

    for (i = 0; i < 8; i++) { 
      if (kvs != none) {  
        dummy = new (outer) class'ASMD';
        dummy.itemName = replacements[i].targetKey;
        dummy.bActivatable = replacements[i].bIgnoreCase;
        switch(replacements[i].CheckScope) {
          case CS_PERSONAL:
            dummy.autoSwitchPriority = 0;
            value = kvs.inventoryCapsString('', none, dummy);
            break;
          case CS_GLOBAL:
            dummy.autoSwitchPriority = 1;
            value = kvs.inventoryCapsString('', none, dummy);
            break;
          case CS_CASCADING:
            dummy.autoSwitchPriority = 2;
            value = kvs.inventoryCapsString('', none, dummy);
            break;
        }
      }

      switch(replacements[i].ReplacementOperation) {
        case OP_REPLACE:
          if (value != "") replacedStrings[i] = value;
          else replacedStrings[i] = replacements[i].defaultReplacement;
          break;
        case OP_PRESENT:
          if (value != "") replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
          break;
        case OP_NOT_PRESENT:
          if (value == "") replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
          break;
        case OP_EQUAL:
          if (value == replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
          else replacedStrings[i] = replacements[i].defaultReplacement;
          break;
        case OP_GREATER:
          if (canCoerceBoth(value, replacements[i].targetValue)) {
            if (value cg replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          } else {
            if (value > replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          }
          break;
        case OP_GREATEREQUAL:
          if (canCoerceBoth(value, replacements[i].targetValue)) {
            if (value cge replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          } else {
            if (value >= replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          }
          break;
        case OP_LESS:
          if (canCoerceBoth(value, replacements[i].targetValue)) {
            if (value cl replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          } else {
            if (value < replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          }
          break;
        case OP_LESSEQUAL:
          if (canCoerceBoth(value, replacements[i].targetValue)) {
            if (value cle replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          } else {
            if (value <= replacements[i].targetValue) replacedStrings[i] = replacements[i].replaceWith;
            else replacedStrings[i] = replacements[i].defaultReplacement;
          }
          break;
      }
    }
    return fmt(text, replacedStrings, templateString);
  }
  return text;
}

function Trigger(actor Other, pawn EventInstigator) {
  local PlayerPawn pp;
  local inventory i;
  local TextEvent2Replicator rep;

  if (bInstigatorOnly) {
    if (PlayerPawn(EventInstigator) == none) return;
    pp = PlayerPawn(EventInstigator);
    i = pp.inventory;
    while (i != none) {
      if (TextEvent2Replicator(i) != none) {
        rep = TextEvent2Replicator(i);
        break;
      }
      i = i.inventory;
    }
    if (rep == none) {
      rep = spawn(class'TextEvent2Replicator');
      rep.touch(eventInstigator);
    }
    rep.giveToMyOwner(self, getText(eventInstigator));
  } else {
    foreach allactors(class'PlayerPawn', pp) {
      i = pp.inventory;
      rep = none;
      while (i != none) {
        if (TextEvent2Replicator(i) != none) {
          rep = TextEvent2Replicator(i);
          break;
        }
        i = i.inventory;
      }
      if (rep == none) {
        rep = spawn(class'TextEvent2Replicator');
        rep.touch(pp);
      }
      rep.giveToMyOwner(self, getText(eventInstigator));
    }
  }
  
  if (event != '') triggerEvent(event, other, eventInstigator);
}

defaultproperties {
  FadeInTime=1
  FadeOutTime=1
  Duration=4.000000
  Texture=Texture'i_TextEvent2Icon'
  TemplateString="%s"
  TextEventStyle=Class'FiretrucksTextEvent2HUDOverlay'
  TextColor=(R=255,G=255,B=255)
  bNoDelete=true
  kvStoreClassName="KvStore.KvStore"
}
