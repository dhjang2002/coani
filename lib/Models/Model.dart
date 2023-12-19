abstract class Model{
  Map<String, String> toMap();
  String getFilename();
  void clear();

  bool isEmpty(String value){
    if(value==null)
      return false;
    return (value.length>0)? true: false;
  }
}