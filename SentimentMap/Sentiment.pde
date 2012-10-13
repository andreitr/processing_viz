class Sentiment
{
  float positive;
  float negative;
  float neutral;

  float value;

  PImage heatmap;

  // Contains aggregate sentiment data for a given slot 
  Sentiment()
  {
    this.positive = 0;
    this.negative = 0;
    this.neutral = 0;

    this.value = 0;
  }

  // Updates sentiment value
  void update(float tmp_val) {

    this.value += tmp_val;

    if (tmp_val > 0)
    {
      this.positive += 1;
    }
    else if (tmp_val == 0)
    {
      this.neutral += 1;
    }
    else if (tmp_val < 0) {
      this.negative +=1;
    }

    // Check value and increment appropriate bucket
    /*
    switch((int)tmp_val) {
     case 4:
     this.positive +=4;
     break;
     case 3:
     this.positive +=3;
     break;
     case 2:
     this.positive +=2;
     break;
     case 1:
     this.positive +=1;
     break;
     
     case 0:
     this.neutral += 1;
     break;
     
     case -4: 
     this.negative +=4;
     break;
     case -3: 
     this.negative +=3;
     break;
     case -2:
     this.negative +=2;
     break;
     case -1: 
     this.negative +=1;
     break;
     }
     */
  }

  // Returns total count of sentiment records
  public float total() {
    return this.positive+this.negative+this.neutral;
  }

  /**
   * Returns color for the given sentiment.
   */
  public color getSentimentColor(int value)
  {
    int color_cursor;

    if (value > 0) {
      // Positive
      color_cursor = heatmap.width - 1;
    }
    else if (value < 0) {
      // Negative
      color_cursor = 1;
    }
    else {
      // Neutral
      color_cursor = heatmap.width/2;
    }
    return heatmap.get(color_cursor, 1);
  }
}

