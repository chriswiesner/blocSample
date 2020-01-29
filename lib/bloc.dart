import 'package:bloc/bloc.dart';
import 'package:bloc_sample/main.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  @override
  ListState get initialState => ListError();

  @override
  Stream<ListState> mapEventToState(ListEvent event) async* {
    if (event is LoadEvent) {
      yield ListLoaded(List.of(["abc", "def", "ghi", "jkl"]));
    }
    if (event is AssignItem) {
      if (event.type == ItemType.Business) {
        // Navigate to Detail
        // return
      }

      if (event.type == ItemType.Private) {
        // assign item (call repo)
        // yield list with updated item
        // show snackbar to undo assignment
        // OR show snackbar when assignment failed
      }
    }
  }
}

abstract class ListEvent {}

class LoadEvent extends ListEvent {}

abstract class ListState {}

class ListError extends ListState {}

class ListLoaded extends ListState {
  final List<String> items;

  ListLoaded(this.items);
}

class AssignItem extends ListEvent {
  final type;

  AssignItem(this.type);
}
