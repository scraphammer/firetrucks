class ActorBuilder extends Object;

var protected bool bHidden_def;
var protected bool bHidden_;

// Display properties
var protected bool bUnlit_def;
var protected bool bUnlit_;
var protected bool bNoSmooth_def;
var protected bool bNoSmooth_;
var protected bool bParticles_def;
var protected bool bParticles_;
var protected bool bRandomFrame_def;
var protected bool bRandomFrame_;
var protected bool bMeshEnviroMap_def;
var protected bool bMeshEnviroMap_;
var protected bool bFilterByVolume_def;
var protected bool bFilterByVolume_;
var protected bool bShadowCast_def;
var protected bool bShadowCast_;
var protected bool bCustomDrawActor_def;
var protected bool bCustomDrawActor_;

// Collision flags.
var protected bool bCollideWorld_def;
var protected bool bCollideWorld_;
var protected bool bBlockActors_def;
var protected bool bBlockActors_;
var protected bool bBlockPlayers_def;
var protected bool bBlockPlayers_;

// Lighting.
var protected bool bSpecialLit_def;
var protected bool bSpecialLit_;
var protected bool bActorShadows_def;
var protected bool bActorShadows_;
var protected bool bCorona_def;
var protected bool bCorona_;
var protected bool bForcedCorona_def;
var protected bool bForcedCorona_;
var protected bool bLensFlare_def;
var protected bool bLensFlare_;
var protected bool bDarkLight_def;
var protected bool bDarkLight_;
var protected bool bZoneNormalLight_def;
var protected bool bZoneNormalLight_;

// Physics options.
var protected bool bBounce_def;
var protected bool bBounce_;
var protected bool bFixedRotationDir_def;
var protected bool bFixedRotationDir_;
var protected bool bRotateToDesired_def;
var protected bool bRotateToDesired_;


var protected bool ActorRenderColor_def;
var protected color ActorRenderColor_;
var protected bool ActorGUnlitColor_def;
var protected color ActorGUnlitColor_;
var protected bool AmbientGlowColor_def;
var protected color AmbientGlowColor_;
var protected bool CollisionOverride_def;
var protected Primitive CollisionOverride_;

var protected bool DrawScale3D_def;
var protected vector DrawScale3D_;

var protected bool UserData_def;
var protected map<name,any> UserData_;

// Priority Parameters
var protected bool Physics_def;
var protected Actor.EPhysics Physics_;

// Animation variables.
var protected bool AnimSequence_def;
var protected name AnimSequence_;
var protected bool AnimFrame_def;
var protected float AnimFrame_;
var protected bool AnimRate_def;
var protected float AnimRate_;

var protected bool LODBias_def;
var protected float LODBias_;

// Major actor properties.
var protected bool Tag_def;
var protected name Tag_;
var protected bool Event_def;
var protected name Event_;

