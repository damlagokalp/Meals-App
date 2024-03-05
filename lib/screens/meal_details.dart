
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/favorites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });
  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ConsumerWidgettan dolayı ikinci parametre gelir
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);
    return Scaffold(
        appBar: AppBar(
          title: Text(meal.title),
          actions: [
            IconButton(
              onPressed: () {
                //icon düğmesine basınca ref ve değişiklik dinleyicisi kullanabiliriz
                //değişiklik tam olarak değiştiği yerden tetiklenir
                final wasAdded = ref
                    .read(favoriteMealsProvider.notifier)
                    .toggMealFavoriteStatus(
                        meal); //bir değer yazınca bir kez okunur okunması gereken değer provider
                ScaffoldMessenger.of(context)
                    .clearSnackBars(); //snackbarı temizleme
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(wasAdded
                        ? 'Meal added as a favorite.'
                        : 'Meal removed'), //metnin dinamik olarak eklendiği kontrol edilir
                  ), );},
              //AnimatedSwitcher bir animasyon yıldıza basınca oluşacak
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns:
                        Tween<double>(begin: 0.5, end: 1.0).animate(animation),
                    child: child,
                  );
                }, //cjild her değiştiğinde animasyonu başlatır
                child: Icon(isFavorite ? Icons.star : Icons.star_border,
                    key: ValueKey(isFavorite)),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //canlandırılan widget
              Hero(
                tag: meal.id,
                child: Image.network(meal.imageUrl,
                    height: 300, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (final ingredient in meal.ingredients)
                Text(ingredient,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        )), //yemek malzemelerinin bir listesi
              const SizedBox(height: 24),
              Text(
                'Steps',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 14),
              for (final step in meal.steps)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(step,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                ),
            ],
          ),
        ) //BoxFit.cover görüntünün bozulmadığından emin olamk için
        //SingleChildScrollView =>kaydırılabilir ekran
        );
  }
}
