import 'package:flutter/material.dart';
import 'package:kalimati/core/entities/resource.dart';
import 'package:kalimati/core/entities/enum/resource_type.dart';

class AttachMediaPage extends StatefulWidget {
  const AttachMediaPage({
    super.key,
    required this.sentenceText,
    required this.initialResources,
  });

  final String sentenceText;
  final List<Resource> initialResources;

  @override
  State<AttachMediaPage> createState() => _AttachMediaPageState();
}

class _AttachMediaPageState extends State<AttachMediaPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  ResourceType _selectedType = ResourceType.photo;
  late List<Resource> _resources;

  @override
  void initState() {
    super.initState();
    _resources = widget.initialResources
        .map(
          (r) => Resource(
            extension: r.extension,
            resourceUrl: r.resourceUrl,
            title: r.title,
            type: r.type,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attach Media'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_resources),
            child: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '"${widget.sentenceText}"',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildMediaList()),
              const SizedBox(height: 24),
              _buildAddMediaForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaList() {
    if (_resources.isEmpty) {
      return const Text(
        'No media attached yet.',
        style: TextStyle(color: Colors.black54),
      );
    }

    return ListView.separated(
      itemCount: _resources.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final resource = _resources[index];
        return ListTile(
          tileColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(_iconForType(resource.type)),
          title: Text(
            resource.title.isEmpty ? resource.resourceUrl : resource.title,
          ),
          subtitle: Text(resource.resourceUrl),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _handleRemoveResource(index),
          ),
        );
      },
    );
  }

  Widget _buildAddMediaForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attach new media',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<ResourceType>(
          initialValue: _selectedType,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedType = value);
          },
          items: const [
            DropdownMenuItem(
              value: ResourceType.photo,
              child: Text('Photo URL'),
            ),
            DropdownMenuItem(
              value: ResourceType.video,
              child: Text('Video URL'),
            ),
            DropdownMenuItem(
              value: ResourceType.website,
              child: Text('Website URL'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            labelText: 'URL',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _handleAddMedia,
            icon: const Icon(Icons.add),
            label: const Text('Attach'),
          ),
        ),
      ],
    );
  }

  void _handleAddMedia() {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a URL before attaching.')),
      );
      return;
    }

    setState(() {
      _resources.add(
        Resource(
          extension: _extractExtension(url),
          resourceUrl: url,
          title: _titleController.text.trim(),
          type: _selectedType,
        ),
      );
      _urlController.clear();
      _titleController.clear();
    });
  }

  String _extractExtension(String url) {
    final dotIndex = url.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == url.length - 1) {
      return '';
    }
    return url.substring(dotIndex + 1);
  }

  IconData _iconForType(ResourceType type) {
    switch (type) {
      case ResourceType.photo:
        return Icons.photo_outlined;
      case ResourceType.video:
        return Icons.videocam_outlined;
      case ResourceType.website:
        return Icons.language;
      default:
        return Icons.attach_file;
    }
  }

  Future<void> _handleRemoveResource(int index) async {
    final resource = _resources[index];
    final label = resource.title.isNotEmpty
        ? resource.title
        : resource.resourceUrl;
    final confirmed = await _showDeleteConfirmation(
      'Delete Attachment',
      'Remove "$label" from this sentence? This cannot be undone.',
    );
    if (confirmed != true) return;
    setState(() => _resources.removeAt(index));
  }

  Future<bool?> _showDeleteConfirmation(String title, String message) {
    const brandGreen = Color(0xFF2E7D32);
    const brandBg = Color.fromARGB(255, 243, 255, 243);
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: brandBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: brandGreen,
          ),
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: brandGreen),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
