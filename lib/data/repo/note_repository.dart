import 'package:dio/dio.dart';
import 'package:notes/data/Models/note_model.dart';
import '../../core/networks/dio_client.dart';

class NoteRepository {
  final Dio _dio = ApiClient.instance;
  Future<List<NoteModel>> fetchNotes() async {
    try {
      final response = await _dio.get('/notes');
      return (response.data as List).map((e) => NoteModel.fromJson(e)).toList();
    } catch (e) {
      throw "فشل تحميل الملحوظات";
    }
  }

  Future<NoteModel> addNote(
      {required String title, required String content}) async {
    try {
      final response = await _dio.post(
        '/notes',
        data: {
          'title': title,
          'content': content,
        },
      );
      return NoteModel.fromJson(response.data);
    } catch (e) {
      throw "فشل إضافة الملحوظة";
    }
  }

  Future<NoteModel> editNote({
    required int id,
    required String title,
    required String content,
  }) async {
    try {
      final response = await _dio.put(
        '/notes/$id',
        data: {
          'title': title,
          'content': content,
        },
      );
      return NoteModel.fromJson(response.data);
    } catch (e) {
      throw "فشل تعديل الملحوظة";
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _dio.delete('/notes/$id');
    } catch (e) {
      throw "فشل حذف الملحوظة";
    }
  }
}
