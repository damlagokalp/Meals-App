import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController
      _animationController; 
      //ilk değere sahip olacağı zaman ve ilk kez ihtiyaç duyulacağı zaman arasında küçük fark demek =>late

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 300), //animasyonun oynatılma süresi
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController
        .forward(); //animasyonu başlatır ve durdurana kadar oynatılmaya devam eder
    //_animation.repeat olsaydı bitince geri başlatılırdı
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList(); 
    //her öğün için bir kez döner seçilen kategorinin id içerio içermediği kontrol edilir
    //where tarafından döndürülen yinelenebilir dosya tolist ile gerçek listeye dönüşür

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          //geçek kategori ve yemek verileri  yüklenebilir
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    ); //Navigator.push(context,route)
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        //ızgara görünümü düzenini ayarlar  
        //SliverGridDelegateWithFixedCrossAxisCount=> sutun sayısını ayarlar
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ), //yan yana 2 sütun ede edilir 
        //childAspectRatio=> istenen en boy oranı,crossAxisSpacing sutunlar arası boşluk
        children: [
          // availableCategories.map((category)=>CategoryGridItem(category: category)).toList();
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      builder: (context, child) => SlideTransition(
          position: Tween(
            //x y ekseninde ne kadar kaydığını belirtir
            begin: const Offset(0, 0.3), //içerik %30 aşağı itilir
            end: const Offset(0,
                0), //ızgara görünümünü gerçek konumunda sonlandırmak istiyorum
          ).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut),
          ),
          //Tween classı tamamen iki değer arasında geçişi canlandırmak ve tanımlamakla ilgilgi lowervound ve upperbound arasında değer atar
          //CurvedAnimation kavisli animasyon bu eğriler sadece başlangıç ve bitiş durumu arası geçişin mevcut an. süresine nasıl yayılacağını
          //Curves.ease yavaş başlayıp yavaş biter ortada biraz hızlanma olur

          child: child),
    ); //animasyon dinlenebilri bir nesnedir amimationcontroller ile denetlenebilir ve her tıklandığında gerçekleşmesi için işlev verilir
    //Padding içindeki child teknik olarak gridviewdir
    //SlideTransition hafif geçiş efekti
  }
}
