import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db/widgets/loader/loader_widget_model.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  
}
