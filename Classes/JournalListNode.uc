//=============================================================================
// JournalListNode.
//=============================================================================
class JournalListNode extends JournalData;
/**
Linked list for journal data. I guess theoretically if you collected like
a thousand and one hundred or so list entries the game would crash.
*/

var JournalListEntry entry;

var JournalListNode next;
var JournalListNode prev;

var travel int index;

static function JournalListNode linearSearch(JournalListNode tail, JournalListEntry e) {
  if (tail == none || e == none) {
    //log("No entries to search!");
    return none;
  }

  while (tail != none) {
    if (tail.entry == e) return tail; //this comparison
    else tail = tail.prev;
  }

  //log(e $ " not found!");
  return none;
}

defaultproperties
{
}
