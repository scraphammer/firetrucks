//=============================================================================
// StateMachineDebugger: highlights the currently active state of each state
// machine. Will save you a lot of headaches when a complex state machine doesn't work.
//=============================================================================
class StateMachineDebugger extends StateMachine;

#exec texture import file=Textures\stateHighlighted.pcx name=stateHighlighted group=Icons mips=Off
#exec texture import file=Textures\S_StateMachineDebugger.pcx name=S_StateMachineDebugger group=Icons mips=Off

var() bool bEnabled; // You'll never guess what this does!

event tick(float delta) {
  local FiniteStateMachine fsm;
  local FSMState fsstate;
  local StateMachineTest stateMachineTest;
  if (!bEnabled) return;
  foreach allactors(class'FSMState', fsstate) {
    fsstate.bhidden = false;
    fsstate.texture = texture'i_fsmstate';
  }
  foreach allactors(class'FiniteStateMachine', fsm) {
    fsm.bhidden = false;
    fsm.currentstate.texture = texture'stateHighlighted';
  }
  foreach allactors(class'StateMachineTest', stateMachinetest) {
    stateMachinetest.bhidden = false;
    if (stateMachinetest.stateMachine.currentstate == stateMachinetest.desiredState) stateMachinetest.texture = texture'stateHighlighted';
    else stateMachinetest.texture = Texture'stateCheckerDispatcher';
  }
}

defaultproperties {
  bEnabled=true
  Texture=Texture'S_StateMachineDebugger'
}