/*

TODO the rest

// The actor's position and rotation.
var(Movement) vector Location;		// Actors initial location.
var(Movement) rotator Rotation;		// Actors initial rotation.
var(Movement) vector Velocity;		// Velocity.
var(Movement) vector Acceleration;	// Acceleration.

//-----------------------------------------------------------------------------
// Display properties.

// Drawing effect.
var(Display) Actor.EDrawType DrawType;

// Style for rendering sprites, meshes.
var(Display) Actor.ERenderStyle Style;

// Other display properties.
var(Display) texture    Sprite;			 // Sprite texture if DrawType=DT_Sprite.
var(Display) texture    Texture;		 // Misc texture (i.e: environment texture).
var(Display) texture    Skin;            // Mesh skin #1.
var(Display) mesh       Mesh;            // Mesh if DrawType=DT_Mesh.
var(Display) mesh       ShadowMesh;      // If Mesh, DrawType=DT_Mesh and bShadowCast, use this mesh for casting the shadow.
var(Display) float DrawScale;// Scaling factor, 1.0=normal size.
var(Display) vector PrePivot;// Offset from box center for drawing.
var(Display) float ScaleGlow;// Multiplies lighting scale.
var(Display) float VisibilityRadius;// Actor is drawn if viewer is within its visibility radius. Zero=infinite visibility. Negative=hidden if within radius. In AmbientSound it can be used to set the factor how much the sound can be occluded (by obstacles).
var float VisibilityHeight;				 // unused since 227j.
var(Display) byte AmbientGlow;// Ambient brightness, or 255=pulsing.
var(Display) byte Fatness;   // Fatness in UU (mesh distortion), 128 = default.
var(Display) float SpriteProjForward;// Distance forward to draw sprite from actual location.
var(Display) float AmbientGlowPulseSpeed; //pulse speed for AmbientGlow.

// Multiple skin support.
var(Display) texture	MultiSkins[8]; // Mesh skins #0-7.

//-----------------------------------------------------------------------------
// Sound.

// Ambient sound.
var(Sound) byte SoundRadius;	 // Radius of ambient sound.
var(Sound) byte SoundVolume;	 // Volume of amient sound.
var(Sound) byte SoundPitch;	     // Sound pitch shift, 64.0=none.
var(Sound) sound AmbientSound;    // Ambient sound effect.

//-----------------------------------------------------------------------------
// Collision.

// Collision size.
var(Collision) float CollisionRadius; // Radius of collision cyllinder.
var(Collision) float CollisionHeight; // Half-height cyllinder.

//-----------------------------------------------------------------------------
// Lighting.

// Light modulation.
var(Lighting) Actor.ELightType LightType;

// Spatial light effect to use.
var(Lighting) Actor.ELightEffect LightEffect;

// Lighting info.
var(LightColor) byte
	LightBrightness,
	LightHue,
	LightSaturation;

// Light properties.
var(Lighting) byte
	LightRadius, // Lighting radius = 25 X (LightRadius+1).
	LightPeriod, // Lighting 'speed' of LT_Pulse, LT_Blink, LT_SubtlePulse, LT_TexturePaletteLoop and LE_Searchlight.
	LightPhase, // Lighting time offset in LT_Pulse, LT_Blink, LT_SubtlePulse, LT_TexturePaletteLoop and LE_Searchlight.
	LightCone, // Light cone in LE_Spotlight.
	VolumeBrightness,
	VolumeRadius, // Volumetric fog radius = 25 X (VolumeRadius+1).
	VolumeFog;

// Lighting.
var transient float		CoronaAlpha;	// Corona fade brightness (227g: moved from Render to Actor).

// Normal (bump)mapping (depends on lighting information)
var(NormalLighting) float NormalLightRadius; // To configure a radius in which normal mapping appears, independently from LightRadius. 0 (default) disables the effect except for LE_Sunlight.

//-----------------------------------------------------------------------------
// Physics.

// Physics properties.
var(Movement) float       Mass;            // Mass of this actor.
var(Movement) float       Buoyancy;        // Water buoyancy (if higher than Mass, actor will float).
var(Movement) rotator RotationRate;    // Change in rotation per second.
var(Movement) rotator DesiredRotation; // Physics will rotate pawn to this if bRotateToDesired.

*/

// Builder functions
function ActorBuilder bHidden(bool value) { bHidden_def = true; bHidden_ = value; return self; }

function ActorBuilder bUnlit(bool value) { bUnlit_def = true; bUnlit_ = value; return self; }
function ActorBuilder bNoSmooth(bool value) { bNoSmooth_def = true; bNoSmooth_ = value; return self; }
function ActorBuilder bParticles(bool value) { bParticles_def = true; bParticles_ = value; return self; }
function ActorBuilder bRandomFrame(bool value) { bRandomFrame_def = true; bRandomFrame_ = value; return self; }
function ActorBuilder bMeshEnviroMap(bool value) { bMeshEnviroMap_def = true; bMeshEnviroMap_ = value; return self; }
function ActorBuilder bFilterByVolume(bool value) { bFilterByVolume_def = true; bFilterByVolume_ = value; return self; }
function ActorBuilder bShadowCast(bool value) { bShadowCast_def = true; bShadowCast_ = value; return self; }
function ActorBuilder bCustomDrawActor(bool value) { bCustomDrawActor_def = true; bCustomDrawActor_ = value; return self; }

function ActorBuilder bCollideWorld(bool value) { bCollideWorld_def = true; bCollideWorld_ = value; return self; }
function ActorBuilder bBlockActors(bool value) { bBlockActors_def = true; bBlockActors_ = value; return self; }
function ActorBuilder bBlockPlayers(bool value) { bBlockPlayers_def = true; bBlockPlayers_ = value; return self; }

function ActorBuilder bSpecialLit(bool value) { bSpecialLit_def = true; bSpecialLit_ = value; return self; }
function ActorBuilder bActorShadows(bool value) { bActorShadows_def = true; bActorShadows_ = value; return self; }
function ActorBuilder bCorona(bool value) { bCorona_def = true; bCorona_ = value; return self; }
function ActorBuilder bForcedCorona(bool value) { bForcedCorona_def = true; bForcedCorona_ = value; return self; }
function ActorBuilder bLensFlare(bool value) { bLensFlare_def = true; bLensFlare_ = value; return self; }
function ActorBuilder bDarkLight(bool value) { bDarkLight_def = true; bDarkLight_ = value; return self; }
function ActorBuilder bZoneNormalLight(bool value) { bZoneNormalLight_def = true; bZoneNormalLight_ = value; return self; }

