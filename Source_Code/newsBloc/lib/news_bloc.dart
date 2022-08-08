import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/news_model.dart';


enum NewsAction { Fetch }

class NewsBloc{

  final _stateStreamController = StreamController<List<Article>>();
  StreamSink<List<Article>> get _newsSink => _stateStreamController.sink;
  Stream<List<Article>> get newsStream => _stateStreamController.stream;


  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventsink => _eventStreamController.sink;
  Stream<NewsAction> get _eventStream => _eventStreamController.stream;


  NewsBloc()
  {
    _eventStream.listen((event) async {
      if(event == NewsAction.Fetch)
      {
        try {
          var news = await getNews();

          if(news != null)
            {
              _newsSink.add(news.articles);
            }
          else{
            _newsSink.addError('Something went wrong');
          }
        } on Exception catch (e)
        {
          _newsSink.addError('Something went wrong');
        }
      }

  }

  );

  }

    Future<NewsModel> getNews() async
    {
      var client = http.Client();
      var newsModel;

      var url = Uri.parse("https://newsapi.org/v2/everything?domains=wsj.com&apiKey=a92eb379f5fd4c0e87be9895192278ce");

      try
      {
        var response = await client.get(url);
        if(response.statusCode == 200)
        {
          var jsonString = response.body;
          var jsonMap = json.decode(jsonString);

          newsModel = NewsModel.fromJson(jsonMap);
        }
      }
      on Exception
      {
        return newsModel;
      }
      return newsModel;
    }


}