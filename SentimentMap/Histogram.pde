class Histogram
{
  HistogramBarStacked[] bars;
  int barsCursor;

  float ypos;
  float xpos;
  float width;
  float height;

  ArrayList data;

  float playbarWidth;
  float maxValue;

  // Start and end positions of hightlight
  float highlight_start = -1.0;
  float highlight_width = 0;

  Histogram(float x, float y, float width, float height, ArrayList data)
  {
    this.xpos = x; 
    this.ypos = y;
    this.width = width;
    this.height = height;

    this.data = data;
    bars = new HistogramBarStacked[data.size()];
  } 

  void update(float playhead)
  {
    // Background 
    noStroke();
    fill(#FFFFFF, 180);
    rect(xpos, ypos, width, height);


    // Playhead 
    //    fill(#027B9E, 50);
    //    float percentWidth = playhead * width / 100;
    //    playbarWidth += (percentWidth - playbarWidth) /5;
    //    rect(xpos, ypos, playbarWidth, height);

    //Display histogram bars
    generateBars(int(playhead * float(bars.length) / 100));

    for (int i=0; i<barsCursor; i++) {
      bars[i].update();
    }
  }

  void generateBars(int count)
  {
    barsCursor = count;

    Date minDate = new Date("Sun Feb 02 16:30:00 EST 2012");
    Date maxDate = new Date("Sun Feb 02 22:20:00 EST 2012");

    float barOpacity = 255;

    for (int i=0; i<count; i++)
    {
      TemporalSlot slot = (TemporalSlot) data.get(i);

      maxValue = max(slot.count, maxValue);

      float heightPercent = slot.count / maxValue;
      float barHeight = heightPercent * height;

      int highlight_index = 0;

      // Color histogram bar based on the specific time frame
      if (slot.date.getTime() > minDate.getTime() && slot.date.getTime() < maxDate.getTime()) {

        if (highlight_start == -1.0) {
          highlight_start = xpos + (i * (width / bars.length));
          highlight_index = i;
        }

        highlight_width =  ((i-highlight_index)  * (width / bars.length)) - highlight_start;
      }

      if (bars[i] == null)
      {
        bars[i] = new HistogramBarStacked(xpos + (i * (width / bars.length)), ypos+height, width / bars.length, barHeight, 255, slot.sentiment);
      }
      else {
        bars[i].updateHeight(barHeight);
      }
    }

    // Display highlight
    if (highlight_start > -1.0 && highlight_width > 0) {
      displayHighlight(highlight_start, highlight_width);
    }
  }

  /**
   * Highlights specified region of the histogram.
   * @param start_x float
   * @param end_x float
   */
  private void displayHighlight(float start, float end)
  {
    fill(#333333, 255);
    rect(start, ypos, end, 3);

    fill(#FFFF00, 50);
    rect(start, ypos, end, height);
  }
}

