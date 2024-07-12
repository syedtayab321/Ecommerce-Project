class CartItem {
  final String categoryName;
  final double price;
  final int selectedQuantity;
  final double totalPrice;
  bool isSelected;

  CartItem({
    required this.categoryName,
    required this.price,
    required this.selectedQuantity,
    required this.totalPrice,
    this.isSelected = false,
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      categoryName: data['Category Name'],
      price: data['Total Price'] / data['Selected quantity'], // Assuming price per item
      selectedQuantity: data['Selected quantity'],
      totalPrice: data['Total Price'],
    );
  }
}
