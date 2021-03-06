import 'dart:io';

main() async {
  var path = 'lib/property/'; // ends with /
  var sourceFilePrefix = 'class'; // constant
  var destinationFilePrefix = 'property';
  var newClass = 'Property';

  await renameFiles(path, sourceFilePrefix, destinationFilePrefix);
  replacePupil(new File(path + destinationFilePrefix + '.dart'), newClass);
  replaceBloc(new File(path + destinationFilePrefix + '_bloc.dart'), newClass);
  replaceDao(new File(path + destinationFilePrefix + '_dao.dart'), newClass);
  replaceEvent(
      new File(path + destinationFilePrefix + '_event.dart'), newClass);
  replaceState(
      new File(path + destinationFilePrefix + '_state.dart'), newClass);
  replacePage(new File(path + 'page.dart'), newClass);
}

renameFiles(
    String path, String sourceFilePrefix, String destinationFilePrefix) async {
  // List all files in the current directory in UNIX-like systems.
  ProcessResult results = await Process.run('ls', [path]);
  List<String> files = results.stdout.toString().split("\n");
  print(files);
  for (final file in files) {
    print(file);
    var source = path + file;
    var destination =
        source.replaceAll(sourceFilePrefix, destinationFilePrefix);
    print('$source => $destination');
    results = await Process.run('git', ['mv', source, destination]);
  }
}

replaceState(File stateFile, String newClass) {
  print(stateFile);
  var content = stateFile.readAsStringSync();
  content = content.replaceAll('ClassState', newClass + 'State');
  content = content.replaceAll('ClassLoading', newClass + 'Loading');
  content = content.replaceAll('ClassLoaded', newClass + 'Loaded');
  content = content.replaceAll('classes', newClass.toLowerCase() + 's');
  content = content.replaceAll('Class', newClass);
  content = content.replaceAll('\'class', newClass.toLowerCase());
  stateFile.writeAsStringSync(content);
}

replaceEvent(File stateFile, String newClass) {
  print(stateFile);
  var content = stateFile.readAsStringSync();
  content = content.replaceAll('ClassEvent', newClass + 'Event');
  content = content.replaceAll('LoadClass', 'Load$newClass');
  content = content.replaceAll('AddClass', 'Add$newClass');
  content = content.replaceAll('UpdateClass', 'Update$newClass');
  content = content.replaceAll('DeleteClass', 'Delete$newClass');
  content = content.replaceAll('Class', newClass);
  content = content.replaceAll('\'class', newClass.toLowerCase());
  stateFile.writeAsStringSync(content);
}

replaceDao(File stateFile, String newClass) {
  print(stateFile);
  var content = stateFile.readAsStringSync();
  content = content.replaceAll('ClassDao', newClass + 'Dao');
  content =
      content.replaceAll('_classStore', '_${newClass.toLowerCase()}Store');
  content = content.replaceAll('Class', newClass);
  content = content.replaceAll('\'class', newClass.toLowerCase());
  stateFile.writeAsStringSync(content);
}

replaceBloc(File stateFile, String newClass) {
  print(stateFile);
  var content = stateFile.readAsStringSync();
  content = content.replaceAll('ClassBloc', newClass + 'Bloc');
  content = content.replaceAll('ClassDao', newClass + 'Dao');
  content = content.replaceAll('ClassEvent', newClass + 'Event');
  content = content.replaceAll('ClassState', newClass + 'State');
  content = content.replaceAll('ClassLoading', newClass + 'Loading');
  content = content.replaceAll('ClassLoaded', newClass + 'Loaded');
  content = content.replaceAll('LoadClass', 'Load$newClass');
  content = content.replaceAll('AddClass', 'Add$newClass');
  content = content.replaceAll('UpdateClass', 'Update$newClass');
  content = content.replaceAll('DeleteClass', 'Delete$newClass');
  content = content.replaceAll('classes', newClass.toLowerCase() + 's');
  content = content.replaceAll('Class', newClass);
  content = content.replaceAll('\'class', newClass.toLowerCase());
  stateFile.writeAsStringSync(content);
}

replacePupil(File stateFile, String newClass) {
  print(stateFile);
  var content = stateFile.readAsStringSync();
  content = content.replaceAll('Class', newClass);
  content = content.replaceAll('\'class', newClass.toLowerCase());
  stateFile.writeAsStringSync(content);
}

replacePage(File stateFile, String newClass) {
  print(stateFile);
  var content = stateFile.readAsStringSync();
  content = content.replaceAll('ClassBloc', newClass + 'Bloc');
  content = content.replaceAll('ClassState', newClass + 'State');
  content = content.replaceAll('ClassLoading', newClass + 'Loading');
  content = content.replaceAll('ClassLoaded', newClass + 'Loaded');
  content = content.replaceAll('LoadClass', 'Load$newClass');
  content = content.replaceAll('AddClass', 'Add$newClass');
  content = content.replaceAll('UpdateClass', 'Update$newClass');
  content = content.replaceAll('DeleteClass', 'Delete$newClass');
  content = content.replaceAll('Class', newClass);
  content = content.replaceAll('\'class', newClass.toLowerCase());
  stateFile.writeAsStringSync(content);
}
