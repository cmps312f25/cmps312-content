# 📝 Input & Form Controls

---

## 📝 Input & Form Controls

**Widgets for data entry and selection**

> ![⌨️](https://img.icons8.com/color/48/000000/form.png)

Flutter provides comprehensive form and input widgets for collecting user data. These widgets support validation, formatting, and various input types to create robust, user-friendly forms.

---

# 🧱 Text Inputs

## 1️⃣ TextField
### Overview
- **Purpose:** Basic text input field for user data entry.
- **Key Properties:** `controller`, `decoration`, `keyboardType`, `obscureText`, `maxLines`, `onChanged`.
- **Events:** `onChanged`, `onSubmitted`, `onTap`, `onEditingComplete`.
- **Usage Scenarios:** Simple forms, search bars, comments, chat inputs.

#### Speaker Notes
- TextField is the foundation for text input, offering flexibility and customization.

---

### 2️⃣ Example
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email Address',
    hintText: 'Enter your email',
    prefixIcon: Icon(Icons.email),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
  ),
  keyboardType: TextInputType.emailAddress,
  onChanged: (value) {
    print('Email: $value');
  },
)
```

---

### 3️⃣ Best Practices
- Use `TextEditingController` for accessing and controlling input.
- Set appropriate `keyboardType` for input type.
- Provide clear labels and hints.
- Use `InputDecoration` for consistent styling.
- Dispose controllers properly to prevent memory leaks.

#### Speaker Notes
- TextField is highly customizable. Always match keyboard type to expected input.

---

## 1️⃣ TextFormField
### Overview
- **Purpose:** Text input with built-in validation for forms.
- **Key Properties:** `controller`, `decoration`, `validator`, `autovalidateMode`, `keyboardType`.
- **Events:** `onChanged`, `onSaved`, `validator`.
- **Usage Scenarios:** Forms with validation, registration, login, data entry.

#### Speaker Notes
- TextFormField extends TextField with validation, ideal for Form widgets.

---

### 2️⃣ Example
```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a username';
          }
          if (value.length < 3) {
            return 'Username must be at least 3 characters';
          }
          return null;
        },
      ),
      SizedBox(height: 16),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print('Form is valid');
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

---

### 3️⃣ Best Practices
- Always use within a `Form` widget.
- Implement comprehensive validators.
- Use `autovalidateMode` for real-time feedback.
- Call `Form.validate()` before submission.
- **Recommended:** Use TextFormField over TextField for forms requiring validation.

#### Speaker Notes
- TextFormField is the best choice for validated forms. It integrates seamlessly with Form widgets.

---

# 🧱 Boolean & Toggle Inputs

## 1️⃣ Checkbox
### Overview
- **Purpose:** Toggle input for binary choices.
- **Key Properties:** `value`, `onChanged`, `activeColor`, `tristate`, `shape`.
- **Events:** `onChanged`.
- **Usage Scenarios:** Terms acceptance, feature toggles, multi-select lists.

#### Speaker Notes
- Checkbox is standard for yes/no selections and multi-select scenarios.

---

### 2️⃣ Example
```dart
bool _acceptTerms = false;

CheckboxListTile(
  title: Text('I accept the Terms and Conditions'),
  subtitle: Text('Required to continue'),
  value: _acceptTerms,
  onChanged: (bool? value) {
    setState(() {
      _acceptTerms = value ?? false;
    });
  },
  activeColor: Colors.blue,
  controlAffinity: ListTileControlAffinity.leading,
)
```

---

### 3️⃣ Best Practices
- Use `CheckboxListTile` for labeled checkboxes.
- Provide clear, concise labels.
- Use `tristate: true` for indeterminate states.
- Group related checkboxes logically.

#### Speaker Notes
- Checkboxes work best for multiple selections or binary options.

---

## 1️⃣ Switch
### Overview
- **Purpose:** Toggle switch for on/off states.
- **Key Properties:** `value`, `onChanged`, `activeColor`, `activeTrackColor`, `thumbColor`.
- **Events:** `onChanged`.
- **Usage Scenarios:** Settings, feature toggles, enable/disable options.

#### Speaker Notes
- Switch provides clear visual feedback for binary state changes.

---

### 2️⃣ Example
```dart
bool _notificationsEnabled = true;

SwitchListTile(
  title: Text('Enable Notifications'),
  subtitle: Text('Receive app notifications'),
  value: _notificationsEnabled,
  onChanged: (bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  },
  activeColor: Colors.green,
  secondary: Icon(Icons.notifications_active),
)
```

---

### 3️⃣ Best Practices
- Use for instant on/off actions.
- Provide immediate feedback and apply changes.
- Use `SwitchListTile` for labeled switches.
- Prefer Switch over Checkbox for binary states.
- **Recommended:** Use Switch for settings and instant toggles.

#### Speaker Notes
- Switch is intuitive for on/off states and provides clear visual feedback.

---

