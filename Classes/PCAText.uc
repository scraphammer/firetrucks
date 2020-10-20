class PCAText extends Keypoint;

/**
Displays Text on the HUD during a PointAndClickEvent. Make sure to set the tag!
*/

#exec texture import name=i_pcatext file=Textures\i_pcatext.pcx group="Icons" mips=off flags=2

var() localized string text; //The text you want to display

var PointAndClickEvent pcaEvent;

var bool active;

defaultproperties
{
	Text="The mapper didn't enter any text :("
				Texture=Texture'Firetrucks.Icons.i_pcatext'
}
