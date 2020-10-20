class TranslatorJournalUI extends JournalUISystem;

#exec texture import file=Textures\transjourshad.pcx name=TransJournalShad mips=off

simulated function draw(Canvas c, Journal j) { 
  local float tempx, tempy, f;
  local JournalListEntry n;
  local int i;
  
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
    c.DrawRect(Texture'TransJournalShad', 532, 532);  
    c.style = 1;
    c.SetPos(c.ClipX/2-256, c.ClipY/2-256);
    c.DrawRect(Texture'TranslatorHUDHD', 512, 512);
  } else {
    c.style = n.drawStyle;
    c.SetPos(c.ClipX/2-(n.width/2), c.ClipY/2-(n.height/2));
    c.drawRect(n.image, n.height, n.width);  
  }
  
  //draw everything else
  if (n.entryType > 0) {
    c.Font = Font'SmallFont';
    c.style = 1;
    //title
    c.drawColor = makeColor(255, 0, 0);
    c.SetPos(c.ClipX/2-228, c.ClipY/2-220);
    c.drawText(n.entryName);

    //page number scroll slider
    //unrealshare slide1 slide2 slide3 slide4 (left, dotted, right, center)
    c.style = 2;
    c.drawColor = makeColor(255, 255, 255);

    c.SetPos(c.ClipX/2 - 228, c.ClipY / 2 - 32);
    c.drawRect(Texture'slide1', 8, 8);  
    c.SetPos(c.ClipX/2 + 220, c.ClipY / 2 - 32);
    c.drawRect(Texture'slide3', 8, 8);

    for (i = 0; i < 55 ; i++) {
      c.setPos(c.clipX/2 - 220 + i * 8, c.clipY / 2 - 32);
      c.drawRect(Texture'slide4', 8, 8);
    }

    f = float(currentDisplayNode.index + 1) / float(j.length);
    c.setPos(c.clipX/2 - 228 + f * 440, c.clipY / 2 - 32);
    c.drawRect(Texture'slide2', 8, 8);
    
    //pictures
    if (n.image != none) {
      c.drawColor = makeColor(255, 255, 255);
      c.style = n.drawStyle;
      c.SetPos(c.ClipX/2-(n.width/2), c.ClipY/2-(n.height/2));
      c.drawRect(n.image, n.height, n.width);
    }

    //context
    c.style = 1;
    c.Font = Font'MedFont';
    c.drawColor = makeColor(255, 255, 255);
    c.SetOrigin(c.ClipX/2-228, c.ClipY/2-208);
    c.SetClip(456,464);
    c.SetPos(0,0);;
    drawFormatted(c, n.entryText, n.indent);

  }
  
  c.clipx = tempx;
  c.clipy = tempy;
  c.reset();

  super.draw(c, j);
}


