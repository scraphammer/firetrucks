class MultiCamDummy extends Actor nousercreate;

/**
A dummy class for receiving events and passing them on to the MultiCam.
*/

var byte dir;

function trigger(Actor o, Pawn ei) {
  if (owner == none) return;
  if (MultiCam(Owner) != none) MultiCam(Owner).dummyCallback(dir);
}

