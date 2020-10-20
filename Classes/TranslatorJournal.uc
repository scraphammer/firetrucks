class TranslatorJournal extends Journal;

//UISystem=Class'ClassicJournalUI'
//message sound TransA3
defaultproperties {
  firstEntry="Translator Active"
  firstEntryText="You can use next weapon and previous weapon to scroll back to previous messages."
  pickupMessage="You picked up the translator."
  mesh=Mesh'translatormesh'
  pickupViewMesh=Mesh'UnrealShare.translatormesh'
  icon=Texture'UnrealShare.Icons.I_Tran'
  pickupSound=Sound'UnrealShare.Pickups.GenPickSnd'
  UISystem=Class'TranslatorJournalUI'
  newMessageSound=Sound'UnrealShare.TransA3'
  oldMessageSound=Sound'UnrealShare.TransA3'
}
