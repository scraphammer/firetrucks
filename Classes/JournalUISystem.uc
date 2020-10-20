//=============================================================================
// JournalUISystem.
//=============================================================================
class JournalUISystem extends JournalUI
  abstract;
/**
lol OOP much?
*/

enum EscapeType {
  ET_None,
  ET_Newline,
  ET_Tab,
};

var() bool useMouse;
var transient float mouseX, mouseY;
var transient JournalListNode currentDisplayNode;

simulated function draw(Canvas c, Journal j) {
  if (useMouse) {
    c.style = 1;
    changecolor(c, 255, 255, 255);
    c.setPos(mouseX, mouseY);
  }
}

simulated static function drawFormatted(canvas c, string s, optional bool indent) {
  local string formatted;
  local EscapeType et;
  local float xoffset, voffset, oldvoffset;
  local int length;
  if (s == "") return;
  length = len(s);
  if (indent) formatted = "    ";
  while (len(s) > 0) {
    et = escape(s, formatted, length);
    if (et == ET_None) {
      formatted $= s;
      break;
    } else if (et == ET_Newline) {
      c.StrLen(formatted, xoffset, voffset);
      oldvoffset += voffset;
      if (formatted != "") c.drawText(formatted);
      if (indent) formatted = "    ";
      else formatted = "";
      c.setpos(0, oldVoffset);
    }
  }
  if (formatted != "") c.drawText(formatted);
}

simulated static function EscapeType escape(out string s, out string u, out int length) {
  local int i, j;
  local string t, q;
  local bool slash, end;
  local EscapeType et;
  local string latest;
  q = s;
  j = length;
  latest = left(q, 0);
  for (i = 0; i < j && !end ; i++) {
    if (asc(latest) == 35 && !slash) {
      slash = true;
    } else if (asc(latest) == 35 && slash) {
      t $= "##";
      slash = false;
    } else if (slash && asc(latest) == 110) {
      et = ET_Newline;
      end = true;
    } else {
      t $= latest;
    }
    latest = mid(q, i, 1);
    length--;
  }
  s = mid(q, i - 1);
  u $= t;
  return et;
}

simulated static function changeColor(canvas c, int r, int g, int b) {
  c.DrawColor.r = r;
  c.DrawColor.g = g;
  c.DrawColor.b = b;
}

defaultproperties
{
}
