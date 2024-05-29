import 'package:flutter/material.dart';
import 'package:consuming_json/image_card.dart';

void main() => runApp(GalleryApp());

class GalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My card images'),
        ),
        body: FutureBuilder<List<ImageCard>>(
            future: ApiService.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cards = snapshot.data!;
                return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.network(
                                cards[index].imageUrl,
                                width: 200,
                                height: 200,
                              ),
                              Text(cards[index].title)
                            ],
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro ${snapshot.error}.'));
              } else {
                return const Center(child: Text('Erro desconhecido.'));
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
