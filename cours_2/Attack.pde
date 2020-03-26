import ddf.minim.*;

class Attack
{
    int x,y,r,db;
    int xvalue,yvalue;
    color couleur;
    boolean hasTouchedSomething = false;
    int maxRange = 150;
  
    Attack (int newX, int newY, color newCouleur, PApplet p)
    {
      x = newX;
      y = newY;
      db = maxRange;
      r = db/2;
      couleur = newCouleur;  
    }
    
    void display(int attackWidth) 
    {
      
      fill(couleur);
      noStroke();
      ellipseMode(CENTER);
      ellipse(x,y,attackWidth,attackWidth);
      stroke(0); 
    }
    
   
    
    boolean intersect(int attackWidth ,Corona b) 
    {
        int attackRayon = attackWidth /2 ;
        
        float distance = dist(x, y, b.x, b.y);
    
        if (distance < attackRayon + b.r) 
        {
          return true;
        }
        else 
        {
          return false;
        }
    }
    
    void testDestroyBombs(int attackWidth)
    {
       for (int i=0 ; i<numOfCoronas ; i++)
       {
          if(myAttack.intersect(attackWidth,coronas.get(i)))
          {
              coronas.get(i).isDead =true;
              coronas.get(i).r = 0;      
          } 
       }    
    }
  
}
