class Corona
{
  int x,y,r;
  int xSpeed,ySpeed;
  color couleur;
  int db;
  boolean isDead = false;
  
  
  Corona(int newX, int newY, int newRayon, color newCouleur)
  {
    x = newX;
    y = newY;
    r = newRayon;
    db = r*2;
    couleur = newCouleur;
    xSpeed = int(random(1,5));
    ySpeed = int(random(1,5));
    
  }
  
  void move()
  {
    x= x + xSpeed;
    y = y + ySpeed;
  } 
  
  
  void display() 
  {
    fill(couleur);
    ellipseMode(CENTER);
    ellipse(x,y,db,db);
  }
  
  void testOOB()
  {
     if (x > (width - r /2 ) || x < 0) {
      // x = - x; 
       xSpeed = - xSpeed;
     }
     
     if (y > ( height - r /2 ) || y < 0) {
       //y = - y; 
       ySpeed = - ySpeed;
     }
  }
  
  
  
  
  
  
  
  
}