# 🧱 Choice & Selection

## 1️⃣ Radio
### Overview
- **Purpose:** Single selection from multiple options.
- **Key Properties:** `value`, `groupValue`, `onChanged`, `activeColor`.
- **Events:** `onChanged`.
- **Usage Scenarios:** Single choice questions, payment methods, shipping options.

#### Speaker Notes
- Radio buttons enforce mutually exclusive selections.

---

### 2️⃣ Example
```dart
enum ShippingMethod { standard, express, overnight }
ShippingMethod? _selectedMethod = ShippingMethod.standard;

Column(
  children: [
    RadioListTile<ShippingMethod>(
      title: Text('Standard Shipping (5-7 days)'),
      subtitle: Text('Free'),
      value: ShippingMethod.standard,
      groupValue: _selectedMethod,
      onChanged: (ShippingMethod? value) {
        setState(() {
          _selectedMethod = value;
        });
      },
    ),
    RadioListTile<ShippingMethod>(
      title: Text('Express Shipping (2-3 days)'),
      subtitle: Text('\$9.99'),
      value: ShippingMethod.express,
      groupValue: _selectedMethod,
      onChanged: (ShippingMethod? value) {
        setState(() {
          _selectedMethod = value;
        });
      },
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use for 2-5 mutually exclusive options.
- Use `RadioListTile` for labeled options.
- For more options, consider `DropdownButton`.
- Ensure one option is pre-selected for better UX.

#### Speaker Notes
- Radio buttons work best when all options should be visible.

---

## 1️⃣ DropdownButton
### Overview
- **Purpose:** Dropdown menu for selecting from many options.
- **Key Properties:** `value`, `items`, `onChanged`, `hint`, `isExpanded`, `icon`.
- **Events:** `onChanged`.
- **Usage Scenarios:** Country selection, category filters, sorting options.

#### Speaker Notes
- DropdownButton saves space when dealing with many options.

---

### 2️⃣ Example
```dart
String? _selectedCountry = 'USA';

DropdownButtonFormField<String>(
  decoration: InputDecoration(
    labelText: 'Country',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.public),
  ),
  value: _selectedCountry,
  hint: Text('Select a country'),
  isExpanded: true,
  items: ['USA', 'Canada', 'UK', 'Germany', 'France', 'Japan']
      .map((country) => DropdownMenuItem(
            value: country,
            child: Text(country),
          ))
      .toList(),
  onChanged: (String? value) {
    setState(() {
      _selectedCountry = value;
    });
  },
)
```

---

### 3️⃣ Best Practices
- Use for 6+ options to save space.
- Use `DropdownButtonFormField` in forms.
- Set `isExpanded: true` for full-width dropdowns.
- Provide clear hints and labels.
- **Recommended:** Use DropdownButton for 6+ options, Radio for 2-5 options.

#### Speaker Notes
- Dropdown is space-efficient for long lists of options.

---

## 1️⃣ ChoiceChip
### Overview
- **Purpose:** Single selection chip from a set of options.
- **Key Properties:** `label`, `selected`, `onSelected`, `avatar`, `selectedColor`.
- **Events:** `onSelected`.
- **Usage Scenarios:** Filter options, size selection, preferences.

#### Speaker Notes
- ChoiceChip provides visual, compact selection for categories.

---

### 2️⃣ Example
```dart
String _selectedSize = 'M';

Wrap(
  spacing: 8,
  children: ['S', 'M', 'L', 'XL', 'XXL'].map((size) {
    return ChoiceChip(
      label: Text(size),
      selected: _selectedSize == size,
      onSelected: (bool selected) {
        setState(() {
          _selectedSize = size;
        });
      },
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey.shade200,
    );
  }).toList(),
)
```

---

### 3️⃣ Best Practices
- Use for visual, category-based selection.
- Group related chips with `Wrap` or `Row`.
- Provide clear visual distinction for selected state.
- Ideal for 3-7 options displayed horizontally.

#### Speaker Notes
- ChoiceChip offers an attractive, modern selection interface.

---

## 1️⃣ FilterChip
### Overview
- **Purpose:** Multi-selection chips for filtering content.
- **Key Properties:** `label`, `selected`, `onSelected`, `avatar`, `checkmarkColor`.
- **Events:** `onSelected`.
- **Usage Scenarios:** Multi-select filters, tags, categories.

#### Speaker Notes
- FilterChip enables multiple simultaneous selections.

---

### 2️⃣ Example
```dart
Set<String> _selectedFilters = {'Sports'};

