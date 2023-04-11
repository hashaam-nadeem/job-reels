class DocumentModel {
  int id;
  String fileName;
  String filePath;
  String fileSize;
  String dateTime;
  String filetype;
  String shortFileName;
  bool isDownload;

  DocumentModel(
      {
        required this.id,
        required this.fileName,
        required this.filePath,
        required this.fileSize,
        required this.dateTime,
        required this.isDownload,
        required this.filetype,
        required this.shortFileName,
      });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id : json['id'],
      fileName : json['file_name']??"",
      filePath : json['file_path']??"",
      fileSize : json['file_size']??"",
      dateTime : json['download_date_time']??"",
      filetype : json['type']??"",
      shortFileName : json['short_file_name']??"",
      isDownload : json['is_download']==1,

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file_name'] = fileName;
    data['file_path'] = filePath;
    data['file_size'] = fileSize;
    data['download_date_time'] = dateTime;
    data['type'] = filetype;
    data['short_file_name'] = shortFileName;
    data['is_download'] = isDownload?1:0;
    return data;
  }
}
