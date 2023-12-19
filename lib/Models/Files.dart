import 'Model.dart';

class Files extends Model {
  String? id;                       // 레코드번호
  String? photo_id;                 
  String? photo_type;                
  String? name;                    
  String? path;
  String? url;
  String? file_size;              
  String? created_at;              
  
  Files({this.id="", this.photo_id="", this.photo_type="", this.name="", this.path="",
    this.url="", this.file_size="", this.created_at=""
  });

  factory Files.fromJson(Map<String, dynamic> parsedJson)
  {
      return Files(
        id: parsedJson['id'],
        photo_id: parsedJson['photo_id'],
        photo_type: parsedJson ['photo_type'],
        name: parsedJson ['name'],
        path: parsedJson ['path'],
        url: parsedJson ['url'],
        file_size: parsedJson ['file_size'],
        created_at: parsedJson ['created_at'],
      );
    }

  static List<Files> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Files.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Files {id:$id, photo_id:$photo_id, photo_type:$photo_type, name:$name, path:$path, '
        'url:$url, file_size:$file_size, created_at:$created_at}';
  }

  @override
  Map<String, String> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  String getFilename(){
    return "Files.dat";
  }

  @override
  void clear() {
    // TODO: implement clear
  }
}