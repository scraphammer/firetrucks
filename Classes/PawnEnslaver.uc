//=============================================================================
// PawnEnslaver: A port of Qtit's PawnTrigger
//=============================================================================
class PawnEnslaver expands Triggers;

//a copy paste of TitPack0's PawnTrigger that proved so popular in weedrow's
//first adventure. Renamed to avoid confusion with upak's pawn trigger

/**
A port of Qtit's PawnTrigger from the previous Chronicles of Weedrow event, only renamed so it doesn't conflict with UPak.
I've cleaned up some of the language from the original author's comments from 11 years ago.
*/

var() ScriptedPawn Pawn; //The pawn to be manipulated.
var() name NewOrders; //The new orders for the pawn.
var() name NewOrderTag; //The new order tag for this pawn.
var() name NewAlarmTag; //The new alarm tag for this pawn.
var() name NewAnimation; //If set, the pawn attempts to play this animation. Most of the time, anyway.
var() bool NewAnimationbLoop; //If true, the pawn loops the specified animation instead of simply playing it once.
var bool RotateToward;   //Rotates toward an actor, pawn, player NOT WORKING
var actor TowardWhat;      //if 'none' rotates toward Player NOT WORKING;

function Trigger( actor Other, pawn EventInstigator )
{

   if(Pawn != none)
   {
      if(NewOrders != 'none')
      {
         Log(Pawn@ Pawn.Orders@ Pawn.OrderTag);
         Pawn.Orders = NewOrders;
         Pawn.OrderTag = NewOrderTag;
         Pawn.AlarmTag = NewAlarmTag;
         Pawn.Gotostate('StartUp'); //Reset the [actor]... doesn't want to change states, 
                                       //so we shall kill the previous state and start over.
      }
      if(NewAnimation != 'none')
      {
         if(NewAnimationbLoop)
            Pawn.LoopAnim(NewAnimation);
         else
            Pawn.PlayAnim(NewAnimation);
      }
   }
}

defaultproperties
{
				Texture=Texture'Engine.S_Corpse'
}
