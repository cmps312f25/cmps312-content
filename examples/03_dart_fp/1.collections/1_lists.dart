void main() {
  List<String> colors = ["Red", "Green", "Blue"];
  var names = ["Ali", "Ahmed", "Sara"];
  
  var nums = [2, 3, 4];
  var nullNums = List<int?>.filled(10, null);

  nums.add(8);
  nums.insert(0, 1);
  nums.removeAt(2);
  nums.remove(4);
  nums.removeLast();
  nums.removeRange(0, 2);
  nums.removeWhere((num) => num > 3);
  nums.removeRange(0, nums.length);
  print('List length after clearing: ${nums.length}');
  
  // Fix: Don't access elements of empty list
  // nums[1];         // This would cause "Valid value range is empty" error
  // nums[2] = 5;     // This would cause "Valid value range is empty" error
  
  // These operations are safe on empty lists
  print('Index of 4: ${nums.indexOf(4)}');  // Returns -1 if not found
  print('Contains 8: ${nums.contains(8)}');  // Returns false
  nums.addAll([1, 2, 3]);
  nums.addAll([4, 5, 6]);
  
  // Safe way to access list elements with bounds checking
  if (nums.isNotEmpty && nums.length > 1) {
    print('Element at index 1: ${nums[1]}');
  }
  
  if (nums.isNotEmpty && nums.length > 2) {
    nums[2] = 5;
    print('Set element at index 2 to 5');
  }

  colors.forEach((color) => print(color));
  names.forEach((name) => print(name));
  nums.forEach((num) => print(num));
  nullNums.forEach((num) => print(num));
}