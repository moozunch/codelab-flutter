import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; //untuk ambil random english words wordpair
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp()); //menjalankan the app
}

class MyApp extends StatelessWidget { //widget is an elemnt where we can put other elements
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

  //mtehod untuk ganti kata
  void getNext(){
    current = WordPair.random();
    notifyListeners(); //notifyListeners untuk notify widget lain ada perubahan status
  }
  //MyAppState menjelaskan data yang diperlukan oleh aplikasi ini agar berjalan dengan baik. Saat ini, kode ini hanya berisi variabel tunggal dengan pasangan kata acak saat ini. Anda akan menambahkannya nanti.
  // Class status memperluas ChangeNotifier, yang artinya kode ini dapat memberi tahu kode lain tentang perubahannya sendiri. Misalnya, jika pasangan kata saat ini berubah, beberapa widget dalam aplikasi perlu mengetahuinya.
  // Status dibuat dan disediakan untuk seluruh aplikasi menggunakan ChangeNotifierProvider (lihat kode di atas pada MyApp). Hal ini memungkinkan widget mana pun pada aplikasi untuk mendapatkan status.
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //ambil status app dan notifikasi perubahan agar selalu uptodate
    var pair = appState.current; //simpan status app ke yang current which is word pair nya.

    return Scaffold(
      body: Center( //body: column wrap with center refactor
        child: Column( //ingat big card ada didalam column, jadi kalau mau buat ditengah tinggal buat aja:
          mainAxisAlignment: MainAxisAlignment.center, //sumbu axis (y)
          children: [
            Text('A random shit idea:'),
            bigCard(pair: pair), //ambil status app class, yang current which is word pair nya. 
            //extreacted widget, was           
            //Text(pair.asLowerCase), //ambil status app class, yang current which is word pair nya.
          SizedBox(height: 20), //ngasih pemisah antara big card dan elevated button
        
        
        
            //button
            ElevatedButton(
              onPressed: (){
                appState.getNext(); //memanggil getNext method di class appState.
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}


//Terakhir, ada MyHomePage, widget yang telah Anda modifikasi. Setiap baris bernomor di bawah memetakan ke komentar nomor baris pada kode di atas:

// Setiap widget menentukan metode build() yang dipanggil secara otomatis setiap kali kondisi widget berubah agar widget selalu dalam kondisi terbaru.
// MyHomePage melacak perubahan terhadap status aplikasi saat ini menggunakan metode watch.
// Setiap metode build harus menampilkan widget atau (yang lebih umum) pohon widget bertingkat. Dalam hal ini, widget tingkat tertinggi adalah Scaffold. Anda tidak akan bekerja dengan Scaffold dalam codelab ini, tetapi ini adalah widget yang berguna dan dapat ditemukan di sebagian besar aplikasi Flutter di dunia nyata.
// Column adalah salah satu widget tata letak paling dasar pada Flutter. Widget tata letak ini mengambil sejumlah turunan dan menempatkannya pada kolom dari atas ke bawah. Secara default, kolom menempatkan turunan-turunannya secara visual di bagian atas. Anda akan segera mengubah ini agar kolom terpusat di tengah.
// Anda mengubah widget Text ini pada langkah pertama.
// Widget Text kedua ini mengambil appState, dan mengakses satu-satunya anggota dari class tersebut, current (yang merupakan WordPair). WordPair menyediakan beberapa pengambil yang berguna, seperti asPascalCase atau asSnakeCase. Di sini, kita menggunakan asLowerCase, tetapi Anda dapat mengubah ini sekarang jika Anda lebih menyukai salah satu alternatif yang ada.
// Perhatikan bagaimana kode Flutter banyak menggunakan koma di akhir. Koma ini tidak harus ada, karena children adalah anggota terakhir (dan juga satu-satunya) dari daftar parameter Column ini. Namun, menggunakan koma di akhir umumnya adalah ide yang bagus: koma di akhir membuat penambahan anggota menjadi mudah, dan koma di akhir juga berfungsi sebagai petunjuk bagi pemformat otomatis Dart untuk meletakkan baris baru. Untuk informasi lebih lanjut, lihat panduan Pemformatan kode.

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
    ); //tipe font displayMedium, copyWith untuk mengganti warna font

    return Card( //wrap with widget reafctor dan ganti jadi card
      elevation: 2,
      color: theme.colorScheme.primary,
       child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", //gunanya dipisah agar aksebilitas pembaca layar untuk pengguna buta bisa mengerti makna bukan terbuat kata baru
        ),       
      //   seperti diatas instead of   
      //   child: Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: Text(pair.asLowerCase, style: style), ),
       ),    
    ); //Padding dengan refactor dan wrap dengan padding
    //Catatan: Flutter menggunakan Komposisi, bukan Pewarisan, kapan pun tersedia. Di sini, padding tidak menjadi atribut dari Text, melainkan sebuah widget! (seperti container)
    //Sehingga hasil akhir kode: Kode ini menggabungkan widget Padding, dan juga Text, dengan widget Card.
  }

  //tentang style
  //Dengan menggunakan theme.textTheme,, Anda mengakses tema font aplikasi. Class ini mencakup anggota seperti bodyMedium (untuk teks standar ukuran medium), caption (untuk teks dari gambar), atau headlineLarge (untuk judul berukuran besar).
  // Properti displayMedium adalah gaya font besar yang dimaksudkan untuk teks tampilan. Kata tampilan digunakan dalam artian tipografi di sini, seperti pada jenis huruf tampilan. Dokumentasi untuk displayMedium menyatakan bahwa, "gaya tampilan ditujukan untuk teks yang penting dan singkat"—tepat dengan kasus penggunaan kita.
  // Properti displayMedium tema secara teori dapat berupa null. Dart, bahasa pemrograman yang Anda gunakan untuk menulis aplikasi ini, aman dari null, sehingga bahasa pemrograman ini tidak akan mengizinkan Anda memanggil metode objek yang berpotensi null. Namun, dalam hal ini, Anda dapat menggunakan operator ! ("bang operator") untuk meyakinkan Dart bahwa Anda memahami tindakan Anda. (displayMedium pasti tidak null dalam kasus ini. Namun, alasan kami mengetahui hal ini berada di luar cakupan codelab ini.)
  // Memanggil copyWith() pada displayMedium menampilkan salinan gaya teks dengan perubahan yang Anda tentukan. Dalam hal ini, Anda hanya mengubah warna teks.
  // Untuk mendapatkan warna baru, Anda mengakses tema aplikasi sekali lagi. Properti onPrimary skema warna menentukan warna yang cocok digunakan untuk warna primer aplikasi.

  //explore ini copyWith untuk atur style
  //copyWith() memungkinkan Anda mengubah lebih banyak tentang gaya teks daripada hanya warna. Untuk mendapatkan daftar lengkap properti yang dapat Anda ubah, letakkan kursor di dalam tanda kurung copyWith(), lalu tekan Ctrl+Shift+Space (Win/Linux) atau Cmd+Shift+Space (Mac).

  //also explore with:
  //dapat juga mengubah lebih banyak tentang widget Card. Misalnya, memperbesar bayangan kartu dengan meningkatkan nilai parameter elevation.
  // Coba bereksperimen dengan warna. Selain theme.colorScheme.primary, ada juga .secondary, .surface, dan berbagai pilihan lainnya. Semua warna ini memiliki onPrimary padanannya masing-masing.
}