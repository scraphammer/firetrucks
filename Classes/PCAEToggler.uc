class PCAEToggler extends Triggers;

/**
A class to toggle a PointAndClickEvent actor on or off.
*/

#exec texture import file=Textures/i_pcet.pcx name=i_pcaet group=Icons mips=off flags=2

var() enum actionType {
    AT_DISABLE,
    AT_ENABLE,
    AT_TOGGLE
} disablerType; //Whether to enable, disable, or toggle
var() PointAndClickEvent targetPCAE; //The PCAE to be toggled.

function Trigger(actor Other, pawn EventInstigator) {
    if (targetPCAE == none) return;
    
    switch(disablerType) {
        case AT_DISABLE:
            targetPCAE.enabled = false;
            break;
        case AT_ENABLE:
            targetPCAE.enabled = true;
            break;
        case AT_TOGGLE:
            targetPCAE.enabled = !targetPCAE.enabled;
            break;
    }
}

defaultproperties {
  texture=i_pcaet
}

