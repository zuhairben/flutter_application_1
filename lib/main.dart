import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'news_api.dart'; // Add your news API file here
import 'news_bloc.dart'; // Add your NewsBloc file here
import 'news_event.dart'; // Add your NewsEvent file here
import 'news_state.dart'; // Add your NewsState file here

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NewsBloc(NewsService())..add(FetchNews()),
        child: const NewsScreen(),
      ),
    );
  }
}

String formatDate(String? dateString) {
  if (dateString == null) return 'Unknown Date';
  try {
    final dateTime = DateTime.parse(dateString);
    return DateFormat('MMM d, yyyy, h:mm a').format(dateTime);
  } catch (e) {
    return 'Invalid Date';
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.white, // Changed to white (default neutral color)
        elevation: 1, // Slight shadow for separation
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Headline News",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Black text for readability
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Read Top News Today",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey, // Subtle gray for subtitle
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(
              'assets/newspaper.png', // Ensure this asset is in your project
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black), // Black icon color
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    title: Container(height: 20, color: Colors.white),
                    subtitle: Container(height: 15, color: Colors.white),
                  ),
                );
              },
            );
          } else if (state is NewsLoaded) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                String publishedAt = formatDate(article['publishedAt']);

                return Card(
                  key: ValueKey(index),
                  margin: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => NewsDetail(article: article),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  article['urlToImage'] ?? '',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      article['author'] ?? 'Unknown Author',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      article['description'] != null &&
                                              article['description']!.length >
                                                  50
                                          ? '${article['description']!.substring(0, 50)}...'
                                          : article['description'] ??
                                              'No Description',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              publishedAt,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is NewsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class NewsDetail extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetail({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article['urlToImage'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      article['urlToImage']!,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : const Icon(Icons.broken_image, size: 100),
            const SizedBox(height: 10),
            Text(
              article['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              article['author'] ?? 'Unknown Author',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(article['content'] ?? 'No Content'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
