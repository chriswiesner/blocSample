import 'package:bloc/bloc.dart';

/// Manages Loading the List of Items
class ListBloc extends Bloc<ListEvent, ListState> {
  @override
  ListState get initialState => ListInitial();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is LoadEvent) {
      await Future.delayed(const Duration(seconds: 1));
      yield ListLoaded(List.of(["abc", "def", "ghi", "jkl"]));
    }
  }
}

abstract class ListEvent {}

class LoadEvent extends ListEvent {}

abstract class ListState {}

class ListInitial extends ListState {}

class ListError extends ListState {}

class ListLoaded extends ListState {
  final List<String> items;

  ListLoaded(this.items);
}
