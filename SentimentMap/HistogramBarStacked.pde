class HistogramBarStacked
{
  boolean rendered = false;

  float barHeight;
  float barOpacity;
  float barWidth;
  float tmpHeight;

  Sentiment sentiment;

  float xpos;
  float ypos;

  HistogramBarStacked(float x, float y, float width, float height, float opacity, Sentiment sentiment)
  {
    ypos = y;
    xpos = x;
    barHeight = height;
    barWidth = width;
    barOpacity = opacity;
    
    this.sentiment = sentiment;
  }

  void update()
  {
    float pos = this.sentiment.positive / this.sentiment.total();
    float neg = this.sentiment.negative / this.sentiment.total();
    float nut = this.sentiment.neutral / this.sentiment.total();
    noStroke();

    if (!rendered)
    {
      tmpHeight += (barHeight - tmpHeight) / 10;
      
      float pos_h = tmpHeight * pos;
      float neg_h = tmpHeight * neg;
      float nut_h = tmpHeight * nut;
      
      fill(this.sentiment.getSentimentColor(1), barOpacity);
      rect(xpos, ypos, barWidth, - pos_h);
      
      fill(this.sentiment.getSentimentColor(0), barOpacity);
      rect(xpos, ypos - pos_h, barWidth, - nut_h);
      
      fill(this.sentiment.getSentimentColor(-1), barOpacity);
      rect(xpos, ypos - (nut_h+pos_h), barWidth, - neg_h);
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

