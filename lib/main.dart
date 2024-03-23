import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macitor/src/features/home_page/cubit/home_page_cubit.dart';
import 'package:macitor/src/features/home_page/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<HomePageCubit>(create: (_) => HomePageCubit())],
      child: const CupertinoApp(
        title: "Macitor",
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
