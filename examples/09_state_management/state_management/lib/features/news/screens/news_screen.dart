import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/news/providers/news_provider.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
        backgroundColor: Colors.teal,
      ),
      body: newsAsync.when(
        loading: () => const _LoadingState(),
        error: (err, _) => _ErrorState(message: err.toString()),
        data: (articles) => _NewsList(articles: articles),
      ),
    );
  }
}

// Loading state widget
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading latest news...'),
        ],
      ),
    );
  }
}

// Error state widget
class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message'),
        ],
      ),
    );
  }
}

// News list with pull-to-refresh
class _NewsList extends ConsumerWidget {
  final List articles;

  const _NewsList({required this.articles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(newsProvider);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          if (index == articles.length) {
            return const _AutoRefreshIndicator();
          }
          return _NewsCard(article: articles[index]);
        },
      ),
    );
  }
}

// Auto-refresh indicator at bottom
class _AutoRefreshIndicator extends StatelessWidget {
  const _AutoRefreshIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh, size: 16, color: Colors.grey),
          SizedBox(width: 8),
          Text(
            'Auto-refreshes every 20 seconds',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// News article card
class _NewsCard extends StatelessWidget {
  final dynamic article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.article, size: 16, color: Colors.teal),
        const SizedBox(width: 4),
        Text(
          article.source,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          _formatTime(article.publishedAt),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      article.title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription() {
    return Text(
      article.description,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatTime(String isoDate) {
    try {
      final diff = DateTime.now().difference(DateTime.parse(isoDate));
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return '';
    }
  }
}
