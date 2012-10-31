import processing.video.*;

String source = "data/gaga.csv";
String resolution = "minute";
String video = "video/sotu.mov";

ArrayList data = new ArrayList();

Histogram histogram;
MarkerMap markerMap;

Boolean ready = false;

float currentSlot = 0;

PImage bg;
PFont font;
PImage heatmap;

void setup()
{
  size(800, 525);
  frameRate(60);

  heatmap = loadImage("/assets/gradient_5.png");
  bg = loadImage("/assets/sotu.png");
  font = loadFont("/data/Helvetica-Light-18.vlw");

  loadData();
}

void draw()
{
  background(bg);

  if (ready)
  {
    markerMap.update(currentSlot / data.size() * 100);
    histogram.update(currentSlot / data.size() * 100);

    TemporalSlot slot;
    String date;
    textFont(font); 
    fill(255, 128);

    try
    {
      slot = (TemporalSlot) data.get((int)currentSlot);
    }
    catch( IndexOutOfBoundsException error)
    {
      slot = (TemporalSlot) data.get(data.size()-1);
    }
    date = stripLeadingAndTrailingQuotes(slot.dateString);
    text(date, 10, height - 90);

    image(heatmap, 410, height - 104, 100, 15);
    text("Maximum cluster size: "+markerMap.clusterMax, 520, height - 90);

    //    if ((currentSlot / data.size() * 100) < 100)
    //    {
    if (ready)
    {
      saveFrame("frames/frame_####.png");
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

    // Restrict points by bounding box
    if (lon >= -127 && lon <= -65 && lat <= 52 && lat >= 20) {

      Location loc = new Location(lat, lon);

      try
      {
        hash = getTimeHash((Date)dateFormatter.parse(stripLeadingAndTrailingQuotes(date)));

        if (!hashTable.containsKey(hash))
        {
          ArrayList locs = new ArrayList();
          locs.add(loc);
          hashTable.put(hash, new TemporalSlot(date, (Date)dateFormatter.parse(stripLeadingAndTrailingQuotes(date)), (float)1, locs));
        }
        else {

          hashTable.get(hash).count += 1;
          hashTable.get(hash).locations.add(loc);
        }
      }
      catch(ParseException e)
      {
        // println(e);
      }
    }
  }

  println(lines.length);

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

  histogram = new Histogram(10, height-80, width - 20, 70, data);
  markerMap = new MarkerMap(0, 0, 800, 600, data, heatmap);

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
  if (resolution == "minute")
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

