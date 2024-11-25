import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_api.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsService newsService;

  NewsBloc(this.newsService) : super(NewsLoading()) {
    on<FetchNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles = await newsService.fetchNews();
        emit(NewsLoaded(articles));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    });
  }
}
