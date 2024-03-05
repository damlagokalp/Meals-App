import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart'; //şeffaf görüntü paketi
import 'package:meals/widgets/meal_item_trait.dart';
import 'package:meals/models/meal.dart';

class MealItem extends StatelessWidget {
  //ekranda görüntülenen yemek listesindeki verilerin çıktısı için
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final Meal meal;
  final void Function( Meal meal) onSelectMeal;
  // karmaşıklık
  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(
            1); //meal.complexity.name in ilk harfini büyük geri kalanını normal yazdırır
             }
  //satın alınabilirlik
  String get affordibilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1); }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip
          .hardEdge, //kart widgetının şekil sınırlarının dışına çıkanları kırpar
      elevation: 2, //kartın arkasına hefif gölge ekler
      child: InkWell(
        onTap: () {
          onSelectMeal(meal);
        },
        child: Stack(
          children: [
            Hero(
              //hero canlandırılması gereken widgetı sarar
              tag: meal.id,
              child: FadeInImage(
                placeholder:
                    MemoryImage(kTransparentImage), 
                    //şeffaf görüntü oluşturur
                image: NetworkImage(meal
                    .imageUrl), 
                    //görüntüleri URL den yükler dummydata dan referans alır
                fit: BoxFit.cover, //kututya sığdırma
                height: 200,
                width: double.infinity,
              ),
            ), //görüntü görüntüleyen yardımcı widget
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow
                          .ellipsis, //metinden sonra üç nokta konup kesilir
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,),),
                    const SizedBox(
                      height: 12, ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                            icon: Icons.schedule,
                            label:
                                '${meal.duration} min'), //Icon.schedule => süre simgesi , ${meal.duration} min' süreyi yazar
                        const SizedBox(
                          width: 12,
                        ),
                        MealItemTrait(icon: Icons.work, label: complexityText),
                        const SizedBox(
                          width: 12,
                        ),
                        MealItemTrait(
                            icon: Icons.attach_money, label: affordibilityText),
                      ],
                    ),
                  ],
                ),
              ),
            ) //konumlandırılan widget
          ],
        ),
      ),
    ); //öğünler dokunabilir olmalı
  }
}
