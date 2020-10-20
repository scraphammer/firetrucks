//=============================================================================
// FiretruckFactory.
//=============================================================================
class FiretruckFactory extends Keypoint;

#exec texture import file=Textures\firetruck.pcx name=i_firetruck group=Icons mips=Off flags=2
/**
A cleaner ThingFactor/CreatureFactory that also has additional functionality. It fires its <span>event</span> when finishing.
 */

var() class<Actor> prototype; //The class to be spawned.
var() int numToSpawn; //The number of things to spawn.
var() name spawnpointTag; //The tag of the spawnpoints.
var() float spawnInterval; //The time inbetween spawns.
var() bool enabled; //Whether or not this actor is enable.
var() bool disableAfterUse; //Whether or not it should disable itself after use.
var() Actor attachSpawnsTo; //I didn't test this feature.
var(Events) name theSpawnTag; //The tag for the spawns.
var(Events) name theSpawnEvent; //The <span>event</span> for the spawns.
var(Creatures) name alarmTag; //The <span>alarmTag</span> (for ScriptedPawn subclasses only).
var(Creatures) name orders; //The <span>orders</span> (for ScriptedPawn subclasses only).
var(Creatures) name orderTag; //The <span>orderTag</span> (for ScriptedPawn subclasses only).

var int numSpawned;

function Trigger(actor Other, pawn EventInstigator) {
  if (!enabled) return;
  if (prototype == none) return;
  
  if (numToSpawn > 0) {
    spawnOne();
    setTimer(spawnInterval, true);
  }
  
  if (disableAfterUse) enabled = false;
}

function spawnOne() {
  local Actor a;
  local ScriptedPawn p;
  local Spawnpoint sp;
  local int pointcount, result;
  numSpawned++;
  
  foreach allActors(class'Spawnpoint', sp, spawnpointTag) pointcount++;
  result = rand(pointcount);
  foreach allActors(class'Spawnpoint', sp, spawnpointTag) {
    if (result <= 0) {
      a = spawn(prototype,, theSpawnTag, sp.location, sp.rotation);
      if (theSpawnEvent != '') a.event = theSpawnEvent;
      if (AttachSpawnsTo != none) a.setBase(attachSpawnsTo);
      
      if (ScriptedPawn(a) != none) {
        p = ScriptedPawn(a);
        p.alarmTag = alarmTag;
        p.orders = orders;
        p.orderTag = orderTag;
      }
      
      break;
    } else {
      result--;
    }
  }
}

function timer() {
  spawnOne();
  if (numSpawned >= numToSpawn) {
    triggerEvent(event, Self, Instigator);
    setTimer(0, false);
  }
}

defaultproperties
{
				Enabled=True
				bStatic=False
				Texture=Texture'Firetrucks.Icons.i_firetruck'
}
