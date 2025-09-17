import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final HabitService _habitService = HabitService();

  final _nameController = TextEditingController();

  String _selectedCategory = 'Health & Fitness';
  String _selectedColor = '#16C9E6';
  String _frequency = 'Daily';

  final List<String> _categories = [
    'Health & Fitness',
    'Mindfulness',
    'Learning',
    'Productivity',
    'Social',
    'Creativity',
    'Finance',
    'Other',
  ];

  final List<String> _colors = [
    '#16C9E6',
    '#008080',
    '#0000FF',
    '#800080',
    '#FFA500',
    '#FF0000',
    '#008000',
    '#FF7F00',
  ];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: '', // Firestore will assign ID
        name: _nameController.text.trim(),
        category: _selectedCategory,
        color: _selectedColor,
        frequency: _frequency,
        currentStreak: 0,
        bestStreak: 0,
        totalDone: 0,
        perWeek: _frequency == 'Daily' ? 7 : 1,
        notes: '',
        completedDates: [],
      );

      await _habitService.addHabit(newHabit);

      // Return to previous page on success
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedCategory = category;
              });
            }
          },
          selectedColor: Colors.lightBlue.shade200,
        );
      }).toList(),
    );
  }

  Widget _buildColorOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _colors.map((color) {
        final isSelected = _selectedColor == color;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedColor = color;
            });
          },
          child: CircleAvatar(
            backgroundColor: Color(_hexToInt(color)),
            radius: isSelected ? 18 : 16,
            child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
          ),
        );
      }).toList(),
    );
  }

  int _hexToInt(String hex) {
    return int.parse(hex.replaceFirst('#', '0xff'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Habit'),
        backgroundColor: const Color(0xFF16C9E6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  hintText: 'e.g., Morning Meditation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter habit name' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _buildCategoryChips(),
              const SizedBox(height: 20),
              const Text(
                'Color',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _buildColorOptions(),
              const SizedBox(height: 20),
              const Text(
                'Frequency',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ToggleButtons(
                isSelected: [_frequency == 'Daily', _frequency == 'Weekly'],
                onPressed: (index) {
                  setState(() {
                    _frequency = index == 0 ? 'Daily' : 'Weekly';
                  });
                },
                borderRadius: BorderRadius.circular(8),
                selectedColor: Colors.white,
                fillColor: const Color(0xFF16C9E6),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Daily'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Weekly'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF16C9E6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create Habit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
