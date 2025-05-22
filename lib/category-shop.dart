import 'package:flutter/material.dart';

class Song {
  final int id;
  final String title;
  final String artist;
  final String coverPath;
  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverPath,
  });
}
const TextStyle _titleStyle=TextStyle(
  color: Color(0xFFDADADA),
  fontSize:12,
  fontWeight:FontWeight.w900,
  fontFamily:'Opensans',
);
const TextStyle _artistStyle=TextStyle(
  color:Color(0xFF9E9E9E),
  fontSize:10,
  fontWeight:FontWeight.w400,
  fontFamily:'Opensans',
);

class ShopCard extends StatelessWidget{
  final Song song;
  final Function(Song)onAddToCart;
  const ShopCard({
    super.key,
    required this.song,
    required this.onAddToCart,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:150.0,
      height:230,
      margin:const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration:BoxDecoration(
        color:const Color(0xFF1A1A1A),
        borderRadius:BorderRadius.circular(20),
        boxShadow:[
          BoxShadow(
              color:Colors.black.withOpacity(0.5),
              spreadRadius:1,
              blurRadius:8,
              offset:const Offset(0, 5) ),],),
      child:Column(
        children:[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft:Radius.circular(20),
              topRight:Radius.circular(20),),
            child: Image.asset(
              song.coverPath,
              height:170,
              width:150,
              fit: BoxFit.cover,
              errorBuilder:(context, error, stackTrace) => Container(
                height:130,
                width:150,
                color:Colors.grey[800],
                alignment:Alignment.center,
                child:const Icon(Icons.music_note, color: Colors.white54, size: 40),),),),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Expanded(
                    child:Padding(
                      padding:const EdgeInsets.only(left: 10.0),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text(song.title, style: _titleStyle, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(song.artist, style: _artistStyle, overflow: TextOverflow.ellipsis),],),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onAddToCart(song),
                    child: Container(
                      width:24,
                      height:24,
                      decoration:const BoxDecoration(
                        color:Color(0xFF1DB954),
                        shape:BoxShape.circle,),
                      child: const Icon(Icons.add, color: Color(0xFF1A1A1A), size: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MusicShopPage extends StatefulWidget {
  final String title;
  final List<Song> songs;
  const MusicShopPage({
    super.key,
    required this.title,
    required this.songs,});

  @override
  State<MusicShopPage> createState() => _MusicShopPageState();}

class _MusicShopPageState extends State<MusicShopPage>{
  final List<Song> cartItems=[];
  void addToCart(Song song){
    if (!cartItems.any((item)=>item.id==song.id)) {
      setState(()=>cartItems.add(song));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${song.title} added to cart'),
          duration: const Duration(seconds: 1),),);
    } else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text('${song.title} is already in the cart'),
          duration:const Duration(seconds: 1),),);
    }
  }
  void goToCheckoutPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_)=> CheckoutPage(
          cartItems: List.from(cartItems),
          onCartUpdated: (updatedList) {
            setState(() {cartItems.clear();
            cartItems.addAll(updatedList);
            });
          },
        ),
      ),
    );
  }
  void _goBackToCategories() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CategoriesPage(),),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xFF121212),
      appBar:AppBar(
        backgroundColor:const Color(0xFF1A1A1A),
        title:Text(widget.title),
        leading:IconButton(
          icon:const Icon(Icons.arrow_back),
          onPressed:_goBackToCategories,),
        actions:[
          IconButton(
            icon:const Icon(Icons.account_circle),
            onPressed:(){},),
          Stack(
            alignment:Alignment.center,
            children:[
              IconButton(
                icon:const Icon(Icons.shopping_cart),
                onPressed: goToCheckoutPage,
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  top:5,
                  right:5,
                  child:Container(
                    padding:const EdgeInsets.all(2),
                    decoration:const BoxDecoration(
                      color:Color(0xFF1DB954),
                      shape:BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child:Text(
                      '${cartItems.length}',
                      style:const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign:TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:2,
          childAspectRatio: 0.65,
          crossAxisSpacing:10,
          mainAxisSpacing: 10,),
        itemCount:widget.songs.length,
        itemBuilder:(context, index) => ShopCard(
          song:widget.songs[index],
          onAddToCart:addToCart,
        ),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final List<Song>cartItems;
  final Function(List<Song>)onCartUpdated;
  const CheckoutPage({super.key,
    required this.cartItems,
    required this.onCartUpdated,});

  @override
  State<CheckoutPage>createState()=>_CheckoutPageState();}

class _CheckoutPageState extends State<CheckoutPage>{
  late List<Song>_currentCartItems;

  @override
  void initState() {
    super.initState();
    _currentCartItems =List.from(widget.cartItems);
  }

  void _removeFromCart(Song song) {
    setState(() {
      _currentCartItems.removeWhere((item) => item.id == song.id);
    });
    widget.onCartUpdated(_currentCartItems);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song.title} removed from cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF121212),
      appBar:AppBar(
        title:const Text("Checkout"),
        backgroundColor:const Color(0xFF1A1A1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: _currentCartItems.length,
        itemBuilder: (context, index) {
          final song = _currentCartItems[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                song.coverPath,
                width:50,
                height:50,
                fit:BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width:50,
                  height:50,
                  color:Colors.grey[800],
                  child:const Icon(Icons.music_note, color: Colors.white54),),
              ),
            ),
            title: Text(song.title,style: const TextStyle(color: Colors.white)),
            subtitle: Text(song.artist,style: const TextStyle(color: Colors.grey)),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed:()=>_removeFromCart(song),),
          );
        },
      ),
      bottomNavigationBar:Padding(
        padding:const EdgeInsets.all(16.0),
        child:ElevatedButton(
          style:ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1DB954),
            shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
          },
          child:const Text('Pay Now',
            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  final List<Category> categories = const [
    Category(name:'RAP',imagePath:'assets/Untitled-2.png'),
    Category(name:'ROCK',imagePath:'assets/rock.png'),
    Category(name:'POP',imagePath:'assets/pop.png'),
    Category(name:'CLASSIC',imagePath:'assets/clasic.png'),];

  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text('Category', style: TextStyle(color: Colors.white)),
        backgroundColor:const Color(0xFF0F0F0F),
        centerTitle:true,),
      backgroundColor:const Color(0xFF0F0F0F),
      body:ListView.builder(
        padding:const EdgeInsets.all(8),
        itemCount:categories.length,
        itemBuilder:(context, index) {
          return Padding(
            padding:const EdgeInsets.only(bottom: 8),
            child:ClipRRect(
              borderRadius:BorderRadius.circular(12),
              child:InkWell(
                onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicShopPage(
                        title: categories[index].name, songs: [
                        Song(id: 1, title:"${categories[index].name} Song 1", artist:"Artist 1",coverPath:"assets/images/drug.jpg"),
                        Song(id: 2, title: "${categories[index].name} Song 2", artist: "Artist 2", coverPath:"assets/images/pink.jpg"),
                        Song(id: 3, title:"${categories[index].name} Song 3", artist: "Artist 3",coverPath:"assets/images/rock.jpg"),
                        Song(id: 4, title:"${categories[index].name} Song 4",artist:"Artist 4",coverPath:"assets/images/see.jpg"),],),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children:[
                    Image.asset(
                      categories[index].imagePath,
                      width:double.infinity,
                      height:200,
                      fit:BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height:200,
                        color:Colors.grey[800],
                        child:const Icon(Icons.broken_image, color: Colors.white),),),
                    Container(
                      decoration:BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors:[
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Category{
  final String name;
  final String imagePath;
  const Category({required this.name, required this.imagePath});
}

void main(){
  runApp(const MyApp());}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Song> demoSongs = [
      Song(id: 1,
          title:"Imagine",
          artist:"John Lennon",
          coverPath:"assets/images/drug.jpg"),
      Song(id: 2,
          title:"Hey Jude",
          artist:"The Beatles",
          coverPath:"assets/images/pink.jpg"),
      Song(id:3,
          title:"Smells Like Teen Spirit",
          artist:"Nirvana",
          coverPath:"assets/images/rock.jpg"),
      Song(id:4,
          title:"Purple Rain",
          artist:"Prince",
          coverPath:"assets/images/see.jpg"),];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Shop',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954),
      ),
      home: MusicShopPage(title: 'Music shop', songs: demoSongs),
      routes: {
        '/categories': (context) => const CategoriesPage(),
      },
    );
  }
}

