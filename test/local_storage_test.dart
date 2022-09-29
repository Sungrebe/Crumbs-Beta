import 'dart:io';

import 'package:crumbs/utilities/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'local_storage_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  var testLocalStorage = MockLocalStorage();
  TestWidgetsFlutterBinding.ensureInitialized();
  group('local storage tests', () {
    test('documentsDirectory', () async {
      String documentsDirectoryPath;
      when(await testLocalStorage.documentsDirectory).thenAnswer((realInvocation) {
        documentsDirectoryPath = 'documentsDirectory';
        expect(documentsDirectoryPath, isNotNull);
        return documentsDirectoryPath;
      });
    });

    test('createFile', () async {
      File file;
      when(await testLocalStorage.createFile('file.txt')).thenAnswer((realInvocation) {
        file = File('file.txt');
        expect(file.exists(), equals(true));
        return file;
      });
    });

    test('writeContent', () async {
      var file = File('file.txt');
      var content = 'some content';
      when(await testLocalStorage.writeContent(content, file)).thenAnswer((realInvocation) {
        file.writeAsString(content).then(
          (value) {
            file = value;
          },
        );

        expect(file.exists(), equals(true));
        return file;
      });
    });

    test('readContent', () async {
      var file = File('file.txt');
      var content = 'some content';
      when(await testLocalStorage.writeContent(content, file)).thenAnswer((realInvocation) {
        expect(file.exists(), equals(true));
        return file;
      });

      var fileContent = '';
      when(await testLocalStorage.readContent(file)).thenAnswer((realInvocation) {
        file.readAsString().then(
          (value) {
            fileContent = value;
          },
        );
        expect(fileContent, equals('some content'));
        return fileContent;
      });
    });
  });
}
