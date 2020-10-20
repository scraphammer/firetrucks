class ReferenceTrigger extends Triggers;
/**
Have you ever been like, "Regular UE1 events are too slow! I want to
directly call trigger() on an actor without the overhead!" No? Oh well...
 Extra fun points because this also needs to be triggered too.
*/

#exec texture import file=Textures\i_ref.pcx name=i_ref group=Icons mips=off flags=2

var() Actor reference; //the Actor to call trigger()
var() bool fireEventToo; //also call this Actor's <span>event</span>

function trigger(actor o, pawn ei) {
  if (fireEventToo) triggerEvent(event, o, ei);
  if (reference != none) reference.trigger(o, ei);
}

defaultproperties {
  texture=i_ref
  fireEventToo=false
}
