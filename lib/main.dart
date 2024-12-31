import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; //
import 'package:provider/provider.dart';
import 'my_flutter_app_icons.dart';

void main() {
  runApp(const MyApp()); //menjalankan the app
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'flutter app annisa',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink, secondary: Colors.purple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier { //class untuk state management atau status aplikasi
  var current = WordPair.random();

  void getNext(){
    current = WordPair.random();
    notifyListeners(); //notifyListeners untuk notify widget lain ada perubahan status
  }
  var favorites = <WordPair>[];
  void toggleFavorite(){
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

//ubah dari stateless widget menjadi stateful widget atau widget yang memiliki state
class MyHomePage extends StatefulWidget {
  @override
  //class ini memperluas state agasr dapat mengelola nilainya sendiri/mengubah nilainya sendiri
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; //ini navigasi widget kiri, inisialiasi 0
  @override
  Widget build(BuildContext context) {
    Widget page;
    //nah dibagian page ini diatur, apakah kiri nya 0 maka kanan nya page GeneratorPage dan laibn lain. 
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        //Placeholder adalah widget yang menampilkan kotak abu-abu yang menunjukkan di mana widget lain akan ditempatkan. pengganti sementara saja.
        page = FavoritesPage(); //yang dipanggil pun class, makanya kalau kita pakai .dart baru juga yang kita pnaggil kan class
        break;
      default: 
        throw UnimplementedError(('no widget for $selectedIndex'));
    }
    //refactori builder layout untuk agar dia responsif kalau pengguna ubah windows aplikasi. gunanya biar bsia diatur lebar dan tingginya
   return LayoutBuilder(
     builder: (context, constraints) {
       return Scaffold(
        body: Row(
          children: [
            SafeArea(child: NavigationRail(
              extended: constraints.maxWidth >= 600, //jika ada ruang lebar lebih dari 600 maka akan ditampikan juga teks label nya atau di extended. Bisa ngecek constraints ini juga dari LayoutBuilder
              destinations: [
                NavigationRailDestination(
                  icon: Icon(MyFlutterApp.home),
                  label: Text('Home'),
                  ),
                NavigationRailDestination(
                  icon: Icon(MyFlutterApp.heart),
                  label: Text('Favorites'),
                  ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() { //mirip notidy listener, memastikan ui selalu di update, tau dia sekarang ada di state yang mana
                  selectedIndex = value;
                }); }
              ),
            ),
            Expanded(child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: page, //page yang diatur diatas sebagai anak dari kiri
            ))
          ],
        )
       );
     }
   );
  }
}


//dipisah jadi 2 kelas yang berbeda, yang di kiri dan kanan
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Text('A random shit idea:'),
            bigCard(pair: pair), 
            //button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: (){
                    appState.getNext(); //memanggil getNext method di class appState.
                  },
                  child: Text('Next'),
                ),

                SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: (){
                    appState.toggleFavorite();
                    }, 
                  icon: appState.favorites.contains(appState.current) 
                      ? Icon(MyFlutterApp.heart)
                      : Icon(MyFlutterApp.heart_empty),
                  label: Text('Favorite'),
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class bigCard extends StatelessWidget {
  const bigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context); //diatur di MyApp
    final style = theme.textTheme.displayMedium!.copyWith( color: theme.colorScheme.onPrimary,
    ); 

    return Card(
      elevation: 2,
      color: theme.colorScheme.primary,
       child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", 
        ),       
       ),    
    ); //
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var words = appState.favorites;

    if (appState.favorites.isEmpty) {
      return Center(child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(padding: const EdgeInsets.all(20),
         child: Text('You have '
                      '${appState.favorites.length} favorites: ' ),
        ), 
          for (var fav in words)
            ListTile(
              leading: Icon(MyFlutterApp.heart),
              title: Text(fav.asLowerCase),
            ),
      ],
    );
  }
}