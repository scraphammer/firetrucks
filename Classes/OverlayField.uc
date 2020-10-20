//=============================================================================
// OverlayField.
//=============================================================================
class OverlayField extends Keypoint;

#exec texture import file=Textures\staticfield.pcx name=i_StaticField group=Icons mips=Off flags=2

/**
Displays an overlay on the HUD for players within its radius.
*/

var() float sphereRadius; //The spherical radius of this actor.
var() bool gradualDistribution; //Whether or not the overlay opacity should adjust based on player distance.
var() Texture overlayTexture; //The texture to use for the overlay.
var() float alpha; //How opaque the overlay is, between 0.0 (invisible) and 1.0 (fully opaque).

var() localized editconst const string SRNote; //"Collision is auto-set from this value."

function postBeginPlay() {
  alpha = fmax(0, alpha);
  setCollisionSize(sphereRadius, sphereRadius);
}

defaultproperties
{
				SphereRadius=384.000000
				gradualDistribution=True
				Alpha=0.500000
				SRNote="Collision is auto-set from this value."
				bStatic=False
				Texture=Texture'Firetrucks.Icons.i_StaticField'
				bCollideActors=True
}
