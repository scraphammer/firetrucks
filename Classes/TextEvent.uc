//=============================================================================
// TextEvent.
//=============================================================================
class TextEvent extends Triggers;

/**
Displays text on screen. Useful for conveying the main character's thoughts.
*/

var() localized string text; //The text to display.
var() localized float duration; //How long the message should be displayed.
var() localized Sound audio; //An optional sound effect to be played when triggered.

function timer() {
  local FiretrucksPlayer mwwte;
  foreach allactors(class'FiretrucksPlayer', mwwte) {
    mwwte.textEvent("");
  }
}

function Trigger(actor Other, pawn EventInstigator) {
  local PlayerPawn pp;
  local TextEvent te;
  
  //added in v1.1 to fix text event issue
  foreach allActors(class'TextEvent', te) {
    te.setTimer(0, false);
  }

  foreach allactors(class'PlayerPawn', pp) {
    if (audio != none) pp.PlaySound(audio, SLOT_None);
    if (FiretrucksPlayer(pp) != none) {
      FiretrucksPlayer(pp).textEvent(text);
      setTimer(duration, false);
    } else pp.clientMessage(text, 'pickup');
  }
}

defaultproperties
{
				duration=4.000000
				Texture=Texture'UnrealShare.S_Message'
}
