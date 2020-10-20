//=============================================================================
// ForcedPathNode.
//=============================================================================
class ForcedPathNode extends PathNode;

#exec texture import file=Textures\forcedNode.pcx name=i_forced group=Icons mips=Off flags=2
#exec texture import file=Textures\forcedNodeReject.pcx name=i_forcedReject group=Icons mips=Off flags=2
#exec texture import file=Textures\forcedNodeIncoming.pcx name=i_forcedIn group=Icons mips=Off flags=2
#exec texture import file=Textures\forcedNodeOutgoing.pcx name=i_forcedout group=Icons mips=Off flags=2

/**
A special subclass of PathNode that can be configured to reject incoming and/or outgoing paths, as well as force pathing with NavagationPoints that match a given tag.
 */

var() bool acceptIncomingPaths; //Whether or not this actor should accept incoming paths that are not forced.
var() bool acceptOutgoingPaths; //Whether or not this actor should accept outgoing paths that are not forced.
var() name forceTag; //If set, it will force binding with all NavagationPoint actors that match this tag.

var(Advanced) Texture acceptTex;
var(Advanced) Texture rejectTex;
var(Advanced) Texture incomingTex;
var(Advanced) Texture outgoingTex;

function PathBuildingType EdPathBuildExec(NavigationPoint end, out int forcedDistance){
	if(ForcedPathNode(end) != none && (end.tag == forceTag || ForcedPathNode(end).forceTag == Tag)){
		return PATHING_Force;
	} else if (!acceptOutgoingPaths) {
	  return PATHING_Proscribe;
	} else return Super.EdPathBuildExec(End,ForcedDistance);
}

function bool CanBindWith(NavigationPoint start){
	if (start.tag == forceTag) return true;
  else return acceptIncomingPaths;
}

event DrawEditorSelection(Canvas c){
  if (acceptIncomingPaths && acceptOutgoingPaths) texture = acceptTex;
  else if (acceptIncomingPaths) texture = incomingTex;
  else if (acceptOutgoingPaths) texture = outgoingTex;
  else texture = rejectTex;
}

defaultproperties
{
				acceptIncomingPaths=True
				acceptOutgoingPaths=True
				acceptTex=Texture'Firetrucks.Icons.i_forced'
				rejectTex=Texture'Firetrucks.Icons.i_forcedReject'
				incomingTex=Texture'Firetrucks.Icons.i_forcedIn'
				outgoingTex=Texture'Firetrucks.Icons.i_forcedout'
				bEditorSelectRender=True
				Texture=Texture'Firetrucks.Icons.i_forced'
}
