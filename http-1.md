# Database Communication via API

### Define the URI
```dart
var  url = Uri.https("https://test-fe651-default-rtdb.firebaseio.com", "/products.json");
```

### HTTP POST  (Create)

```dart
// async automatically returns the future.
  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
        }),
      );
      // use the awaitaed object
      json.decode(response.body);
    } catch (error) {
      print(error);
      throw error; // for widgets to catch.
    }
  }
```
### HTTP GET (Read)
```dart
Future<void> fetchProduct() async {
    final response = await http.get(url);
    final extactedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    extactedData.forEach((productID, productData) { 
      loadedProducts.add(Product(
        id: productID,
        title: productData['title'],
        ...
      ));
    });
  }
```
### HTTP PATCH (Update)
```dart
// url should include the id at the end
http.patch(url, json.encode({
      'title': new_prod.Title,
    });
```
### HTTP DELETE (Delete)
```dart
// url should include the id at the end
http.delete(url);
```
**Handling errors gracefully**
```dart
http.delete(url)
	.then(
		//then execute this.
		// also check for status code here.
		)
		.catchError(
			// if error occurs in deleting the product, roll back it.
			// Insert the product again.
			);
```
### Exception Handling
For custom error reporting.
```dart
class HttpException implements Exception {
  final String message;
  
  HttpException(this.message);
  
  @override
  String toString() {
    return message;
  }
}
```
```dart
throw HttpException("Could not find a product");
```
### Future Builder
Future Builder builds the widgets based on future data.
Widget that builds itself based on the latest snapshot of interaction with a Future.

