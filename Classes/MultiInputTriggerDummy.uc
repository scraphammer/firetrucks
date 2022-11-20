class MultiInputTriggerDummy extends Actor nousercreate;

function trigger(Actor o, Pawn ei) {
  if (owner == none) return;
  if (MultiInputTriggers(Owner) != none) MultiInputTriggers(Owner).dummyCallback(o, ei, tag);
}

defaultproperties {
  bHidden=true
}