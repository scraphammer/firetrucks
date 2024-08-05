class KeypadScriptedTextureNotifier extends Actor;

var DigitalCodeTrigger digitalCodeTrigger;

event RenderTexture(ScriptedTexture s) {

  if (digitalCodeTrigger == none) return;

  s.DrawText(0,0,digitalCodeTrigger.buffer,Font'WeedrowFont');
}

defaultproperties {
  bHidden=true
  bStatic=true
}