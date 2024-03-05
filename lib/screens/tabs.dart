import 'package:flutter/material.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegaterian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  //sayfalar arası geçiş için
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0; //seçilen sayfanın indexi

  void _selectedPage(index) {
    //seçilen sayfa dizinini güncellemek için setState çağırılır
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); //kösedeki menüde tıklayınca kapanır
    if (identifier == 'filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        //pushReplacement geri tuşu uygulamayı tamamen kapatır
        MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
      ); //filtre ekranını kullanrak için filtre başlangıcı bu sekemeye verilir
      //seçilen filtreler korunur
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(
        filteredMealsProvider); 
        //yeni provider filtrelenmiş yemek listesini döndürür

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ), 
      //çekemece parametresi için ana çekmece widgetı buraya yazılır,
      body:
          activePage, //hangi sekmenin seçildiğine bağlı olarak aktif ekran olacaktır
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedPageIndex, //geçerli sayfa dizini senkronize eder
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ], //sekmeler listesi
      ), //sekme çubuğu kullanıcı sekme seçtiğinde otomatik tetiklenir
    );
  }
}
