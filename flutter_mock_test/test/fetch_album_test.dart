import 'package:flutter_test/flutter_test.dart'; // lib de testes
import 'package:mockito/mockito.dart'; // lib para testes mock
import 'package:flutter_mock_test/main.dart'; // importa as funcoes que serao testadas
import 'package:mockito/annotations.dart'; // annotation para gerar os mocks
import 'package:http/http.dart' as http;
import 'fetch_album_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();

      // Usando o mockito para retornar uma resposta com sucesso
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async =>
              http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchAlbum(client),
          isA<Album>()); // Testando para ver se a requisicao retornou um objeto do tipo Album
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Testando o comportamento de um erro 404 NotFound
      when(client
              .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
          fetchAlbum(client), throwsException); // Tratamento de erro(excessão)
    });
  });
}
