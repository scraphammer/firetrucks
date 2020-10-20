//=============================================================================
// JournalListEntry.
//=============================================================================
class JournalListEntry extends JournalData nousercreate;
/**
A class that represents entries into a journal. The variables are flagged as
editable for some reason even though the class is
 nousercreate
*/

var() byte entryType;

var() localized String entryName;
var() bool indent;
var() localized String entryText;
var() texture image;
var() byte drawStyle; //1 = normal, 2 = masked, 3 = transparant, 4 = modulated
var() int height;
var() int width;

defaultproperties
{
}
