//=============================================================================
// FiniteStateMachine.
//=============================================================================
class FiniteStateMachine extends StateMachine;

#exec texture import file=Textures\statemachine.pcx name=i_fsm group=Icons mips=Off

/**
 This implementation of a state machine consists of a single centralized actor (of this class), and a seperate actor of class FSMState to represent each state of the state machine. When transitioning to a new state, the event of a the new state is triggered, such that your desired final state can trigger any event that it needs to. This also allows for other states to trigger events if need be.
 */

var() FSMState startState; //The starting state for this state machine.
var() name inputTags[16]; //When these tags are triggered, the machine will attempt to transition to another state along the corresponding number. For example, if tag 3 is triggered, it will transition to the state listed in slot 3 of the current state's transitions.

var FSMState currentstate;

function postBeginPlay() {
  local byte i;
  local FSMInputDummy fsmid;
  
  for (i = 0; i < 16; i++) {
    if (inputTags[i] == '') continue; 
    
    fsmid = spawn(class'FSMInputDummy', self, inputTags[i],,);
    fsmid.symbol = i;
  }
  
  currentState = startState;
}

function transition(byte symbol) {
  if (currentState == none) return;
  if (currentState.transitions[symbol] != none) {
    currentState = currentState.transitions[symbol];
    if (currentState.event != '') triggerEvent(currentState.event, Self, Instigator);
  }
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_fsm'
}
