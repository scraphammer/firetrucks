class ToolTipAssociator expands MouseTriggers;

/**
Displays a tooltip when mousing over the target. If you want a tooltip and 
a click event use one of each with the same target.
*/

#exec texture import name=i_tooltip file=Textures\i_tooltip.pcx group="Icons" mips off flags=2

var() localized string tooltipString; //The tooltip you want to display.

defaultproperties
{
				ToolTipString="Tooltip Missing!"
				EventType=MET_NONE
				overrideCursor=OCT_NOOVERRIDE
				Texture=Texture'Firetrucks.Icons.i_tooltip'
}
