class ClusterGrid {

  int cellSize;
  float width;
  float height;

  PGraphics gridLayer;
  PGraphics circLayer;

  int layerAlpha = 130;

  HashMap<String, Cluster> clusterTable;

  ClusterGrid(float width, float height) {
    this.cellSize = 5;
    this.width = width;
    this.height = height;    

    clusterTable =  new  HashMap<String, Cluster>();
  }

  /**
   * Reset cluster table for a new temporal slot.
   * When this is called sentimet grid is not compounded.
   */
  public void reset()
  {
    clusterTable =  new  HashMap<String, Cluster>();
  }

  /**
   * Renders new cluster grid.
   * NOTE - Find a way to save previously-rendered grid and then do a fade out.
   */
  public void render(int maxPointsInCluster) 
  {
    gridLayer = createGraphics((int)this.width, (int)this.height, JAVA2D);
    circLayer = createGraphics((int)this.width, (int)this.height, JAVA2D);
    drawGrid(gridLayer, circLayer, maxPointsInCluster);

    tint(255, layerAlpha);
    image(gridLayer, 0, 0);
    tint(255, 255);
    image(circLayer, 0, 0);
  }

  /**
   *  Updates the display without re-calculating clusters.
   */
  public void update()
  {

    //    tint(255, layerAlpha);
    //    image(gridLayer, 0, 0); 
    //    image(circLayer, 0, 0);
    //    tint(255, 255);
  }

  /**
   * Draw cluster grid and 
   * @param PGraphics
   */
  private void drawGrid(PGraphics grid, PGraphics circle, int maxPointsInCluster)
  {
    grid.beginDraw();
    circle.beginDraw();

    // Draw heatmap grid
    for (int x=0; x<round(this.width / this.cellSize); x++) {
      for (int y=0; y<round(this.height / this.cellSize); y++) {

        Cluster cluster = (Cluster) getCluster(getClusterHash(x*this.cellSize, y*this.cellSize));

        // Draw clusters that contain sentiment data
        if (cluster.hasSentiment)
        { 
          float radPercent = (float)cluster.count / (float)maxPointsInCluster;
          float rad = radPercent * 30;

          cluster.drawCircle(x*this.cellSize, y*this.cellSize, rad, circle);

          cluster.drawSquare(x*this.cellSize, y*this.cellSize, this.cellSize, grid);
        }
      }
    }
    circle.endDraw();
    grid.endDraw();
  }

  /**
   *  Creates and returns a new clsuter
   *
   * @param x float
   * @param y float
   */
  public Cluster initCluster(float x, float y) {

    Cluster cluster = getCluster(getClusterHash(x, y));
    cluster.x = floor(x / this.cellSize);
    cluster.y = floor(y / this.cellSize);

    return cluster;
  }


  /**
   * Creates a new cluster and addds it to the clusterTable,
   * or returns an already-existing one. 
   *
   * @param clusterHash String
   */
  public Cluster getCluster(String clusterHash) {

    if (clusterTable.containsKey(clusterHash))
    {
      return clusterTable.get(clusterHash);
    }
    else {
      clusterTable.put(clusterHash, new Cluster());
      return clusterTable.get(clusterHash);
    }
  }

  /**
   * Creates a hash string based on x and y parameter
   *
   * @param float x
   * @param float y
   */
  protected String getClusterHash(float x, float y) {
    return floor((int)x / this.cellSize)+"."+floor((int)y / this.cellSize);
  }
}

