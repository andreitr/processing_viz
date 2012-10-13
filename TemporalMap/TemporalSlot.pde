class TemporalSlot
{
  String dateString;
  Date date;
  ArrayList locations;
  float count;
  
  TemporalSlot(String dateString, Date date, float count, ArrayList locations)
  {
    this.dateString = dateString;
    this.date = date;
    this.locations = locations;
    this.count = count;
  }
}
