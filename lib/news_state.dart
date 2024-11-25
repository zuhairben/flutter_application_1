abstract class NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<dynamic> articles;
  NewsLoaded(this.articles);
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
