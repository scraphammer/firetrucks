class SpecialEventBuilder extends ActorBuilder nousercreate;

var protected int Damage_;
var protected bool Damage_def;
var protected name DamageType_;
var protected bool DamageType_def;
var protected localized string DamageString_;
var protected bool DamageString_def;
var protected Sound Sound_;
var protected bool Sound_def;
var protected localized string Message_;
var protected bool Message_def;
var protected bool bBroadcast_;
var protected bool bBroadcast_def;
var protected bool bPlayerViewRot_;
var protected bool bPlayerViewRot_def;
var protected bool bInteractivePathing_;
var protected bool bInteractivePathing_def;
var protected name state_;
var protected bool state_def;

function SpecialEventBuilder Damage(int value) { Damage_def = true; Damage_ = value; return self; }
function SpecialEventBuilder DamageType(name value) { DamageType_def = true; DamageType_ = value; return self; }
function SpecialEventBuilder DamageString(string value) { DamageString_def = true; DamageString_ = value; return self; }
function SpecialEventBuilder Sound(Sound value) { Sound_def = true; Sound_ = value; return self; }
function SpecialEventBuilder Message(string value) { Message_def = true; Message_ = value; return self; }
function SpecialEventBuilder bBroadcast(bool value) { bBroadcast_def = true; bBroadcast_ = value; return self; }
function SpecialEventBuilder bPlayerViewRot(bool value) { bPlayerViewRot_def = true; bPlayerViewRot_ = value; return self; }
function SpecialEventBuilder bInteractivePathing(bool value) { bInteractivePathing_def = true; bInteractivePathing_ = value; return self; }

function SpecialEvent build(Actor accessor) {
  local SpecialEvent specialEvent;
  specialEvent = SpecialEvent(super.build_(class'SpecialEvent', accessor));
  
  if (Damage_def) specialEvent.Damage = Damage_;
  if (DamageType_def) specialEvent.DamageType = DamageType_;
  if (DamageString_def) specialEvent.DamageString = DamageString_;
  if (Sound_def) specialEvent.Sound = Sound_;
  if (Message_def) specialEvent.Message = Message_;
  if (bBroadcast_def) specialEvent.bBroadcast = bBroadcast_;
  if (bPlayerViewRot_def) specialEvent.bPlayerViewRot = bPlayerViewRot_;
  if (bInteractivePathing_def) specialEvent.bInteractivePathing = bInteractivePathing_;

  if (state_def) specialEvent.gotoState(state_);

  return specialEvent;
}