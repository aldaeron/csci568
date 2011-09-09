/*
 #myrandomnumber Tutorial
 blprnt@blprnt.com
 April, 2010
 */

//This is the Google spreadsheet manager and the id of the spreadsheet that we want to populate, along with our Google username & password
SimpleSpreadsheetManager sm;
String sUrl = "t6mq_WLV5c5uj6mUNSryBIA";
String googleUser = GUSER;
String googlePass = GPASS;
  
void setup() {
    //This code happens once, right when our sketch is launched
    size(500,500);
    background(0);
    smooth();
    
    int[] numbers = getNumbers();
    
    fill(255,40);
    noStroke();
    for (int i = 0; i < numbers.length; i++) {
      ellipse(numbers[i] * 8, width/2, 8,8);
    }
}

void draw() {
  //This code happens once every frame.
}

