import 'package:flutter/material.dart';
import 'package:money_manager/home/screen_home.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndexNotifier,
      builder: ((BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
           backgroundColor: Color.fromARGB(255, 29, 31, 43),
          selectedItemColor: Color.fromARGB(255, 252, 253, 255),
          unselectedItemColor: Color.fromARGB(153, 201, 198, 198),
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            ScreenHome.selectedIndexNotifier.value = newIndex;
          },
          items: const[
            BottomNavigationBarItem(
             
              label: "Transactions",
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              label: "Categories",
              icon: Icon(
                Icons.category,
              ),
            ),
          ],
        );
      }),
    );
  }
}
