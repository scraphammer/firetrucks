//=============================================================================
// DialogueNode.
//=============================================================================
class DialogueNode extends Triggers;

//custom icon hand pixeled by yours truly
#exec texture import file=Textures\DialogueNode.pcx name=i_dnode group=Icons mips=Off flags=2
//actually I cheated and used the round rectangle tool in ps cs4
//because rounded-rects are everywhere
//just look around this room

//custom font because the default one is trash and unreadable
#exec Font Import File=Textures\WeedrowFont.pcx Name=WeedrowFont

//also FYI my code style doesn't exactly match Epic's
//but their code style sucks

/**
The actor that started this pack. When triggered, the player enters a super dialogue mode.
*/

struct responseChoiceStruct {
    var() string optionText;
    var() sound responseAudio;
    var() float responseDelay;
    var() name responseEvent;
};

var() FiretrucksCamera cameraToUse; //If set, switches the player's view to the specified camera for the duration of the dialgoue.
var() Actor speaker; //The actor who is speaking. Leave it as none if the player is speaking.
var() enum DialogueType { //inline enums are a little messy I think
   RT_AUTO, //continue without response
   RT_CLICK, //wait for player click to continue
   RT_CHOICE, //player selects a choice to continue
   RT_RITA_PLEASE_RESPOND //like RT_AUTO, but does not fire an event afterwards
} responseType; //How the player will respond. RT_AUTO continues without a response. RT_CLICK waits until the player clicks to continue. RT_CHOICE allows for the player to choose a response from a list of up to five. RT_RITA_PLEASE_RESPOND is like RT_AUTO, but does not fire an event at the end, because there's no replies ;_;.
var() localized string speakerName; //The name of the speaker. ie: "Weedrow" or "Gretal the Ripped"
var() name speakerAnimation; //The name of the animation for the speaker to perform. Kind of buggy to pawns behaving badly but no good fix exists outside of reimplementing every pawn. I'm not doing that.
var() localized string prompt; //What is being said. example: "Takk-sempai no ecchi!"
var() localized Sound promptAudio; //Audio to go with the text.
var() localized float EventDelay; //For RT_AUTO and RT_RITA_PLEASE_RESPOND it is the time until the dialogue finishes. For RT_CLICK, is the the time until the "Click to continue!" prompt appears. For RT_CHOICE, it is the time until the choices appear.
var() name autoAndClickEvent; //The event triggered by this dialogue under RT_AUTO and RT_CLICK
var() localized responseChoiceStruct responses[5]; //The responses to the given dialogue. Each choice can have its own <span>optionText</span>, <span>responseEvent</span>, <span>responseAudio</span>, and <span>responseDelay</span>.
var() bool disableAfterUse; //If you can figure out what this one does you get twenty points.
var() bool enabled; //Whether or not this dialogue node is enabled
var() bool turnToFace; //Whether or not the speaker should turn to face the player.

var(EasyMode) localized editconst const string warningMessageA;
var(EasyMode) localized editconst const string warningMessageB;
var(EasyMode) localized editconst const string warningMessageC;
var(EasyMode) localized editconst const string warningMessageD;
var(EasyMode) name speakerTag;

var bool clickReady;
var int choice;
var rotator oldPawnRot;
var float pawnAccel;
var rotator pawnRotationRate;
var bool speakerDidAnimate;
var Pawn ei;
var Actor triggerOther;

function Trigger(actor Other, pawn EventInstigator) {
    local Actor a;
    local PlayerPawn pp;
    local FiretrucksPlayer p;
    if (!enabled) return;
    if (prompt == "") {
      warn("prompt == \"\"!");
      return;
    }

    //added in v1.1 to ignore dead pawn speakers because idk
    if (Pawn(speaker) != none && Pawn(speaker).health <= 0) return;

    clickReady = false;
    switchPlayerView();
    choice = -1;
    speakerDidAnimate = false;
    
    ei = eventInstigator;
    triggerOther = other;
    
    //log it (hopefully)
    if (speakerName != "") broadcastMessage (speakerName$":"@prompt, false);
    else broadcastMessage (prompt, false);
    
    //play sound
    if (promptAudio != none) {
        if (speaker == none) foreach allactors(class'PlayerPawn', pp) pp.PlaySound(promptAudio, SLOT_None);
        else speaker.playSound(promptAudio);
        if (speakerTag != '') foreach allActors(class'Actor', a, speakerTag) a.playSound(promptAudio);
    }
    
    //turn to face
    if (speaker != none && turnToFace) {
      foreach allactors(class'PlayerPawn', pp) {
        oldPawnRot = speaker.rotation;
        speaker.setRotation(rotator(pp.location - speaker.location));
        speaker.setPhysics(PHYS_NONE);
        if (Pawn(speaker) != none) {
          pawnAccel = Pawn(speaker).accelRate;
          pawnRotationRate = Pawn(speaker).rotationRate;
          Pawn(speaker).accelRate = 0;
          Pawn(speaker).rotationRate = Pawn(speaker).rotationRate * 0;
        }
        break;
      }
    }
    
    //play animation
    if (speakerAnimation != '') {
        if (speaker == none) foreach allactors(class'PlayerPawn', pp) pp.playAnim(speakerAnimation);
        else {
          speakerDidAnimate = true;
          speaker.playAnim(speakerAnimation);
        }
        if(speakerTag != '') foreach allActors(class'Actor', a, speakerTag) a.playAnim(speakerAnimation);
    }
    
    //send reference to player
    foreach allactors(class'FiretrucksPlayer', p) {
        p.dialogue(self);
    }
    
    if (eventDelay > 0) setTimer(EventDelay, false);
    else timer();
    
    if (disableAfterUse) enabled = false;
}

