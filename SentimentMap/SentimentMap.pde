import processing.video.*;

String source = "data/sample.csv";
String resolution = "minute";

ArrayList data = new ArrayList();

Legend legend;
Histogram histogram;
ClusterMap clusterMap;

float total_pos_sentiment = 0;
float total_neg_sentiment = 0;
float total_nut_sentiment = 0;
float total_tweets = 0;

Boolean ready = false;

float currentSlot = 0;

PImage bg;
PFont font;
PImage heatmap;

void setup()
{
  size(800, 525);
  frameRate(60);
  heatmap = loadImage("/assets/sentiment_heatmap.png");
  bg = loadImage("/assets/sentiment.png");
  font = loadFont("/data/Helvetica-Light-18.vlw");

  loadData();
}



void draw()
{
  background(bg);

  if (ready)
  {
    clusterMap.update(currentSlot / data.size() * 100);
    histogram.update(currentSlot / data.size() * 100);

    TemporalSlot slot;
    String date;
    textFont(font); 
    fill(0, 220);

    try
    {
      slot = (TemporalSlot) data.get((int)currentSlot);
    }
    catch( IndexOutOfBoundsException error)
    {
      slot = (TemporalSlot) data.get(data.size()-1);
    }
    date = stripLeadingAndTrailingQuotes(slot.dateString);

    date = date.substring(0, date.length() - 11)+" 2012";

    text(date, 10, height - 90);
    text("Displaying "+(int)this.total_tweets+" #superbowl tweets", 480, height-90);

    if ((currentSlot / data.size() * 100) < 100)
    {
      // Update total sentiment count
      total_pos_sentiment += slot.sentiment.positive;
      total_neg_sentiment += slot.sentiment.negative;
      total_nut_sentiment += slot.sentiment.neutral;

      total_tweets += slot.locations.size();
    }

    legend.update(clusterMap.maxPoints, total_pos_sentiment, total_neg_sentiment, total_nut_sentiment);


    //    if ((currentSlot / data.size() * 100) < 100)
    //    {
    if (ready )
    {
      saveFrame("frames/frame-####.png");
    }
    else {
      // movieMaker.finish();
    }
    //}


    if (int(frameCount % 1) == 0 && currentSlot < data.size())
    {
      if (currentSlot + 1 > data.size())
      {
        currentSlot = data.size();
      }
      else {
        currentSlot +=1;
      }
    }
  }
}

void loadData()
{
  String lines[] = loadStrings(source);
  String csv[][];
  int csvWidth=0;

  //calculate max width of csv file
  for (int i=0; i < lines.length; i++) {
    String [] chars=split(lines[i], ',');
    if (chars.length > csvWidth) 
    {
      csvWidth=chars.length;
    }
  }

  //create csv array based on # of rows and columns in csv file
  csv = new String [lines.length][csvWidth];
  DateFormat dateFormatter;
  dateFormatter = new SimpleDateFormat("EEE MMM d HH:mm:ss Z yyyy");
  String hash;
  HashMap<String, TemporalSlot> hashTable = new HashMap<String, TemporalSlot>();

  int maxValue = 0;

  //parse values into 2d array
  for (int i=0; i < lines.length; i++) 
  {
    String [] temp = new String [lines.length];

    String date = lines[i].split(",")[0];
    float lat = Float.parseFloat(lines[i].split(",")[1]);
    float lon = Float.parseFloat(lines[i].split(",")[2]);
    float sen = Float.parseFloat(lines[i].split(",")[3]);

    // Restrict points by bounding box
    if (lon >= -127 && lon <= -65 && lat <= 52 && lat >= 20) {

      Location loc = new Location(lat, lon, sen);

      try
      {
        hash = getTimeHash((Date)dateFormatter.parse(stripLeadingAndTrailingQuotes(date)));

        if (!hashTable.containsKey(hash))
        {
          // Add loations
          ArrayList locs = new ArrayList();
          locs.add(loc);

          // Add sentiment 
          Sentiment sent = new Sentiment();
          sent.heatmap = this.heatmap;
          sent.update(sen);

          hashTable.put(hash, new TemporalSlot(date, (Date)dateFormatter.parse(stripLeadingAndTrailingQuotes(date)), (float)1, locs, sent));
        }
        else {

          hashTable.get(hash).count += 1;
          hashTable.get(hash).locations.add(loc);
          hashTable.get(hash).sentiment.update(sen);
        }
      }
      catch(ParseException e)
      {
        // println(e);
      }
    }
  }

  generateData(hashTable);
}


void generateData(HashMap<String, TemporalSlot> table)
{
  Iterator i = table.entrySet().iterator();

  while (i.hasNext ()) 
  {
    java.util.Map.Entry me = (java.util.Map.Entry)i.next();
    data.add(me.getValue());
  }

  legend = new Legend(width-236, height-80, 224, 70);
  histogram = new Histogram(10, height-80, width-246, 70, data);
  clusterMap = new ClusterMap(0, 0, 800, 600, data, heatmap);

  // Sort data on the date
  Collections.sort(data, new Comparator() 
  {
    public int compare(Object o1, Object o2) {
      TemporalSlot p1 = (TemporalSlot) o1;
      TemporalSlot p2 = (TemporalSlot) o2;
      return p1.dateString.compareToIgnoreCase(p2.dateString);
    }
  }
  );

  ready = true;
}



String getTimeHash(Date date)
{
  if (resolution == "10 minute")
  {
    return new String(date.getYear()+"-"+date.getMonth()+"-"+date.getDay()+"-"+date.getHours()+"-"+round((float)date.getMinutes()/10)*10);
  }
  else if (resolution == "second")
  {
    return new String(date.getYear()+"-"+date.getMonth()+"-"+date.getDay()+"-"+date.getHours()+"-"+date.getMinutes()+"-"+date.getSeconds());
  }
  else if (resolution == "minute")
  {
    return new String(date.getYear()+"-"+date.getMonth()+"-"+date.getDay()+"-"+date.getHours()+"-"+date.getMinutes());
  }
  else if (resolution == "hour")
  {
    return new String(date.getYear()+"-"+date.getMonth()+"-"+date.getDay()+"-"+date.getHours());
  }
  else if (resolution == "day")
  {
    return new String(date.getYear()+"-"+date.getMonth()+"-"+date.getDay());
  }
  else {
    return "";
  }
}

/**
 * Format string, get rid of additional quotes.
 */
String stripLeadingAndTrailingQuotes(String str)
{
  if (str.startsWith("\""))
  {
    str = str.substring(1, str.length());
  }
  if (str.endsWith("\""))
  {
    str = str.substring(0, str.length() - 1);
  }
  return str;
}

