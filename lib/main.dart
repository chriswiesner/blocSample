import 'package:bloc_sample/item_bloc.dart';
import 'package:bloc_sample/list_bloc.dart';
import 'package:bloc_sample/bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  BlocSupervisor.delegate = MyBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BlocProvider(
        create: (_) => ListBloc()..add(LoadEvent()),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          if (state is ListInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ListLoaded) {
            return _ListView(items: state.items);
          }
          return const Text("Error Message");
        },
      ),
    );
  }
}

enum ItemType { Private, Business }

class _ListView extends StatelessWidget {
  const _ListView({Key key, this.items}) : super(key: key);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return BlocProvider(
          create: (_) => ItemBloc(),
          child: BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemAssignSuccess) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('Success!')));
              }
              if (state is ItemAssignFailure) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('Failure!')));
              }
            },
            child: _ListItem(item: items[index]),
          ),
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final String item;

  const _ListItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.lightBlue),
      secondaryBackground: Container(color: Colors.green),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // No logic so just navigate directly...no need for a bloc
          Navigator.of(context).push(Business.route);
          return false;
        }
        context.bloc<ItemBloc>().add(AssignItem(ItemType.Private));
        return false;
      },
      child: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          return ListTile(            
            title: Text(item),
            trailing: state.isAssigned
                ? Icon(Icons.check_box)
                : Icon(Icons.check_box_outline_blank),
          );
        },
      ),
    );
  }
}

class Business extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => Business());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business')),
      body: Container(),
    );
  }
}
