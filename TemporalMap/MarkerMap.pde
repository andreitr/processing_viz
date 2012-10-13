import java.awt.Color;

class MarkerMap
{
  float xpos;
  float ypos;
  float width;
  float height;

  float clusterSize = 10;
  float clusterMax = 0;

  MercatorMap mercatorMap;

  PImage heatmap;

  ArrayList data;
  int markerCursor;

  HashMap<String, Bubble[]> hashTable = new HashMap<String, Bubble[]>();
  HashMap<String, Cluster> clusterTable = new HashMap<String, Cluster>();
  HashMap<String, Cluster> heatmapTable = new HashMap<String, Cluster>();

  MarkerMap(float x, float y, float width, float height, ArrayList data, PImage heatmap)
  {
    xpos = x;  
    ypos = y;

    this.width = width;
    this.height = height;

    this.data = data;
    this.heatmap = heatmap;

    // USA
    mercatorMap = new MercatorMap(800, 525, 52, 20, -127, -65);
  }

  void update(float playhead)
  {
    generateMarkers(int(playhead * float(data.size()) / 100));

    for (int i=0; i<markerCursor; i++)
    {
      for (int j=0; j<hashTable.get(i+"").length; j++)
      {
        Bubble bubble = (Bubble) hashTable.get(i+"")[j];
        hashTable.get(i+"")[j].update(getClusterColor(getClusterHash(bubble.x, bubble.y), false));
      }
    }
  }

  void generateMarkers(int count)
  {
    markerCursor = count;

    for (int i=0; i<count; i++)
    {
      if (!hashTable.containsKey(i+""))
      {
        TemporalSlot slot = (TemporalSlot) data.get(i);

        hashTable.put(i+"", new Bubble[slot.locations.size()]);

        for (int j=0; j<slot.locations.size(); j++)
        {
          Location loc = (Location) slot.locations.get(j);
          PVector location = mercatorMap.getScreenLocation(new PVector(loc.lat, loc.lon));

          hashTable.get(i+"")[j] = new Bubble(location.x, location.y, getClusterColor(getClusterHash(location.x, location.y), true));
        }
      }
    }
  }

  color getClusterColor(String clusterHash, Boolean increment)
  {
    Cluster cluster;
    int colorCursor;

    if (clusterTable.containsKey(clusterHash))
    {
      cluster = (Cluster) clusterTable.get(clusterHash);

      // Increment only when markers are generated, not updated.
      if (increment )
      {
        cluster.value += 1;
        clusterMax = max(clusterMax, cluster.value);
      }

      colorCursor = (int)floor((cluster.value / clusterMax) * heatmap.width);
      if (colorCursor > heatmap.width-1 ) colorCursor = heatmap.width-1;
      if (colorCursor < 1) xpos = 1;

      cluster.clr = heatmap.get(colorCursor, 1);
    }
    else {
      colorCursor = 0;
      clusterTable.put(clusterHash, new Cluster(1, heatmap.get(1, 1)));
      cluster = (Cluster) clusterTable.get(clusterHash);
    }

    if (!heatmapTable.containsKey(colorCursor+""))
    {
      heatmapTable.put(colorCursor+"", new Cluster(1, cluster.clr));
    }
    else {
      heatmapTable.get(colorCursor+"").value +=1 ;
    }

    return cluster.clr;
  }

  HashMap getHeatmap()
  {
    return heatmapTable;
  }

  String getClusterHash(float x, float y)
  {
    return round(x / clusterSize)+"."+round(y / clusterSize);
  }
}

class Cluster
{
  int value;
  color clr;

  Cluster(int value, color clr)
  {
    this.value = value;
    this.clr = clr;
  }
}