function timer() {
    local FiretrucksPlayer p;
    if (responseType == RT_CHOICE) {
        //choice event
        if (choice > -1) {
            restorePlayerView();
            triggerEvent(responses[choice].responseEvent, triggerOther, ei);
        } else {
            foreach allactors(class'FiretrucksPlayer', p) {
                p.choices(self);
            }
        }
    } else if (responseType == RT_CLICK) {
        clickReady = true;
        foreach allactors(class'FiretrucksPlayer', p) {
            p.waitingForClick();
        }
    } else {
        //fire event;
        restorePlayerView();
        if (responseType != RT_RITA_PLEASE_RESPOND) triggerEvent(autoAndClickEvent, triggerOther, ei);
    }
}

simulated function switchPlayerView() {
    local PlayerPawn p;
    foreach allactors(class'playerpawn', p) {
       if (FiretrucksPlayer(p) != none) {
           FiretrucksPlayer(p).switchPlayerView(cameraToUse, self);
       }
   }
}

simulated function restorePlayerView() {
    local PlayerPawn p;
    foreach allactors(class'playerpawn', p) {
       if (FiretrucksPlayer(p) != none) {
           FiretrucksPlayer(p).restorePlayerView(self);
           FiretrucksPlayer(p).currentDN = none;
           FiretrucksPlayer(p).didChoose = false;
       }
       
       if (turnToFace && speaker != none) {
         if (Pawn(speaker) != none) Pawn(speaker).accelRate = pawnAccel;
         if (Pawn(speaker) != none) Pawn(speaker).rotationRate = pawnRotationRate;
         speaker.setRotation(oldPawnRot);
       }
       
       if (speakerDidAnimate) {
         speaker.playAnim('breath'); //hack to cover up animation issues, most of the time anyway
       }
   }
}

simulated function choose(byte b) {
    local PlayerPawn pp;

    broadcastMessage (">"$responses[b].optionText, false);
    choice = b;
    
    //play sound
    if (responses[b].responseAudio != none) {
        foreach allactors(class'PlayerPawn', pp) pp.PlaySound(responses[b].responseAudio);
        //should a response call be sent? or can the player handle it?
        //call should be sent
        
        if (FiretrucksPlayer(pp) != none) {
           FiretrucksPlayer(pp).madeChoice(self, b);
       }
    }
    if (responses[b].responseDelay > 0) setTimer(responses[b].responseDelay, false);
    else timer();
}

simulated function click() {
    if (!clickReady) return;
    restorePlayerView();
    triggerEvent(autoAndClickEvent, triggerOther, ei);
}

