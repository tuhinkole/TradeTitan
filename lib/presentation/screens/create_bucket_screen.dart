import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradetitan/domain/bucket.dart';

class CreateBucketScreen extends StatefulWidget {
  const CreateBucketScreen({super.key});

  @override
  State<CreateBucketScreen> createState() => _CreateBucketScreenState();
}

class _CreateBucketScreenState extends State<CreateBucketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _strategyController = TextEditingController();
  final _managerController = TextEditingController();
  final _rationaleController = TextEditingController();
  final _stockCountController = TextEditingController();

  String _rebalanceFrequency = 'Annual';
  DateTime _lastRebalance = DateTime.now();
  DateTime _nextRebalance = DateTime.now().add(const Duration(days: 365));

  double _volatility = 0.5;
  double _minInvestment = 1000;

  final List<Map<String, dynamic>> _stockFields = [];
  final List<Map<String, dynamic>> _holdingFields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Bucket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Bucket Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              _buildTextField(
                controller: _strategyController,
                label: 'Strategy',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a strategy' : null,
              ),
              _buildTextField(
                controller: _managerController,
                label: 'Manager',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a manager' : null,
              ),
              _buildTextField(
                controller: _rationaleController,
                label: 'Rationale',
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a rationale' : null,
              ),
              _buildTextField(
                controller: _stockCountController,
                label: 'Stock Count',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a stock count' : null,
              ),
              _buildDropdown(
                value: _rebalanceFrequency,
                items: ['Annual', 'Quarterly', 'Monthly'],
                onChanged: (value) =>
                    setState(() => _rebalanceFrequency = value!),
                label: 'Rebalance Frequency',
              ),
              _buildDatePicker(
                context: context,
                label: 'Last Rebalance',
                selectedDate: _lastRebalance,
                onDateSelected: (date) => setState(() => _lastRebalance = date),
              ),
              _buildDatePicker(
                context: context,
                label: 'Next Rebalance',
                selectedDate: _nextRebalance,
                onDateSelected: (date) => setState(() => _nextRebalance = date),
              ),
              _buildVolatilitySlider(),
              _buildInvestmentSlider(),
              _buildStockAllocation(),
              _buildHoldingsDistribution(),
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String label,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime selectedDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            TextButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  onDateSelected(date);
                }
              },
              child: Text(DateFormat.yMMMd().format(selectedDate)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolatilitySlider() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volatility: ${_volatility.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
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
      ),
    );
  }

  Widget _buildInvestmentSlider() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Minimum Investment: \$${_minInvestment.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _minInvestment,
              min: 100,
              max: 10000,
              divisions: 99,
              label: _minInvestment.toStringAsFixed(0),
              onChanged: (value) => setState(() => _minInvestment = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockAllocation() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stocks & Allocation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stockFields.length,
              itemBuilder: (context, index) {
                return _buildStockRow(index);
              },
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _addStockRow,
              icon: const Icon(Icons.add),
              label: const Text('Add Stock'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockRow(int index) {
    return Form(
      key: _stockFields[index]['formKey'] as GlobalKey<FormState>,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller:
                  _stockFields[index]['symbol'] as TextEditingController,
              decoration: const InputDecoration(labelText: 'Symbol'),
              validator: (value) => value!.isEmpty ? 'Enter symbol' : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller:
                  _stockFields[index]['weight'] as TextEditingController,
              decoration: const InputDecoration(labelText: 'Weight (%)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Enter weight' : null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _removeStockRow(index),
          ),
        ],
      ),
    );
  }

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
    setState(() {
      _stockFields.removeAt(index);
    });
  }

  Widget _buildHoldingsDistribution() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Holdings Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _holdingFields.length,
              itemBuilder: (context, index) {
                return _buildHoldingRow(index);
              },
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _addHoldingRow,
              icon: const Icon(Icons.add),
              label: const Text('Add Holding'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingRow(int index) {
    return Form(
      key: _holdingFields[index]['formKey'] as GlobalKey<FormState>,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller:
                  _holdingFields[index]['category'] as TextEditingController,
              decoration: const InputDecoration(labelText: 'Category'),
              validator: (value) => value!.isEmpty ? 'Enter category' : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller:
                  _holdingFields[index]['percentage'] as TextEditingController,
              decoration: const InputDecoration(labelText: 'Percentage (%)'),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Enter percentage' : null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => _removeHoldingRow(index),
          ),
        ],
      ),
    );
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
    setState(() {
      _holdingFields.removeAt(index);
    });
  }

  void _saveBucket() {
    if (_formKey.currentState!.validate()) {
      bool allStocksValid = true;
      final allocation = <String, double>{};

      for (var stockField in _stockFields) {
        final formState =
            (stockField['formKey'] as GlobalKey<FormState>).currentState;
        if (formState == null || !formState.validate()) {
          allStocksValid = false;
          break;
        }

        final symbol = (stockField['symbol'] as TextEditingController).text;
        final weight = double.tryParse(
          (stockField['weight'] as TextEditingController).text,
        );

        if (symbol.isNotEmpty && weight != null) {
          allocation[symbol] = weight / 100;
        } else {
          allStocksValid = false;
          break;
        }
      }

      bool allHoldingsValid = true;
      final holdingsDistribution = <String, double>{};

      for (var holdingField in _holdingFields) {
        final formState =
            (holdingField['formKey'] as GlobalKey<FormState>).currentState;
        if (formState == null || !formState.validate()) {
          allHoldingsValid = false;
          break;
        }

        final category =
            (holdingField['category'] as TextEditingController).text;
        final percentage = double.tryParse(
          (holdingField['percentage'] as TextEditingController).text,
        );

        if (category.isNotEmpty && percentage != null) {
          holdingsDistribution[category] = percentage / 100;
        } else {
          allHoldingsValid = false;
          break;
        }
      }

      if (allStocksValid && allHoldingsValid) {
        final newBucket = Bucket(
          name: _nameController.text,
          strategy: _strategyController.text,
          manager: _managerController.text,
          rationale: _rationaleController.text,
          volatility: _volatility,
          minInvestment: _minInvestment,
          allocation: allocation,
          returns: {},
          stockCount: int.parse(_stockCountController.text),
          rebalanceFrequency: _rebalanceFrequency,
          lastRebalance: _lastRebalance,
          nextRebalance: _nextRebalance,
          holdingsDistribution: holdingsDistribution,
        );
        Navigator.pop(context, newBucket);
      }
    }
  }
}
