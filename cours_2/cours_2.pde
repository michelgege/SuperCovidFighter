import processing.serial.*;
//import ddf.minim.*;

Serial myPort;
PImage fond,ball;
float xvalue = 0;
float yvalue = 0;
int AngleVision= 90;
int buttonValue;
int background = 0;
int dB = 20; 
boolean hasTouched =false;
Corona[] coronas;
int last = 0;
int m = 0;
int numOfBombs = 0;
int time;


boolean intersecting;
boolean hasLoosed = false;
boolean canAttack = true;
boolean isAttacking = false;
boolean attackInProgress = false;
int attackDuration = 750; //ms
int attackCooldown = 10000; //ms
int lastAttack = 0;
int timeOfAttack = 0;



PFont f;
int timeOfGame = 0;

//Minim minim;
//AudioPlayer musiqueFond;

Globule myGlobule = new Globule ( 250, 250, 10, color(255));
Attack myAttack = new Attack(250, 250, color(0));


void setup() 
{
     
    //minim = new Minim(this);
    //musiqueFond = minimum.loadFile(".....mp3");
    f = createFont("Arial",26,true);
    textFont(f);
    smooth();
    size(800, 800);
    myPort = new Serial(this, "COM5", 9600);
    myPort.bufferUntil('\n');
    background(background);
    fond = loadImage("data/trump.jpg");
    fond.resize(800,800);
    
    initBombs();
    
}

void draw() 
{
    
    if (hasLoosed == false) 
    {
        play();
    }
    
    else
    {
       looseScreen();
    }
}



//__________________________________________________________________________________________________________________________________________________________________________________________________________//

void serialEvent(Serial myPort) 
{
    String serialStr = myPort.readStringUntil('\n');
    serialStr = trim(serialStr);
    int values[] = int(split(serialStr, ','));
    if( values.length == 3 ) 
    {
      if(values[2]==1 && canAttack == true)
      {
        isAttacking  = true;
        
      }
      else
      {
        isAttacking = false;
      }
      
      int newX = int(map(values[0],-509,514,-5,5));
      int newY = int(map(values[1],-507,516,-5,5));
      myAttack.x = myGlobule.x;
      myAttack.y = myGlobule.y;
      myGlobule.x += newX;
      myGlobule.y += newY;
     
    }
}

//_______________________________________________________________________________________________EVENTS____________________________________________________________________________________________________________//

void mousePressed() {
  if (hasLoosed == true) 
  {
    hasLoosed = false;
    numOfBombs = 1;
  } 
}

//_______________________________________________________________________________________________FUNCTIONS____________________________________________________________________________________________________________//

void initBombs(){
  
    coronas = new Corona[30];
  
    for (int i=0 ; i<30 ; i++)
    {  
       int x = int(random(0,800)); 
       int y = int(random(0,800)); 
       int size = int(random(5,25));
       
       if(x <= 400) {
         x = 1 + size;
       } else {
         x = 799 - size;
       }
       
       if(y <= 400) {
         y = 1 + size;
       } else {
         y = 799 - size;
       }
       
        coronas[i] = new Corona( x, y, size, color(255, 0, 0));
    } 
}

/////////////////////////////////////////////


void moveBombs()
{
    
    for (int i =0 ; i<numOfBombs ; i++)
    {
        if(coronas[i].isDead == false) {
        
          coronas[i].move();
          coronas[i].testOOB();
          coronas[i].display();
        } else {
          coronas[i].x = 1600;
          coronas[i].y = 1600;
        }
    } 
}


/////////////////////////////////////////////

void play() {
  
  time = millis()/1000 - timeOfGame;
    
  background(background);
  image(fond,0,0);
  
  rect(600, 50, 150, 20, 3);
  
  testAttack();
  myGlobule.testOOB();
  myGlobule.display();

  moveBombs();
       
  if (testCollisionBombs())
  {
    hasLoosed = true;
  }
  
  //m = millis()-last;
  if(millis() > last+5000)
  {
      last = millis();
      if (numOfBombs < 30) 
      {
        numOfBombs++;
      }
  }
  
  
  text(time + "s" ,50,50);
 
}

/////////////////////////////////////////////

void looseScreen() {
  
  timeOfGame = millis()/1000;
  fill(50);
  rect(0,0,800,800);
  fill(255);
  textAlign(CENTER,CENTER);
  
  if(time<60) { 
   text("Tu as tenu "+time +" secondes, quel Mickey...",400,400);
  } else if (time < 120) {
     text("Tu as tenu "+time +" secondes, pas mal pour une baltringue...",400,400);
  } else {
     text("Tu as tenu "+time +" secondes, c'est un peu ridicule quand même...",400,400);
  }
  
}

/////////////////////////////////////////////

boolean testCollisionBombs()
{
   intersecting = false;
   for (int i=0 ; i<numOfBombs ; i++)
   {
      if(myGlobule.intersect(coronas[i]))
      {
          intersecting = true;
          break;
      } else {
          intersecting = false;
      }
   }   

  if(intersecting == true)
  {
      return true;
  } else {
      return false;
  }
    
}

/////////////////////////////////////////////

void testAttack()
{
  
  if(millis() > lastAttack + attackCooldown) {
    
    lastAttack = millis();
    canAttack = true; 
    
    
  } 
  
  
  if(canAttack == true && isAttacking == true) {
    
     canAttack = false;
     lastAttack = millis();
     attackInProgress = true;
  }
  
  if(millis() > lastAttack + attackDuration) {
        
     attackInProgress = false;
  }
  
  if(millis() < lastAttack + attackDuration && attackInProgress == true) {
        
     int timeWhileAttacking = millis() - lastAttack ;
     int attackWidth = int(map(timeWhileAttacking,0,attackDuration,myGlobule.db,(myAttack.maxRange*2)));
     if (attackWidth > myAttack.maxRange) {
       attackWidth = myAttack.maxRange ; 
     }
     
     myAttack.display(attackWidth);
     myAttack.testDestroyBombs(attackWidth);
  }
  
  if(canAttack == true) {
    
    text( "ok" ,750,50);
  } else { 
    
    text("nope", 750, 50);
  }
  
  if(canAttack == false)
  {
    int cD = millis() - lastAttack;
    int cDBarWidth = int(map(cD,0,attackCooldown,0,150));
    fill(0);
    rect(600, 50, cDBarWidth, 20, 3);
  } else {
    fill(0);
    rect(600, 50, 150, 20, 3);
 
  }
    
  
}
