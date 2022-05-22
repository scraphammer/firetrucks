//=============================================================================
// TextEvent2: Displays text on screen.
// Useful for conveying the main character's thoughts. Or other people's words.
//=============================================================================
class TextEvent2 extends Triggers;

#exec texture import file=Textures\S_Message_textevent.pcx name=i_TextEvent2Icon group=Icons mips=Off flags=2

var() enum ETextAnimation {
  ANIM_Default,
  ANIM_Alert,
  ANIM_Special,
} TextAnimation;

// TODO Fade vs Wiping vs Radial wipe text, parameterize font
// bool option for wipe to make wipe fade in/out time per character instead of for whole text

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
    getAnimation;
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

simulated function byte getAnimation() {
  return textAnimation;
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
    rep.giveToMyOwner(self);
  } else {
    foreach allactors(class'PlayerPawn', pp) {
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
        rep.touch(pp);
      }
      rep.giveToMyOwner(self);
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
}
