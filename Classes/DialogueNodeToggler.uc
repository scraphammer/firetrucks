//=============================================================================
// DialogueNodeToggler.
//=============================================================================
class DialogueNodeToggler extends Triggers;

#exec texture import file=Textures\DialogueNodeDisabler.pcx name=i_dnodedis group=Icons mips=Off flags=2

//disables/enables/toggles dialog nodes when triggered

/**
Enables, disables, or toggles DialogueNode actors.
*/

var() enum actionType {
    AT_DISABLE,
    AT_ENABLE,
    AT_TOGGLE
} disablerType; //Whether to enable, disable, or toggle a node.
var() DialogueNode targetDialogueNode; //The DialogueNode to be toggled.

function Trigger(actor Other, pawn EventInstigator) {
    if (targetDialogueNode == none) return;
    
    switch(disablerType) {
        case AT_DISABLE:
            targetDialogueNode.enabled = false;
            break;
        case AT_ENABLE:
            targetDialogueNode.enabled = true;
            break;
        case AT_TOGGLE:
            targetDialogueNode.enabled = !targetDialogueNode.enabled;
            break;
    }
    if (event != '') triggerEvent(event, other, eventInstigator);
}

defaultproperties
{
				Texture=Texture'Firetrucks.Icons.i_dnodedis'
}
