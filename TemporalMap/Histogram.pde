class Histogram
{
  HistogramBar[] bars;
  int barsCursor;

  float ypos;
  float xpos;
  float width;
  float height;

  ArrayList data;

  float playbarWidth;

  float maxValue;

  Histogram(float x, float y, float width, float height, ArrayList data)
  {
    this.xpos = x; 
    this.ypos = y;
    this.width = width;
    this.height = height;

    this.data = data;
    bars = new HistogramBar[data.size()];
  } 

  void update(float playhead)
  {
    // Background 
    fill(0, 128);
    rect(xpos, ypos, width, height);

    // Playhead 
    //    fill(#027B9E, 50);
    //    float percentWidth = playhead * width / 100;
    //    playbarWidth += (percentWidth - playbarWidth) /5;
    //    rect(xpos, ypos, playbarWidth, height);

    //Display histogram bars
    generateBars(int(playhead * float(bars.length) / 100));

    for (int i=0; i<barsCursor; i++)
      bars[i].update();
  }

  void generateBars(int count)
  {
    barsCursor = count;

    Date minDate = new Date("Tue Jan 24 19:00:00 MST 2012");
    Date maxDate = new Date("Tue Jan 24 20:02:00 MST 2012");

    int barColor;

    for (int i=0; i<count; i++)
    {      
      TemporalSlot slot = (TemporalSlot) data.get(i);

      maxValue = max(slot.count, maxValue);
      
      
      float heightPercent = slot.count / maxValue;
      float barHeight = heightPercent * height;
      
      // Color histogram bar based on the specific time frame
      if (slot.date.getTime() > minDate.getTime() && slot.date.getTime() < maxDate.getTime()) {
        barColor = #bb207f;
      }else{
        barColor = #027B9E; // white map - #001534;
      }
      

      if (bars[i] == null)
      {
        bars[i] = new HistogramBar(xpos + (i * (width / bars.length)), ypos+height, width / bars.length, barHeight, barColor);
      }
      else {
        bars[i].updateHeight(barHeight);
      }
    }
  }
}

