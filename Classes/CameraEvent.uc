//=============================================================================
// CameraEvent.
//=============================================================================
class CameraEvent extends Triggers;

#exec texture import file=Textures\cameraevent.pcx name=i_camEvent group=Icons mips=Off

/**
 When triggered, switches the player's view to a specified camera for a period of time.
 */

var() FiretrucksCamera cameraToUse; //The camera to be used for the event.
var() float duration; //The duration of the event, in seconds. If set to 0, it will last until retriggered.

var bool isActive;

function Trigger(actor Other, pawn EventInstigator) {
  if (cameraToUse == none) return;
  if (isActive) {
    restorePlayerView();
    isActive = false;
  } else {
    switchPlayerView();
    isActive = true;
    if (duration > 0) setTimer(duration, false);
  }
}

function timer() {
  if (isActive) {
    restorePlayerView();
    isActive = false;
    triggerEvent(event, Self, Instigator);
  }
}

simulated function switchPlayerView() {
    local PlayerPawn p;
    foreach allactors(class'playerpawn', p) {
       if (FiretrucksPlayer(p) != none) {
           FiretrucksPlayer(p).switchPlayerView(cameraToUse, self);
       }
   }
}

simulated function restorePlayerView() {
  local PlayerPawn p;
  if (cameraToUse == none) {
    if (FiretrucksPlayer(p) != none) FiretrucksPlayer(p).restorePlayerView(self, true);
    else return;
  }
  foreach allactors(class'playerpawn', p) {      
     if (FiretrucksPlayer(p) != none) {
         FiretrucksPlayer(p).restorePlayerView(self);
     }
  }
  triggerEvent(event, Self, Instigator);
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_camEvent'
}
