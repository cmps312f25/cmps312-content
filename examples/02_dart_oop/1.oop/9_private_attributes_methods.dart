// bank_account.dart
class BankAccount {
  // Private property
  double _balance = 0;

  // Public method to deposit money
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('Deposited: $amount');
    } else {
      print('Invalid deposit amount');
    }
  }

  // Public method to withdraw money
  void withdraw(double amount) {
    if (_canWithdraw(amount)) {
      _balance -= amount;
      print('Withdrew: $amount');
    } else {
      print('Insufficient funds or invalid amount');
    }
  }

  // Public getter
  double get balance => _balance;

  // Private method
  bool _canWithdraw(double amount) => amount > 0 && amount <= _balance;
}

void main() {
  var account = BankAccount();

  account.deposit(100);
  account.withdraw(40);

  print('Balance: ${account.balance}'); // ✅ Allowed
  // print(account._balance);          // ❌ Error: private
  // account._canWithdraw(50);         // ❌ Error: private
}
