import 'package:flutter/material.dart';
import 'todoapp.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        textTheme: GoogleFonts.hammersmithOneTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/todo_image.png',
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Welcome to DO-TASK App',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'Here you can manage all your tasks efficiently. Keep track of what you need to do and stay organized!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ToDoApp()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, minimumSize: Size(200, 50)),
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