Wrap(
  spacing: 8,
  children: ['Sports', 'Music', 'Art', 'Technology', 'Science'].map((filter) {
    return FilterChip(
      label: Text(filter),
      selected: _selectedFilters.contains(filter),
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedFilters.add(filter);
          } else {
            _selectedFilters.remove(filter);
          }
        });
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue,
    );
  }).toList(),
)
```

---

### 3️⃣ Best Practices
- Use for multi-select filtering.
- Show checkmark for selected chips.
- Allow users to clear all selections.
- **Recommended:** Use FilterChip for multi-select, ChoiceChip for single-select.

#### Speaker Notes
- FilterChip is perfect for applying multiple filters simultaneously.

---

# 🧱 Specialized Inputs

## 1️⃣ DatePicker
### Overview
- **Purpose:** Select dates via calendar interface.
- **Key Properties:** `initialDate`, `firstDate`, `lastDate`, `initialDatePickerMode`.
- **Events:** Returns selected date.
- **Usage Scenarios:** Birth date, appointment booking, date ranges.

#### Speaker Notes
- DatePicker provides a standard calendar interface for date selection.

---

### 2️⃣ Example
```dart
DateTime? _selectedDate;

TextButton.icon(
  icon: Icon(Icons.calendar_today),
  label: Text(_selectedDate == null 
      ? 'Select Date' 
      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
  onPressed: () async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select your birth date',
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  },
)
```

---

### 3️⃣ Best Practices
- Set appropriate `firstDate` and `lastDate` ranges.
- Provide clear context with `helpText`.
- Display selected date clearly.
- Use `DateFormat` for localized formatting.

#### Speaker Notes
- DatePicker ensures valid date input and provides excellent UX.

---

## 1️⃣ Slider
### Overview
- **Purpose:** Select a value from a continuous or discrete range.
- **Key Properties:** `value`, `min`, `max`, `divisions`, `label`, `onChanged`.
- **Events:** `onChanged`, `onChangeStart`, `onChangeEnd`.
- **Usage Scenarios:** Volume, brightness, price range, ratings.

#### Speaker Notes
- Slider is intuitive for adjusting continuous values visually.

---

### 2️⃣ Example
```dart
double _volume = 50;

Column(
  children: [
    Text('Volume: ${_volume.round()}%', 
         style: TextStyle(fontSize: 18)),
    Slider(
      value: _volume,
      min: 0,
      max: 100,
      divisions: 20,
      label: '${_volume.round()}%',
      activeColor: Colors.blue,
      inactiveColor: Colors.grey.shade300,
      onChanged: (double value) {
        setState(() {
          _volume = value;
        });
      },
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.volume_mute),
        Icon(Icons.volume_up),
      ],
    ),
  ],
)
```

---

### 3️⃣ Best Practices
- Use `divisions` for discrete values.
- Show current value clearly.
- Provide visual indicators (icons, labels).
- Use `RangeSlider` for selecting ranges.

#### Speaker Notes
- Slider provides intuitive visual feedback for value adjustment.

---

## 1️⃣ Autocomplete
### Overview
- **Purpose:** Text field with auto-suggestions based on input.
- **Key Properties:** `optionsBuilder`, `onSelected`, `displayStringForOption`, `fieldViewBuilder`.
- **Events:** `onSelected`.
- **Usage Scenarios:** Search suggestions, location input, tag selection.

#### Speaker Notes
- Autocomplete enhances UX by suggesting relevant options as users type.

---

### 2️⃣ Example
```dart
final List<String> _cities = ['New York', 'London', 'Paris', 'Tokyo', 'Dubai'];

Autocomplete<String>(
  optionsBuilder: (TextEditingValue textEditingValue) {
    if (textEditingValue.text.isEmpty) {
      return const Iterable<String>.empty();
    }
    return _cities.where((city) {
      return city.toLowerCase().contains(
        textEditingValue.text.toLowerCase(),
      );
    });
  },
  onSelected: (String selection) {
    print('You selected: $selection');
  },
  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'City',
        prefixIcon: Icon(Icons.location_city),
        border: OutlineInputBorder(),
      ),
    );
  },
)
```

---

### 3️⃣ Best Practices
- Filter options efficiently for large datasets.
- Provide clear visual feedback for suggestions.
- Handle empty states gracefully.
- Use for search and location inputs.

#### Speaker Notes
- Autocomplete improves efficiency and reduces input errors.

---

# 📊 Summary & Key Takeaways

---

## Final Summary
- Flutter provides comprehensive input widgets for all data entry needs.
- TextFormField is essential for validated forms.
- Choose selection widgets based on number of options and visual requirements.
- Specialized inputs (DatePicker, Slider, Autocomplete) enhance UX for specific data types.

## Key Takeaway
- Always validate user input appropriately.
- Match input type to data being collected.
- Provide clear labels, hints, and error messages.
- Use the right widget for the right scenario.

## Optimization Principles
- Dispose TextEditingControllers to prevent memory leaks.
- Use `autovalidateMode` for real-time validation.
- Prefer Switch over Checkbox for binary states.
- Use DropdownButton for 6+ options, Radio for 2-5.
- Implement Autocomplete for large option sets.

---

> ![🎯](https://img.icons8.com/color/48/000000/goal.png) **Well-designed input controls make forms intuitive and data collection effortless!**
