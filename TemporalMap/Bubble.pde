class Bubble
{
  float endRadius = 20;
  float endAlpha = 0;

  float cirAlpha = 255;
  float cirRad = 0;

  boolean rendered = false;

  float x;
  float y;
  color clr;
  Boolean firstTime = true;

  Bubble(float x, float y, color clr)
  {
    this.x = x;
    this.y = y;
    this.clr = clr;
  }

  void update(color clr)
  {
    clr = clr;
    
    if (!rendered)
    {
      if (round(cirRad) >= endRadius)
      {
        cirRad = endRadius;
        cirAlpha = endAlpha;

        rendered = true;
      } 

      cirRad += (endRadius - cirRad) / 10;
    }


    cirAlpha += (endAlpha - cirAlpha) / 10;

    smooth();
    strokeWeight(1);
    stroke(clr, cirAlpha);
    fill(clr, cirAlpha);
    ellipse(x, y, cirRad, cirRad);
    noStroke();

    fill(firstTime ? 255 : clr , 128);
    ellipse(x, y, 2, 2);
    
    if(firstTime) firstTime = false;
  }
}

