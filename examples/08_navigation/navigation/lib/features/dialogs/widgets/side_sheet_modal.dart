import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modal Side Sheet - Blocks background interaction with scrim overlay (semi-transparent black)
/// Use for: Forms, detailed editing, multi-step workflows
/// M3 Reference: https://m3.material.io/components/side-sheets
class ModalSideSheet extends StatefulWidget {
  const ModalSideSheet({super.key});

  @override
  State<ModalSideSheet> createState() => _ModalSideSheetState();
}

class _ModalSideSheetState extends State<ModalSideSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _priority = 'Medium';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  final List<String> _selectedTags = [];

  final _priorities = ['Low', 'Medium', 'High', 'Urgent'];
  final _availableTags = [
    'Work',
    'Personal',
    'Important',
    'Follow-up',
    'Review'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 360, // M3 standard modal side sheet width
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(-2, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleField(),
                      const SizedBox(height: 16),
                      _buildDescriptionField(),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Priority'),
                      const SizedBox(height: 8),
                      _buildPrioritySelector(),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Due Date'),
                      const SizedBox(height: 8),
                      _buildDueDatePicker(context),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Tags'),
                      const SizedBox(height: 8),
                      _buildTagsSelector(),
                      const SizedBox(height: 16),
                      _buildInfoCard(),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// Header with navigation and close affordances
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Back',
          ),
          const SizedBox(width: 8),
          Text(
            'Create Task',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }

  /// Title input with validation
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Task Title',
        hintText: 'Enter task title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a task title';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  /// Multi-line description field
  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter task description',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  /// SegmentedButton for single-select priority
  Widget _buildPrioritySelector() {
    return SegmentedButton<String>(
      segments: _priorities.map((priority) {
        return ButtonSegment<String>(
          value: priority,
          label: Text(priority),
        );
      }).toList(),
      selected: {_priority},
      onSelectionChanged: (Set<String> selected) {
        setState(() {
          _priority = selected.first;
        });
      },
      showSelectedIcon: false,
    );
  }

  /// Date picker with formatted display
  Widget _buildDueDatePicker(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: Text(
        '${_dueDate.month}/${_dueDate.day}/${_dueDate.year}',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _selectDate(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  /// Show date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  /// FilterChips for multi-select tags
  Widget _buildTagsSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableTags.map((tag) {
        final isSelected = _selectedTags.contains(tag);
        return FilterChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTags.add(tag);
              } else {
                _selectedTags.remove(tag);
              }
            });
          },
        );
      }).toList(),
    );
  }

  /// Info card with helpful message
  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Tasks to stay organized and track the progress',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Action buttons with primary/secondary styling
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.pop('Cancel'),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () => _handleSave(context),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  /// Validate form and save task
  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.pop('Task "${_titleController.text}" created successfully');
    }
  }
}
