import 'package:file_picker/file_picker.dart';

Future<List> filepicker() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  if (result != null) {
    return [
      result.files.single.path.toString(),
      result.files.single.name.toString()
    ];
  } else {
    return [];
  }
}
