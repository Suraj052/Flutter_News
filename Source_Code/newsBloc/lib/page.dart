import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/news_bloc.dart';
import 'package:untitled/news_model.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  final newsBloc = NewsBloc();

  @override
  void initState()
  {
    newsBloc.eventsink.add(NewsAction.Fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
        ),
        title: Center(child: Text("News Nation",style: TextStyle(color: Colors.blueAccent))),
        backgroundColor: Colors.white,
      ),
      body: Container(
          child:StreamBuilder<List<Article>>(
              stream : newsBloc.newsStream,
              builder: (context,snapshot)
              {

                if(snapshot.hasError)
                  {
                    return Center(child: Text("Error"));
                  }
                if(snapshot.hasData)
                {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context,index)
                      {
                        var article = snapshot.data![index];
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 10,
                            shadowColor: Colors.blueAccent,
                            child: Container(
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children:<Widget>[
                                      Card(
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                              article.urlToImage,
                                              fit: BoxFit.cover,
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //Text(formattedTime),
                                            Text(
                                              article.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              article.description,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        );
                      }
                  );
                }
                else
                {
                  return Center (child: CircularProgressIndicator());
                }
              }
          )
      ),
    );
  }

}
