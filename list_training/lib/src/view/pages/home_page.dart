import 'package:flutter/material.dart';
import 'package:list_training/src/view/components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: const DrawerExample(),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.amber,
                height: 100,
                
                child: Text('Treinos'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width / 3,
                      height: 100,
                    ),
                    Spacer(),
                    Container(
                      color: Colors.orange,
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 100,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
