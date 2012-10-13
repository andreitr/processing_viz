class Legend
{
  float ypos;
  float xpos;
  float width;
  float height;

  PImage legend;
  PFont font;

  float pos_w = 0;
  float neg_w = 0;
  float nut_w = 0;

  Legend(float x, float y, float width, float height)
  {
    this.xpos = x; 
    this.ypos = y;
    this.width = width;
    this.height = height;

    legend = loadImage("/assets/sentiment_legend.png");

    font = loadFont("data/Helvetica-Light-12.vlw");
  }

  /**
   * Draws the legend.
   */
  public void update(int tweets, float positive, float negative, float neutral)
  {
    float max_width = 30;
    float max_sent = max(max(positive, negative), neutral);

    noStroke(); 
    textFont(font);
    fill(255, 180);
    rect(xpos, ypos, width, height);

    this.pos_w += (((positive / max_sent) * max_width) - this.pos_w) / 5;
    this.neg_w += (((negative / max_sent) * max_width) - this.neg_w) / 5;
    this.nut_w += (((neutral / max_sent) * max_width) - this.nut_w) / 5;

    // Negative
    fill(#d63150, 200);
    rect((xpos+(10 + 55)), ypos+10, this.neg_w, 15);
    fill(0, 255);
    text("Patriots", xpos+10, ypos+22);

    // Neutral    
    fill(#c7c7c7, 200);
    rect((xpos+(10 + 55)), ypos+30, this.nut_w, 15);
    fill(0, 255);
    text("Neutral", xpos+10, ypos+42);

    // Positive
    fill(#2b88f1, 200);
    rect((xpos+(10 + 55)), ypos+50, this.pos_w, 15);
    fill(0, 255);
    text("Giants", xpos+10, ypos+62);

    text("Max cluster size", xpos+110, ypos+22);

    smooth();
    noFill();
    stroke(#000000, 123);
    fill(#3796fa, 20);
    ellipse(xpos+128, ypos+47, 35, 35);
    ellipse(xpos+160, ypos+47, 20, 20);

    noStroke();
    fill(#333333);
    text(tweets, xpos+180, ypos+51);
  }
}
