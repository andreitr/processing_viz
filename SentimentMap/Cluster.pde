class Cluster
{
  // Set to true when sentiment value is set
  boolean hasSentiment;

  // Cluster color 
  color clr;

  float x;
  float y;

  // Number of points containted in the cluster
  int count;

  ClusterCircle clusterCircle;
  ClusterSquare clusterSquare;

  // Sentiment vlaue for the group
  Sentiment sentiment;

  Cluster() 
  {
    this.sentiment = new Sentiment();
    this.hasSentiment = false;
    this.count = 0;

    this.clusterCircle = new ClusterCircle();
    this.clusterSquare = new ClusterSquare();
  }

  // Records sentiment for this group
  public void setSentiment(float value) {
    this.hasSentiment = true;
    this.sentiment.update(value);
  }

  // Returns sentiment value
  public float getSentiment() {
    return this.sentiment.value;
  }

  /**
   *  Adds point count to the existing cluster
   */
  public int setCount(int value)
  {
    this.count += value;
    return this.count;
  }

  /**
   * Draw circle to represent density of a given cluster.
   */
  public void drawCircle(float x, float y, float rad, PGraphics canvas)
  {
    this.clusterCircle.update(x, y, rad, this.clr, canvas);
  }

  /**
   * Draw cluster square
   */
  public void drawSquare(float x, float y, float cellSize, PGraphics canvas)
  {
    this.clr = this.sentiment.getSentimentColor((int)sentiment.value);
    this.clusterSquare.update(x, y, this.clr, cellSize, canvas);
  }
}


class ClusterSquare
{
  float endAlpha = 0;
  float endSize = 0;

  ClusterSquare() {
  }

  /**
   * Updates circle size.
   */
  public void update(float x, float y, color clr, float cellSize, PGraphics canvas)
  {
    this.endSize += (cellSize - this.endSize) / 10;   
    this.endAlpha += (255 - this.endAlpha) / 10;

    canvas.smooth();
    canvas.noStroke();
    canvas.fill(clr, this.endAlpha);
    canvas.ellipse(x, y, this.endSize, this.endSize);
    //canvas.ellipse(x+((cellSize/2)-(this.endSize/2)), y+((cellSize/2)-(this.endSize/2)), this.endSize, this.endSize);
  }
}


class ClusterCircle
{
  float endAlpha = 0;
  float endRad = 0;
  float cirRad = 0;

  ClusterCircle() {
  }

  /**
   * Updates circle size.
   */
  public void update(float x, float y, float rad, color clr, PGraphics canvas)
  {
    // Create pulsating sorta pulsating effect.
    this.endRad = rad;

    this.cirRad += (endRad - this.cirRad) / 10;
    this.endAlpha += (150 - this.endAlpha) / 10;

    if (cirRad > 10)
    {
      canvas.smooth();
      canvas.noStroke();
      canvas.noFill();
      canvas.ellipse(x, y, this.cirRad, this.cirRad);

      canvas.noFill();
      canvas.strokeWeight(5);
      canvas.stroke(255, 200);
      canvas.ellipse(x, y, this.cirRad, this.cirRad);

      canvas.strokeWeight(1);
      canvas.stroke(clr, 255);
      canvas.ellipse(x, y, this.cirRad, this.cirRad);

      canvas.noStroke();
      canvas.fill(clr, endAlpha);
      canvas.ellipse(x, y, 5, 5);
    }
  }
}