function ActorBuilder bBounce(bool value) { bBounce_def = true; bBounce_ = value; return self; }
function ActorBuilder bFixedRotationDir(bool value) { bFixedRotationDir_def = true; bFixedRotationDir_ = value; return self; }
function ActorBuilder bRotateToDesired(bool value) { bRotateToDesired_def = true; bRotateToDesired_ = value; return self; }

function ActorBuilder ActorRenderColor(color value) { ActorRenderColor_def = true; ActorRenderColor_ = value; return self; }
function ActorBuilder ActorGUnlitColor(color value) { ActorGUnlitColor_def = true; ActorGUnlitColor_ = value; return self; }
function ActorBuilder AmbientGlowColor(color value) { AmbientGlowColor_def = true; AmbientGlowColor_ = value; return self; }
function ActorBuilder CollisionOverride(Primitive value) { CollisionOverride_def = true; CollisionOverride_ = value; return self; }

function ActorBuilder DrawScale3D(vector value) { DrawScale3D_def = true; DrawScale3D_ = value; return self; }

function ActorBuilder UserData(name key, any value) { UserData_def = true; UserData_[key] = value; return self; }

function ActorBuilder Physics(Actor.EPhysics value) { Physics_def = true; Physics_ = value; return self; }

function ActorBuilder AnimSequence(name value) { AnimSequence_def = true; AnimSequence_ = value; return self; }
function ActorBuilder AnimFrame(float value) { AnimFrame_def = true; AnimFrame_ = value; return self; }
function ActorBuilder AnimRate(float value) { AnimRate_def = true; AnimRate_ = value; return self; }

function ActorBuilder LODBias(float value) { LODBias_def = true; LODBias_ = value; return self; }

function ActorBuilder Tag(name value) { Tag_def = true; Tag_ = value; return self; }
function ActorBuilder Event(name value) { Event_def = true; Event_ = value; return self; }

function Actor build_(class<Actor> clazz, Actor accessor) {
  local Actor a;
  a = accessor.spawn(clazz);
	if (bHidden_def) a.bHidden = bHidden_;

	if (bUnlit_def) a.bUnlit = bUnlit_;
	if (bNoSmooth_def) a.bNoSmooth = bNoSmooth_;
	if (bParticles_def) a.bParticles = bParticles_;
	if (bRandomFrame_def) a.bRandomFrame = bRandomFrame_;
	if (bMeshEnviroMap_def) a.bMeshEnviroMap = bMeshEnviroMap_;
	if (bFilterByVolume_def) a.bFilterByVolume = bFilterByVolume_;
	if (bShadowCast_def) a.bShadowCast = bShadowCast_;
	if (bCustomDrawActor_def) a.bCustomDrawActor = bCustomDrawActor_;

	if (bCollideWorld_def || bBlockActors_def || bBlockPlayers_def) {
		a.setCollision(
      (bCollideWorld_def) ? bCollideWorld_ : a.bCollideWorld,
      (bBlockActors_def) ? bBlockActors_ : a.bBlockActors,
      (bBlockPlayers_def) ? bBlockPlayers_ : a.bBlockPlayers
		);
	}

  if (bSpecialLit_def) a.bSpecialLit = bSpecialLit_;
	if (bActorShadows_def) a.bActorShadows = bActorShadows_;
	if (bCorona_def) a.bCorona = bCorona_;
	if (bForcedCorona_def) a.bForcedCorona = bForcedCorona_;
	if (bLensFlare_def) a.bLensFlare = bLensFlare_;
	if (bDarkLight_def) a.bDarkLight = bDarkLight_;
	if (bZoneNormalLight_def) a.bZoneNormalLight = bZoneNormalLight_;

  if (bBounce_def) a.bBounce = bBounce_;
  if (bFixedRotationDir_def) a.bFixedRotationDir = bFixedRotationDir_;
  if (bRotateToDesired_def) a.bRotateToDesired = bRotateToDesired_;

	if (ActorRenderColor_def) a.ActorRenderColor = ActorRenderColor_;
	if (ActorGUnlitColor_def) a.ActorGUnlitColor = ActorGUnlitColor_;
	if (AmbientGlowColor_def) a.AmbientGlowColor = AmbientGlowColor_;
	if (CollisionOverride_def) a.CollisionOverride = CollisionOverride_;

	if (DrawScale3D_def) a.DrawScale3D = DrawScale3D_;

	if (UserData_def) a.UserData = UserData_;

	if (Physics_def) a.SetPhysics(Physics_);

	if (AnimSequence_def) a.AnimSequence = AnimSequence_;
	if (AnimFrame_def) a.AnimFrame = AnimFrame_;
	if (AnimRate_def) a.AnimRate = AnimRate_;

	if (LODBias_def) a.LODBias = LODBias_;

	if (Tag_def) a.Tag = Tag_;
	if (Event_def) a.Event = Event_;

	return a;
}