//=============================================================================
// FSMState.
//=============================================================================
class FSMState extends StateMachine;

#exec texture import file=Textures\state.pcx name=i_fsmstate group=Icons mips=Off

/**
Actor class representing a single state within the finite state machine.
*/

var() FSMState transitions[16]; //Transitions on an enumerated input. If an input is received with no listed transition it is ignored and discarded.

//have some selection rendering

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_fsmstate'
}