//this bit was added to help developers
event DrawEditorSelection(Canvas c){ //I noticed 227 had a cool new feature
    local Actor a; //and that the code for dispatchers used them
    local bool choice; //where you could specify unrealscript to be
    local Font f; //executed when selected in the editor
    local int offset;

    choice = false; //it's a shame they don't have a function called when rendering
    offset = 0; //them without being selected, but it is still a nice feature
    f = c.font;
    
    c.font = font'WeedrowFont';
    c.setPos(2, c.clipy - 16);
    c.drawText(name, false);
    
    changeColor(c, 127, 127, 127);
    c.setPos(2, c.clipy - 32);
    c.drawText("SPEAKER:", false);
    
    c.setPos(96, c.clipy - 32);
    if (speaker == none) changeColor(c, 255, 0, 0);
    else changeColor(c, 255, 255, 0);
    c.drawText(speaker, false);
    
    changeColor(c, 127, 127, 127);
    c.setPos(2, c.clipy - 48);
    c.drawText("RESPONSE:", false);
    
    c.setPos(96, c.clipy - 48);
    changeColor(c, 255, 255, 0);
    switch(responseType) {
        case RT_AUTO:
             c.drawText("auto", false);
             break;
        case RT_CLICK:
             c.drawText("click", false);
             break;
        case RT_CHOICE:
             choice = true;
             c.drawText("choice", false);
             break;
        case RT_RITA_PLEASE_RESPOND:
             c.drawText("there's no replies ;_;", false);
             break;
    }
    
    if (choice) {
        if (responses[0].optionText != "") {
          changeColor(c, 127, 127, 127);
          c.setPos(2, c.clipy - 64 - offset);
          c.drawText("CHOICE 1:", false);
          
          if (responses[0].responseEvent != '') {
            changeColor(c, 255, 127, 127);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText(responses[0].responseEvent, false);
            foreach AllActors(Class'Actor', a, responses[0].responseEvent) c.Draw3DLine(MakeColor(255,34,0),Location,A.Location);
          } else {
            changeColor(c, 255, 0, 0);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText("None", false);
          }
          
          offset += 16;
        }
        
        if (responses[1].optionText != "") {
          changeColor(c, 127, 127, 127);
          c.setPos(2, c.clipy - 64 - offset);
          c.drawText("CHOICE 2:", false);
          
          if (responses[1].responseEvent != '') {
            changeColor(c, 255, 200, 0);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText(responses[1].responseEvent, false);
            foreach AllActors(Class'Actor', a, responses[1].responseEvent) c.Draw3DLine(MakeColor(255,200,0),Location,A.Location);
          } else {
            changeColor(c, 255, 0, 0);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText("None", false);
          }
          
          offset += 16;
        }
        
        if (responses[2].optionText != "") {
          changeColor(c, 127, 127, 127);
          c.setPos(2, c.clipy - 64 - offset);
          c.drawText("CHOICE 3:", false);
          
          if (responses[2].responseEvent != '') {
            changeColor(c, 34, 0, 255);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText(responses[2].responseEvent, false);
            foreach AllActors(Class'Actor', a, responses[2].responseEvent) c.Draw3DLine(MakeColor(34,0,255),Location,A.Location);
          } else {
            changeColor(c, 255, 0, 0);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText("None", false);
          }
          
          offset += 16;
        }
        
        if (responses[3].optionText != "") {
          changeColor(c, 127, 127, 127);
          c.setPos(2, c.clipy - 64 - offset);
          c.drawText("CHOICE 4:", false);
          
          if (responses[3].responseEvent != '') {
            changeColor(c, 34, 127, 255);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText(responses[3].responseEvent, false);
            foreach AllActors(Class'Actor', a, responses[3].responseEvent) c.Draw3DLine(MakeColor(34,127,255),Location,A.Location);
          } else {
            changeColor(c, 255, 0, 0);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText("None", false);
          }
          
          offset += 16;
        }
        
        if (responses[4].optionText != "") {
          changeColor(c, 127, 127, 127);
          c.setPos(2, c.clipy - 64 - offset);
          c.drawText("CHOICE 5:", false);
          
          if (responses[4].responseEvent != '') {
          
            changeColor(c, 34, 64, 255);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText(responses[4].responseEvent, false);
            foreach AllActors(Class'Actor', a, responses[4].responseEvent) c.Draw3DLine(MakeColor(34,647,255),Location,A.Location);
          } else {
            changeColor(c, 255, 0, 0);
            c.setPos(96, c.clipy - 64 - offset);
            c.drawText("None", false);
          }
          
          offset += 16;
        }
        
    } else {
        changeColor(c, 127, 127, 127);
        c.setPos(2, c.clipy - 64);
        c.drawText("EVENT:", false);
        
        if (autoAndClickEvent != '') {
            changeColor(c, 255, 127, 255);
            c.setPos(96, c.clipy - 64);
            c.drawText(autoAndClickEvent, false);
            foreach AllActors(Class'Actor', a, autoAndClickEvent) c.Draw3DLine(MakeColor(255,127,255),Location,A.Location);
        } else {
            changeColor(c, 255, 0, 0);
            c.setPos(96, c.clipy - 64);
            c.drawText("None", false);
        }
    }
		
    c.font = f;
    c.reset();
}

//with 227's makeColor() function I don't really need this but oh well
simulated static function changeColor(canvas c, int r, int g, int b) {
  c.DrawColor.r = r;
  c.DrawColor.g = g;
  c.DrawColor.b = b;
}

defaultproperties
{
				speakerName="Unknown"
				EventDelay=4.000000
				Enabled=True
				warningMessageA="This is very slow"
				warningMessageB="and breaks some features."
				warningMessageC="The normal speaker field"
				warningMessageD="is very much preffered."
				choice=-5
				bEditorSelectRender=True
				Texture=Texture'Firetrucks.Icons.i_dnode'
}
