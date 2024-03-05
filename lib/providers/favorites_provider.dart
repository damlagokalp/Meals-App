import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

//riverpod state notifier kullanılırken durum nasıl saklanır nasıl erişilir nasıl güncellenir
//StateNotifier durum sağlayıcı sınıfı
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);
//favori listesini almak için daha sonra favorileri değişmek için kullanabiliriz
  bool toggMealFavoriteStatus(Meal meal) {
    //girdi olarak öğün alacak ve favori değilse
    final mealIsFavorite = state
        .contains(meal); //duruma bakıp yemeğin favori oluğp olmadığını söyler
    if (mealIsFavorite) {
      state = state
          .where((m) => m.id != meal.id)
          .toList(); //where ile listeyi filtreleriz ve tolist ile listeye çevrilir
      //meal.id ler eşit değilse 
      //favori durumunu değiştirdiğim öğün değil ve öğünü saklarım
      //eğer eşlesirse kaldırılması gereken öğün budur
      return false; //öge kaldırılmışsa
    } else {
      state = [...state, meal];
      return true;//öge eklenmişse
      // ... yayma operatörü  ...state bir yemek listesi olan state üzerinden 
      //bu listede depolanan tüm ögeleri çeker ve bunları ayrı öge olarak listeye ekler
    }
  }
}
//bu verileri widgetımızda kullanabilmemiz için gerçek providerla bağlamamız gerkiyor
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier(); //durumu düzenlemek ve durumu almak için sınıfa sahip oluruz
});
