class TemporalSlot
{
  String dateString;
  Date date;
  ArrayList locations;
  float count;
  Sentiment sentiment;
  
  TemporalSlot(String dateString, Date date, float count, ArrayList locations, Sentiment sentiment)
  {
    this.dateString = dateString;
    this.date = date;
    this.locations = locations;
    this.count = count;
    this.sentiment = sentiment;
  }
}
