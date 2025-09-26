import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
import 'models/article.dart';

void main() {
  runApp(const LiberiaDailyNewsApp());
}

class LiberiaDailyNewsApp extends StatelessWidget {
  const LiberiaDailyNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liberia Daily News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Article> filtered = dummyArticles.where((a) {
      return a.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          a.content.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liberia Daily News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? result = await showSearch(
                context: context,
                delegate: NewsSearchDelegate(dummyArticles),
              );
              if (result != null) {
                setState(() {
                  searchQuery = result;
                });
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (ctx, idx) {
          final article = filtered[idx];
          return Card(
            margin: const EdgeInsets.all(8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(article.imageUrl,
                    fit: BoxFit.cover, width: double.infinity, height: 180),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    article.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    article.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(article.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border),
                      onPressed: () {
                        setState(() {
                          article.isBookmarked = !article.isBookmarked;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(article.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        setState(() {
                          article.isFavorite = !article.isFavorite;
                        });
                      },
                    ),
                    TextButton(
                      child: const Text("Read More"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                ArticleDetailPage(article: article),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final Article article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(article.imageUrl,
                width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(
              article.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              article.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate<String> {
  final List<Article> allArticles;
  NewsSearchDelegate(this.allArticles);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ""));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultList(context);
  }

  Widget _buildResultList(BuildContext context) {
    final results = allArticles.where((a) {
      return a.title.toLowerCase().contains(query.toLowerCase()) ||
          a.content.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, i) {
        final art = results[i];
        return ListTile(
          title: Text(art.title),
          onTap: () {
            close(context, query);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArticleDetailPage(article: art),
              ),
            );
          },
        );
      },
    );
  }
}








