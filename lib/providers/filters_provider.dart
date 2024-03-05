import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegaterian,
  vegan,
}
class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegaterian: false,
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters; //seçilen filtreye göre ayarlanır
  }
  void setFilter(Filter filter, bool isActive) {
    //hangi filtrenin farklı değere ayarlanması için filtre ve isActive filtrenin doğru yanlış olması
    //state[filter] = isActive;
    //durumun filtresine güncellenmiş olan değer atanmaz çünkü bellekteki durum değisir izin yok
    state = {
      ...state,
      filter:
          isActive, //eski anahtar değeri geçersiz kılan yeni anahtar değer çifti oluşturulur
      //kopyalanan aynı anahtar değer filtreye yazılır
    }; //mevcut haritayı mevcut anahtar değerı yayma operatörüyle kopyalamak
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters= ref.watch(filtersProvider);
  
  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegaterian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
