import 'dart:async';
import 'dart:collection';
import 'package:rxdart/rxdart.dart';
import 'package:provider_stream_shopper/models/catalog.dart';

class CartModel {
  /// The private field backing [catalog].
  final _catalog = BehaviorSubject<CatalogModel>();

  /// Internal, private state of the cart. Stores items.
  final _items = BehaviorSubject<List<Item>>.seeded([]);

  /// The current catalog.
  Stream<CatalogModel> get catalog => _catalog.stream;

  /// List of items in the cart.
  Stream<UnmodifiableListView<Item>> get items =>
      _items.map((e) => UnmodifiableListView(e));

  /// The current total price of all items.
  Stream<int> get totalPrice => items
      .map((items) => items.fold(0, (total, current) => total + current.price));

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Item item) {
    // This line tells _items value is updated by adding new item,
    // and emits the updated one.
    _items.value = _items.value..add(item);
  }

  void updateCatalog(CatalogModel newCatalog) {
    assert(newCatalog != null);
    // Rebuild Items with new catalog.
    final newItems = _items.value.map((item) => newCatalog.getById(item.id));

    assert(newItems.every((item) => item != null),
        'The catalog $newCatalog does not have one of ${_items.value.map((i) => i.id).toList()} in it.');

    _items.value = newItems.toList();
    _catalog.value = newCatalog;
  }

  void dispose() {
    _items.close();
    _catalog.close();
  }
}
