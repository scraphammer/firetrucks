//=============================================================================
// MouseEventAssociator
//=============================================================================
class MouseEventAssociator extends MouseTriggers;

/**
Fires its event when target is clicked on. Pretty easy really.
*/

#exec texture import name=i_mea file=Textures\i_mea.pcx group="Icons" MIPS=OFF flags=2

function fire(optional Pawn i) {
  triggerEvent(event, self, i);
  if (DisableAfterUse) enabled = false;
}

defaultproperties
{
  Texture=Texture'Firetrucks.Icons.i_mea'
}
