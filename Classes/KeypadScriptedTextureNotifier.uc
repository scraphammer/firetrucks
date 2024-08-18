class KeypadScriptedTextureNotifier extends Actor;

var DigitalCodeTrigger digitalCodeTrigger;

event RenderTexture(ScriptedTexture s) {

  if (digitalCodeTrigger == none) return;

  if (digitalCodeTrigger.buffer != "") s.DrawText(0,0,digitalCodeTrigger.buffer,Font'WeedrowFont');
  else s.DrawText(0,0,">",Font'WeedrowFont');
}

defaultproperties {
  bHidden=true
  bStatic=true
}