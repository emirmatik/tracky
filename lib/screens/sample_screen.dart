import 'package:flutter/material.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracky',
      theme: ThemeData(fontFamily: 'Poppins', useMaterial3: true,),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tracky'),
        ),
        body: const Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
