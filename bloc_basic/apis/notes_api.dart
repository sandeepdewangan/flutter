import 'package:notes_app/models.dart';

abstract class NotesApiProtocol {
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (loginHandle == const LoginHandle.fooBar()) {
      return mockNotes;
    }
    return null;
  }
}
