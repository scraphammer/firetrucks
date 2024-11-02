//=============================================================================
// PawnHealthChecker: Checks the health of the EventInstigator
//=============================================================================
class PawnHealthChecker extends Triggers;

#exec texture import file=Textures\i_pawnhealthtester.pcx name=i_pawnhealthtester group=Icons mips=Off flags=2

var() int Threshold; 
var() enum CheckTypeEnum {
  CT_GREATER,
  CT_GREATEREQUAL,
  CT_EQUAL,
  CT_LESS,
  CT_LESSEQUAL,
} CheckType;

var(Events) name EventOnFail;

function Trigger(actor Other, pawn EventInstigator) {
  if (EventInstigator == none) {
    if (EventOnFail == '') return;
    else triggerEvent(EventOnFail, other, eventInstigator);
  }
  switch(CheckType) {
    case CT_GREATER:
      if (EventInstigator.health > Threshold) triggerEvent(event, other, eventInstigator);
      else triggerEvent(EventOnFail, other, eventInstigator);
      break;
    case CT_GREATEREQUAL:
      if (EventInstigator.health >= Threshold) triggerEvent(event, other, eventInstigator);
      else triggerEvent(EventOnFail, other, eventInstigator);
      break;
    case CT_EQUAL:
      if (EventInstigator.health == Threshold) triggerEvent(event, other, eventInstigator);
      else triggerEvent(EventOnFail, other, eventInstigator);
      break;
    case CT_LESS:
      if (EventInstigator.health < Threshold) triggerEvent(event, other, eventInstigator);
      else triggerEvent(EventOnFail, other, eventInstigator);
      break;
    case CT_LESSEQUAL:
      if (EventInstigator.health <= Threshold) triggerEvent(event, other, eventInstigator);
      else triggerEvent(EventOnFail, other, eventInstigator);
      break;
  }
}

defaultproperties {
  CheckType=CT_GREATEREQUAL
  Texture=Texture'firetrucks.icons.i_pawnhealthtester'
}