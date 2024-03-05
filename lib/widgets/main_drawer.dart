import 'package:flutter/material.dart';

//sol üst köşede menü simgesi için
//sola kaydırılarak kapatılır
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  //Lineargradient renkleri tema olarak
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
                begin: Alignment.topLeft, //gradyan üst soldan
                end: Alignment.bottomRight, //alt sağa doğru
              )),
              child: Row(
                children: [
                  Icon(Icons.fastfood,
                      size: 48, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 18),
                  Text(
                    'Cooking Up!',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ) //başlığın bu temada tanımlanacağını bildiğim için ! konur,
                ],
              )),
          ListTile(
            leading: Icon(Icons.restaurant,
                size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'Meals',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('meals');
            }, //dokunulabilir olması için
          ),
          ListTile(
            leading: Icon(Icons.settings,
                size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'Filters',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen('filters');
            }, //dokunulabilir olması için
          ),
        ],
      ),
    );
  }
}
