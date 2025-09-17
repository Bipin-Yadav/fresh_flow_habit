import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';

class EditHabitPage extends StatefulWidget {
  final Habit habit;

  const EditHabitPage({required this.habit, super.key});

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final HabitService _habitService = HabitService();

  late TextEditingController _nameController;
  late String _selectedCategory;
  late String _frequency;
  late String _selectedColor;
  late TextEditingController _notesController;

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

  @override
  void initState() {
    super.initState();
    final habit = widget.habit;
    _nameController = TextEditingController(text: habit.name);
    _selectedCategory = habit.category;
    _frequency = habit.frequency;
    _selectedColor = habit.color;
    _notesController = TextEditingController(text: habit.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedHabit = Habit(
        id: widget.habit.id,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        color: _selectedColor,
        frequency: _frequency,
        currentStreak: widget.habit.currentStreak,
        bestStreak: widget.habit.bestStreak,
        totalDone: widget.habit.totalDone,
        perWeek: _frequency == 'Daily' ? 7 : 1,
        notes: _notesController.text.trim(),
        completedDates: widget.habit.completedDates,
      );

      await _habitService.updateHabit(updatedHabit);

      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _deleteHabit() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Habit?'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _habitService.deleteHabit(widget.habit.id);
      if (mounted) Navigator.popUntil(context, ModalRoute.withName('/habits'));
    }
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(labelText: 'Category'),
      items: _categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
    );
  }

  Widget _buildFrequencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _frequency,
      decoration: const InputDecoration(labelText: 'Frequency'),
      items: ['Daily', 'Weekly']
          .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _frequency = value;
          });
        }
      },
    );
  }

  Widget _buildColorOptions() {
    return Wrap(
      spacing: 10,
      children: _colors.map((color) {
        final isSelected = _selectedColor == color;
        return ChoiceChip(
          label: Text(
            colorName(color),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedColor = color;
              });
            }
          },
          selectedColor: Colors.lightBlue,
          backgroundColor: Colors.grey.shade200,
        );
      }).toList(),
    );
  }

  // Example of mapping color hex to a name, customize as needed
  String colorName(String hex) {
    switch (hex.toUpperCase()) {
      case '#16C9E6':
        return 'Primary';
      case '#008080':
        return 'Success';
      case '#0000FF':
        return 'Warning';
      case '#800080':
        return 'Info';
      case '#FFA500':
        return 'Purple';
      case '#FF0000':
        return 'Pink';
      default:
        return 'Color';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
        backgroundColor: const Color(0xFF16C9E6),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Habit Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter habit name' : null,
              ),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildFrequencyDropdown(),
              const SizedBox(height: 16),
              const Text('Color Theme', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildColorOptions(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16C9E6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _deleteHabit,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Delete Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
