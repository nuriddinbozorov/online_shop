import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  double get total => _items.fold(0, (sum, item) => sum + item.total);

  void clear() {
    _items.clear();
  }
}
