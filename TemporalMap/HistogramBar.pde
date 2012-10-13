class HistogramBar
{
  boolean rendered = false;

  float barHeight;
  float barWidth;
  int barColor; 
  float tmpHeight;

  float xpos;
  float ypos;

  HistogramBar(float x, float y, float width, float height, int clr)
  {
    ypos = y;
    xpos = x;
    barHeight = height;
    barWidth = width;
    barColor = clr;
  }

  void update()
  {
    noStroke();
    fill(barColor);
    if (!rendered)
    {
      tmpHeight += (barHeight - tmpHeight) / 10;
      rect(xpos, ypos, barWidth, -tmpHeight);
    }
  }

  void updateHeight(float newHeight)
  {
    if (newHeight != barHeight)
    {
      rendered = false;
      barHeight = newHeight;
    }
  }
}

