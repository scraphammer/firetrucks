//=============================================================================
// FSMInputDummy.
//=============================================================================
class FSMInputDummy extends StateMachine nousercreate;

/**
  For handling input to the state machine. These are created automatically during runtime and not to be placed in the map.
*/

var byte symbol;

function Trigger(actor Other, pawn EventInstigator) {
  if (owner == none) return;
  if (FiniteStateMachine(Owner) != none) FiniteStateMachine(owner).transition(symbol);
}

defaultproperties
{
}
