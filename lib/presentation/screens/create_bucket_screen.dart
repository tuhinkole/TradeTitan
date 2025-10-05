import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradetitan/domain/bucket.dart';
import 'package:tradetitan/services/firestore_service.dart';

class CreateBucketScreen extends StatefulWidget {
  const CreateBucketScreen({super.key});

  @override
  State<CreateBucketScreen> createState() => _CreateBucketScreenState();
}

class _CreateBucketScreenState extends State<CreateBucketScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  // Text Controllers
  final _nameController = TextEditingController();
  final _strategyController = TextEditingController();
  final _managerController = TextEditingController();
  final _rationaleController = TextEditingController();
  final _minInvestmentController = TextEditingController();

  // State variables
  String _rebalanceFrequency = 'Annual';
  DateTime? _lastRebalance;
  DateTime? _nextRebalance;
  double _volatility = 0.5;

  // Dynamic fields for stocks and holdings
  final List<Map<String, dynamic>> _stockFields = [];
  final List<Map<String, dynamic>> _holdingFields = [];

  @override
  void dispose() {
    _nameController.dispose();
    _strategyController.dispose();
    _managerController.dispose();
    _rationaleController.dispose();
    _minInvestmentController.dispose();
    for (var field in _stockFields) {
      (field['symbol'] as TextEditingController).dispose();
      (field['weight'] as TextEditingController).dispose();
    }
    for (var field in _holdingFields) {
      (field['category'] as TextEditingController).dispose();
      (field['percentage'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  Future<void> _saveBucket() async {
    if (_formKey.currentState!.validate()) {
      // Validate all dynamic stock forms
      bool allStocksValid = _stockFields.every(
        (field) =>
            (field['formKey'] as GlobalKey<FormState>).currentState!.validate(),
      );

      // Validate all dynamic holding forms
      bool allHoldingsValid = _holdingFields.every(
        (field) =>
            (field['formKey'] as GlobalKey<FormState>).currentState!.validate(),
      );

      if (allStocksValid && allHoldingsValid) {
        final allocation = <String, double>{};
        for (var field in _stockFields) {
          final symbol = (field['symbol'] as TextEditingController).text;
          final weight = double.parse(
            (field['weight'] as TextEditingController).text,
          );
          allocation[symbol] = weight / 100;
        }

        final holdingsDistribution = <String, double>{};
        for (var field in _holdingFields) {
          final category = (field['category'] as TextEditingController).text;
          final percentage = double.parse(
            (field['percentage'] as TextEditingController).text,
          );
          holdingsDistribution[category] = percentage / 100;
        }

        final newBucket = Bucket(
          name: _nameController.text,
          strategy: _strategyController.text,
          manager: _managerController.text,
          rationale: _rationaleController.text,
          minInvestment: double.parse(_minInvestmentController.text),
          volatility: _volatility,
          stockCount: _stockFields.length,
          rebalanceFrequency: _rebalanceFrequency,
          lastRebalance: _lastRebalance ?? DateTime.now(),
          nextRebalance:
              _nextRebalance ?? DateTime.now().add(const Duration(days: 365)),
          allocation: allocation,
          holdingsDistribution: holdingsDistribution,
          returns: {}, // Typically calculated, not set on creation
        );

        await _firestoreService.addBucket(newBucket);
        if (!mounted) return;
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Bucket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.grey[850]!, Colors.grey[900]!]
                  : [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Bucket Information'),
              _buildTextField(
                controller: _nameController,
                label: 'Bucket Name',
                icon: Icons.account_balance_wallet,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _strategyController,
                label: 'Strategy',
                icon: Icons.lightbulb_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _managerController,
                label: 'Manager',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _rationaleController,
                label: 'Rationale',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _minInvestmentController,
                label: 'Minimum Investment',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Configuration'),
              _buildDropdown(),
              const SizedBox(height: 16),
              _buildDatePicker(
                label: 'Last Rebalance Date',
                selectedDate: _lastRebalance,
                onDateSelected: (date) => setState(() => _lastRebalance = date),
              ),
              const SizedBox(height: 16),
              _buildDatePicker(
                label: 'Next Rebalance Date',
                selectedDate: _nextRebalance,
                onDateSelected: (date) => setState(() => _nextRebalance = date),
              ),
              const SizedBox(height: 16),
              _buildVolatilitySlider(),
              const SizedBox(height: 24),
              _buildSectionTitle('Stocks & Allocation'),
              ..._buildStockRows(),
              _buildAddButton('Add Stock', _addStockRow),
              const SizedBox(height: 24),
              _buildSectionTitle('Holdings Distribution'),
              ..._buildHoldingRows(),
              _buildAddButton('Add Holding', _addHoldingRow),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveBucket,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Bucket',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILDER WIDGETS

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: '$label *',
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(178),
        ),
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(128),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown() {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      initialValue: _rebalanceFrequency,
      decoration: InputDecoration(
        labelText: 'Rebalance Frequency *',
        labelStyle: TextStyle(
          color: theme.colorScheme.onSurface.withAlpha(178),
        ),
        prefixIcon: Icon(Icons.sync, color: theme.colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
      ),
      items: ['Annual', 'Quarterly', 'Monthly'].map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: (value) => setState(() => _rebalanceFrequency = value!),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(178),
          ),
          prefixIcon: Icon(
            Icons.calendar_today,
            color: theme.colorScheme.primary,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
        ),
        child: Text(
          selectedDate != null
              ? DateFormat.yMMMd().format(selectedDate)
              : 'Not set',
          style: theme.textTheme.titleMedium,
        ),
      ),
    );
  }

  Widget _buildVolatilitySlider() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Volatility: ${_volatility.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(178),
            ),
          ),
          Slider(
            value: _volatility,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            label: _volatility.toStringAsFixed(2),
            onChanged: (value) => setState(() => _volatility = value),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStockRows() {
    return List.generate(_stockFields.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Form(
          key: _stockFields[index]['formKey'] as GlobalKey<FormState>,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDynamicTextField(
                  controller: _stockFields[index]['symbol'],
                  label: 'Symbol',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDynamicTextField(
                  controller: _stockFields[index]['weight'],
                  label: 'Weight (%)',
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                onPressed: () => _removeStockRow(index),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildHoldingRows() {
    return List.generate(_holdingFields.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Form(
          key: _holdingFields[index]['formKey'] as GlobalKey<FormState>,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDynamicTextField(
                  controller: _holdingFields[index]['category'],
                  label: 'Category',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDynamicTextField(
                  controller: _holdingFields[index]['percentage'],
                  label: 'Percentage (%)',
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                onPressed: () => _removeHoldingRow(index),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDynamicTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: '$label *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter $label';
        }
        if (keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          return 'Invalid number';
        }
        return null;
      },
    );
  }

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add_circle_outline),
      label: Text(label),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // DYNAMIC FIELD LOGIC

  void _addStockRow() {
    setState(() {
      _stockFields.add({
        'formKey': GlobalKey<FormState>(),
        'symbol': TextEditingController(),
        'weight': TextEditingController(),
      });
    });
  }

  void _removeStockRow(int index) {
    // Dispose controllers before removing
    (_stockFields[index]['symbol'] as TextEditingController).dispose();
    (_stockFields[index]['weight'] as TextEditingController).dispose();
    setState(() {
      _stockFields.removeAt(index);
    });
  }

  void _addHoldingRow() {
    setState(() {
      _holdingFields.add({
        'formKey': GlobalKey<FormState>(),
        'category': TextEditingController(),
        'percentage': TextEditingController(),
      });
    });
  }

  void _removeHoldingRow(int index) {
    // Dispose controllers before removing
    (_holdingFields[index]['category'] as TextEditingController).dispose();
    (_holdingFields[index]['percentage'] as TextEditingController).dispose();
    setState(() {
      _holdingFields.removeAt(index);
    });
  }
}
