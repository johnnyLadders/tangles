//Two dimensional tangle array
Tangle[][] tangles;

//Array to temporarily hold changed tangles
ArrayList<Tangle> changedTangles = new ArrayList<Tangle>();

//multiplier
int multiplier;

//initialize tangle dimensions
int tangleWidth = 10;
int tangleHeight = 10;

//window dimensions
int windowWidth;
int windowHeight;
float maxDistance;

//Movement Data
int centerX;
int centerY;
int movementRadius = 15;
boolean angleIncrement = true;
int angle = 0;
int angleStep = 15; //90 % angleStep must == 0 
float radians = 0;

//Circle Position
int circleX = 0;
int circleY = 0;

//loop counter
int loopCounter = 0;

//mouse positions
int mouseXPosition = 0;
int mouseYPosition = 0;

//Color Array
color[] gradientSteps = {
  color(255,126,0),//SAE/ECE Amber
  color(246,112,4),
  color(237,98,9),
  color(228,84,14),
  color(219,70,18),
  color(210,56,23),
  color(201, 42, 28),
  color(192,28,32),
  color(183,14,37),
  color(175,0,42)//Alabama Crimson
  };

//initialize tangle base color
color baseColor = gradientSteps[9];

//location of last changed
int lastChangedX = 0;
int lastChangedY = 0;

void setup() {
  
  //set background to black
  background(40);
  
  //set framerate
  frameRate(18);
  
  //initialize window dimensions
  windowWidth = displayWidth;
  windowHeight = displayHeight;
  maxDistance = dist(0,0,(windowHeight/ tangleHeight),(windowWidth / tangleWidth)) + 5.0;
  
  //set window size
  size(windowWidth,windowHeight);
  
  //initialize movement center positions
  centerX = (windowWidth / tangleWidth) / 2;
  centerY = (windowHeight/ tangleHeight) / 2;
  
  //initialize tangle array
  tangles = new Tangle[width/tangleWidth][height/tangleHeight];

  for(int x = 0; x < tangles.length; x++){
    for(int y = 0; y < tangles[x].length; y++){
      tangles[x][y] = new Tangle(x * tangleWidth, y * tangleHeight);
//      tangles[x][y].setColor();
    }
  }
  
}

void draw(){ 
  background(40);
  loopCounter = (loopCounter + 1) % 2;
  //update position
  update();

  if(mouseXPosition == mouseX && mouseYPosition == mouseY){
    noCursor();
  }else{
    cursor();
    mouseXPosition = mouseX;
    mouseYPosition = mouseY;
  }
    
  //current mouse coordinates
  int mouseXCoord = circleX;
  int mouseYCoord = circleY;
  
  //if mouse has moved
    //fixed changed tangles
    for(Tangle t: changedTangles){
      t.changeColor(baseColor,255.0);
    }
  
  
  changedTangles = new ArrayList<Tangle>();
  
  //display each tangle
  for(int x = 0; x < tangles.length; x++){
    for(int y = 0; y < tangles[x].length; y++){
      //calculate distance to mouse
      float distance = dist(mouseXCoord,mouseYCoord,x,y);
      if(distance < 9){
        //set color accordingly
        color appropriateColor = getAppropriateColor(tangles[x][y].getColor(), distance);
//        if(appropriateColor != tangles[x][y].getColor()){
          tangles[x][y].changeColor(appropriateColor, 255.0);
          changedTangles.add(tangles[x][y]);
//        }
        
      }else{
        float distanceOpacity = 255.0 - ((distance / maxDistance) * 255.0); 
        
        if(random(1.0) < (-0.099 * distance) + 1.99){
          tangles[x][y].setColor(distanceOpacity);
        }/*else if(random(1.0) < 0.0005){
          tangles[x][y].setColor(distanceOpacity);
        }*/else{
          tangles[x][y].changeColor(baseColor, distanceOpacity);          
        }
        
      }
      //display
      tangles[x][y].display();
    }
  }
  
//  //correct Last changed
//  tangles[lastChangedX][lastChangedY].setColor();
//  tangles[lastChangedX][lastChangedY].display();
//  
//  //update last changed values
//  lastChangedX = mouseXCoord;
//  lastChangedY = mouseYCoord;
//  
//  //change new
//  tangles[lastChangedX][lastChangedY].changeColor(gradientSteps[0]);
//  tangles[lastChangedX][lastChangedY].display();
  
}

class Tangle {
  color c;
  color stroke;
  float xpos;
  float ypos;
  float opac;
  
  Tangle(int xPosition, int yPosition) {
    c = baseColor;
    stroke = baseColor;
    xpos = xPosition;
    ypos = yPosition;
    opac = 255.0;
//    setColor();
  }
  
  void display(){
    //rectMode(CENTER);
    fill(c, opac);
    noStroke();
    rect(xpos,ypos,tangleWidth,tangleHeight);
    
  }
  
  void changeColor(color newColor, float opacity){
    opac = opacity;
    c = newColor;
    stroke = newColor;
  }
  
  void setColor(float opacity){
    //different color?
    stroke = baseColor;
    if(random(1.0) < .15){
      color newColor =  gradientSteps[int(random(gradientSteps.length))];
      c = newColor;
      opac = opacity;
    }else{
      c = baseColor;
    }
  }
  
  color getColor(){
    return c;
  }
}
color getAppropriateColor(color currentColor, float distance){
    color retVal = currentColor;
    
    if(distance < 1){
      retVal = gradientSteps[0];
    }else if(distance < 2){
      retVal = gradientSteps[1];
    }else if(distance < 3){
      retVal = gradientSteps[2];
    }else if(distance < 4){
      retVal = gradientSteps[3];
    }else if(distance < 5){
      retVal = gradientSteps[4];
    }else if(distance < 6){
      retVal = gradientSteps[5];
    }else if(distance < 7){
      retVal = gradientSteps[6];
    }else if(distance < 8){
      retVal = gradientSteps[7];
    }else if(distance < 9){
      retVal = gradientSteps[8];
    }
    
    return retVal;
  }

void update(){
  
  //change positions ... maybe
  if(angle % 90 == 0 && ((random(2.0) - 1) < 0)){
    if(!(
    centerX + 2 * movementRadius * cos(radians) > (windowWidth / tangleWidth) ||
    centerX + 2 * movementRadius * cos(radians) < 0 ||
    centerY + 2 * movementRadius * sin(radians) > (windowHeight/ tangleHeight) ||
    centerY + 2 * movementRadius * sin(radians) < 0
    )){
      loopCounter = 0;
      centerX = int(centerX + 2 * movementRadius * cos(radians));
      centerY = int(centerY + 2 * movementRadius * sin(radians));
      angle = angle + 180;
      angleIncrement = !angleIncrement;

      
    }
  }
  
  //increment angle
  if(angleIncrement){
    angle = (angle + angleStep) % 360;
  }else{
    angle = (angle - angleStep) % 360;
  }
  
  //calculate radians
  radians = (angle * PI) / 180;
  
  
  
  //update circle position
  circleX = int(centerX + (movementRadius * cos(radians)));
  circleY = int(centerY + (movementRadius * sin(radians)));
  
  
}

//run in full screen mode
boolean sketchFullScreen() {
  return true;
}
