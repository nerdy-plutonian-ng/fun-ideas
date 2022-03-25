import 'package:flutter/material.dart';
import '../widgets/idea_page.dart';
import '../widgets/faves_page.dart';
import '../utilities/app_themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Fun Ideas',style: Theme.of(context).textTheme.headline5,),
              ),
              Expanded(child: selectedTabIndex == 0 ? const IdeaPage() : const FavesPage(),)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTabIndex,
        onTap: (index){
          setState(() {
            selectedTabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                      color: selectedTabIndex == 0
                          ? lavenderBlue
                          : Colors.transparent),
                  child: const Icon(Icons.chat)),
              label: 'Idea'),
          BottomNavigationBarItem(
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: selectedTabIndex == 1
                          ? lavenderBlue
                          : Colors.transparent),
                  child: const Icon(Icons.favorite)),
              label: 'Faves'),
        ],
      ),
    );
  }
}
