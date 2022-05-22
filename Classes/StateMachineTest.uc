//=============================================================================
// StateMachineTest: When triggered, if the specified state machine is in the
// specified state, fires its event. For when you've given up all hope of
// making your overly complicated state machine work the proper way...
//=============================================================================
class StateMachineTest extends StateMachine;

#exec texture import file=Textures\stateCheckerDispatcher.pcx name=stateCheckerDispatcher group=Icons mips=Off

var(Events) name testFailEvent;
var() FiniteStateMachine stateMachine;
var() FSMState desiredState;

function Trigger(actor Other, pawn EventInstigator) {
  if (stateMachine == none || desiredState == none) return;
  if (stateMachine.currentstate == desiredState) {
    triggerEvent(event, self, instigator);
  } else {
    triggerEvent(testFailEvent, self, instigator);
  }
}

defaultproperties {
  Texture=Texture'stateCheckerDispatcher'
}
