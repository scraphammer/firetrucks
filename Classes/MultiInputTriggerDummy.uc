class MultiInputTriggerDummy extends Actor nousercreate;

function trigger(Actor o, Pawn ei) {
  if (owner == none) return;
  if (MultiInputTriggers(Owner) != none) MultiInputTriggers(Owner).dummyCallback(o, ei, tag);
}

function untrigger(Actor o, Pawn ei) {
  if (owner == none) return;
  if (MultiInputTriggers(Owner) != none) MultiInputTriggers(Owner).dummyUnCallback(o, ei, tag);
}

defaultproperties {
  bHidden=true
}