import 'package:bloc/bloc.dart';
import 'package:bloc_sample/main.dart';

/// Manages Actions/Business Logic for a single item
class ItemBloc extends Bloc<ItemEvent, ItemState> {
  @override
  ItemState get initialState => ItemInitial();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is AssignItem) {
      if (event.type == ItemType.Private) {
        try {
          // assign item (call repo)
          // yield list with updated item
          // show snackbar to undo assignment
          // OR show snackbar when assignment failed
          await Future.delayed(const Duration(seconds: 1));
          yield ItemAssignSuccess(event.type, true);
        } catch (_) {
          yield ItemAssignFailure(event.type);
        }
      }
    }
  }
}

abstract class ItemEvent {}

class AssignItem extends ItemEvent {
  final type;

  AssignItem(this.type);
}

abstract class ItemState {
  final bool isAssigned;

  const ItemState(this.isAssigned);
}

class ItemInitial extends ItemState {
  const ItemInitial() : super(false);
}

class ItemAssignSuccess extends ItemState {
  final type;

  const ItemAssignSuccess(this.type, bool isAssigned) : super(isAssigned);
}

class ItemAssignFailure extends ItemState {
  final type;

  const ItemAssignFailure(this.type) : super(false);
}
