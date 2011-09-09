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
  
int[] numbers;
  
void setup() {
    //This code happens once, right when our sketch is launched
    size(750,750);
    background(0);
    smooth();
    
    
    
    numbers = getNumbers();
    
    colorGrid(numbers, 50, 50, 70, 1000, 1000);
    
    //barGraph(numbers, 100);
}

void draw() {
  //This code happens once every frame.
  
  // Test a moving rectangle
  //stroke(255);
  //fill(255,0);
  //rect(mouseX, 0, 70, 70);
  colorGrid(numbers, 50, 50, 70, mouseX, mouseY);
}

void barGraph(int[] nums, float y) {
  //Make a list of number counts
   int[] counts = new int[100];
   //Fill it with zeros
   for (int i = 1; i < 100; i++) {
     counts[i] = 0;
   }
   //Tally the counts
   for (int i = 0; i < nums.length; i++) {
     counts[nums[i]] ++;
   }
 
   //Draw the bar graph
   for (int i = 0; i < counts.length; i++) {
     colorMode(HSB);
     fill(counts[i] * 30, 255, 255);
     rect(i * 8, y, 8, -counts[i] * 10);
   }
}

void colorGrid(int[] nums, float x, float y, float s, int mX, int mY) {
  //Create the font object to make text with
  PFont label = createFont("Helvetica", 24);
  
  //Make a list of number counts
  int[] counts = new int[100];
  //Fill it with zeros
  for (int i = 0; i < 100; i++) {
    counts[i] = 0;
  }
  //Tally the counts
  for (int i = 0; i < nums.length; i++) {
    counts[nums[i]] ++;
  }
 
  //Move the drawing coordinates to the x,y position specified in the parameters
  pushMatrix();
  translate(x,y);
  //Draw the grid
  for (int i = 0; i < counts.length; i++) {

    // If the mouse is in this square, highlight it and show the count
    if( floor(mX/s) == (i % 10) && floor(mY/s) == floor(i/10) ) {
      stroke(255);  // White
      fill(255, 248, 198, 25);  // 
      rect( ((i % 10) * s) - s/2, (floor(i/10) * s) - s/2 - 10, s-1, s-1);
      colorMode(HSB);
      fill(255);
      textAlign(CENTER);
      textFont(label);
      textSize(s/2);
      text(counts[i], (i % 10) * s, floor(i/10) * s);
    } else {
      stroke(0);  // Black
      fill(0);  // Black
      rect( ((i % 10) * s) - s/2, (floor(i/10) * s) - s/2 - 10, s-1, s-1);
      colorMode(HSB);
      fill(counts[i] * 30, 255, 255, counts[i] * 30);
      textAlign(CENTER);
      textFont(label);
      textSize(s/2);
      text(i, (i % 10) * s, floor(i/10) * s);
    }
  }
  popMatrix();
}
