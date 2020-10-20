//=============================================================================
// FiretrucksJournalUI.
//=============================================================================
class FiretrucksJournalUI extends JournalUISystem;
/**
A UI for the Journal. Follows a sort of zealously OOP paradigm
*/

#exec TEXTURE IMPORT NAME=journalpage FILE=TEXTURES\page.PCX GROUP=UI FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=journalpageShadow FILE=TEXTURES\page_shadow.PCX GROUP=UI MIPS=OFF
#exec TEXTURE IMPORT NAME=ui_page FILE=Textures\ui_page.pcx GROUP=UI MIPS=OFF flags=2
#exec TEXTURE IMPORT NAME=ui_page_shadow FILE=TEXTURES\ui_page_shadow.PCX GROUP=UI MIPS=OFF

//I'm not making another font, just going to import a truetype
#exec new TrueTypeFontFactory Name=PermanentMarker20 FontName="Permanent Marker" Height=20 AntiAlias=1
//find another font for scribbly text

var Texture enumTextures[5];
var Texture enumShadows[5];
var Font enumFonts[5];
var byte brightnesses[5];

simulated function draw(Canvas c, Journal j) {
  local float tempx, tempy, XL, YL;
  local JournalListEntry n;
  local string s;
  
  currentDisplayNode = j.latest;

  if (currentDisplayNode == none) return;
  
  n = currentDisplayNode.entry;

  tempx = c.clipx;
  tempy = c.clipy;
  
  c.bCenter = false;
  
  //draw background
  c.drawColor = makeColor(255, 255, 255);
  if (n.entryType > 0) {
    c.style = 4;
    c.SetPos(c.ClipX/2-266, c.ClipY/2-266);
    c.DrawRect(enumShadows[n.entryType], 532, 532);  
    c.style = 2;
    c.SetPos(c.ClipX/2-256, c.ClipY/2-256);
    c.DrawRect(enumTextures[n.entryType], 512, 512);
  } else {
    c.style = n.drawStyle;
    c.SetPos(c.ClipX/2-(n.width/2), c.ClipY/2-(n.height/2));
    c.drawRect(n.image, n.height, n.width);  
  }
  
  //draw everything else
	if (n.entryType > 0) {
	  c.Font = enumFonts[n.entryType];
	  c.style = 1;
	  //title
	  c.drawColor = makeColor(32, brightnesses[n.entryType], brightnesses[n.entryType]);
	  c.SetPos(c.ClipX/2-240, c.ClipY/2-240);
	  c.drawText(n.entryName);
	  //prev/next
    if (currentDisplayNode.prev != none) {
      c.SetPos(c.ClipX/2-240, c.ClipY/2+224);
      c.drawText(currentDisplayNode.prev.entry.entryName);
    }
    if (currentDisplayNode.next != none) {
      s = currentDisplayNode.next.entry.entryName;
      c.StrLen(s, XL, YL);
      c.SetPos(c.ClipX/2+240-XL, c.ClipY/2+224);
      c.drawText(s);
    }
    //page number
    c.SetPos(c.ClipX/2-4, c.ClipY/2+224);
    c.drawText("-");
    c.SetPos(c.ClipX/2+4, c.ClipY/2+224);
    c.drawText(j.length);
    s = (currentDisplayNode.index + 1) $ "";
    c.StrLen(s, XL, YL);
    c.SetPos(c.ClipX/2 - 4 - XL, c.ClipY/2+224);
    c.drawText(s);
    
    //pictures
    if (n.image != none) {
      c.drawColor = makeColor(255, 255, 255);
      c.style = n.drawStyle;
      c.SetPos(c.ClipX/2-(n.width/2), c.ClipY/2-(n.height/2));
      c.drawRect(n.image, n.height, n.width);
    }
    //context
    c.style = 1;
    c.drawColor = makeColor(brightnesses[n.entryType], brightnesses[n.entryType], brightnesses[n.entryType]);
    c.SetOrigin(c.ClipX/2-240, c.ClipY/2-208);
  	c.SetClip(480,464);
  	c.SetPos(0,0);;
    drawFormatted(c, n.entryText, n.indent);

	}
  
  c.clipx = tempx;
  c.clipy = tempy;
  c.reset();
  
  super.draw(c, j);
}

defaultproperties
{
  enumTextures(0)=Texture'Firetrucks.UI.journalpage'
  enumTextures(1)=Texture'Firetrucks.UI.journalpage'
  enumTextures(2)=Texture'Firetrucks.UI.journalpage'
  enumTextures(3)=Texture'Firetrucks.UI.ui_page'
  enumTextures(4)=Texture'Firetrucks.UI.journalpage'
  enumShadows(0)=Texture'Firetrucks.UI.journalpageShadow'
  enumShadows(1)=Texture'Firetrucks.UI.journalpageShadow'
  enumShadows(2)=Texture'Firetrucks.UI.journalpageShadow'
  enumShadows(3)=Texture'Firetrucks.UI.ui_page_shadow'
  enumShadows(4)=Texture'Firetrucks.UI.journalpageShadow'
  enumFonts(0)=Font'Firetrucks.PermanentMarker20'
  enumFonts(1)=Font'Firetrucks.PermanentMarker20'
  enumFonts(2)=Font'Firetrucks.WeedrowFont'
  enumFonts(3)=Font'Firetrucks.WeedrowFont'
  enumFonts(4)=Font'Firetrucks.WeedrowFont'
  brightnesses(2)=255
  brightnesses(3)=255
}
