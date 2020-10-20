class PointAndClickEvent extends Triggers;

/**
I dreaded documenting this class for so long. This class allows mappers to 
set up point and click adventure game style sequences, but it is a little 
complicated to use. You need one of these, a camera, a series of 
MouseTriggers whose tags match the mouseEventTag field of this actor. 
Trigger this actor to start the event, trigger again to end. You can also 
use a PCADumper to end an event.
*/

#exec texture import file="Textures\i_pca.pcx" name=i_pointclick group=icons mips=off flags=2

var() name mouseEventTag; //IMPORTANT!: The tag of all MouseTriggers and PCAText actors associated with this event
var() FiretrucksCamera cameraToUse; //The canera to be used
var() bool enabled; //Whether or not this actor is enabled

var bool isActive;

function Trigger(actor Other, pawn EventInstigator) {
  local MouseTriggers mt;
  local PCAText pcat;
  local PlayerPawn pp;
  local FiretrucksPlayer fp;
  
  if (!enabled) return;

  foreach allActors(class'PlayerPawn', pp) {
    if (FiretrucksPlayer(pp) != none) {
      fp = FiretrucksPlayer(pp);
      //allright, need to tell player that PCA has gone off
      if (isActive) {
        fp.restorePlayerView(self);
      } else {
        fp.switchPlayerView(cameraToUse, self, true);
      }
      isActive = !isActive;
    }
  }

  //log(self@"isActive:"@isActive);

  //we also need to let our actor know that they should be ready
  foreach allActors(class'MouseTriggers', mt, mouseEventTag) {
    mt.active = isActive;
  } 

  foreach allActors(class'PCAText', pcat, mouseEventTag) {
    pcat.active = isActive;
  }
}

defaultproperties
{
  Texture=Texture'Firetrucks.Icons.i_pointclick'
  enabled=true
}
