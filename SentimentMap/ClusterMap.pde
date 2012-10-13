class ClusterMap
{
  float xpos;
  float ypos;
  float width;
  float height;

  // Max points contained within a cluster
  int maxPoints = 0;
  
  MercatorMap mercatorMap;
  ClusterGrid clusterGrid;

  PImage heatmap;

  ArrayList data;
  int markerCursor;

  ClusterMap(float x, float y, float width, float height, ArrayList data, PImage heatmap)
  {
    xpos = x;  
    ypos = y;

    this.width = width;
    this.height = height;

    this.data = data;
    this.heatmap = heatmap;

    // USA
    mercatorMap = new MercatorMap(800, 525, 52, 20, -127, -65);
    clusterGrid = new ClusterGrid(this.width, this.height);
  }

  void update(float playhead)
  {

    int count = int(playhead * float(data.size()) / 100);
    if (count > 0 ) {

      if (count != markerCursor)
      {
        // Don't call reset, display componded
        //this.clusterGrid.reset();

        generateClusters(count);
      }
      this.clusterGrid.render(maxPoints);
    }
  }

  /**
   * Generates new or updates existing map clusters.
   * @param int count
   */
  void generateClusters(int count)
  {
    markerCursor = count;

    if (count < data.size()) {

      TemporalSlot slot = (TemporalSlot) data.get(count);

      for (int j=0; j<slot.locations.size(); j++)
      {
        Location loc = (Location) slot.locations.get(j);
        PVector location = mercatorMap.getScreenLocation(new PVector(loc.lat, loc.lon));

        // Retrieve appropriate cluster
        Cluster cluster = (Cluster) clusterGrid.initCluster(location.x, location.y);
        cluster.sentiment.heatmap = this.heatmap;

        // Assing sentiment value to a cluster
        cluster.setSentiment(loc.sentiment);

        maxPoints = max(cluster.setCount(1), maxPoints);
      }
    }
  }
}
