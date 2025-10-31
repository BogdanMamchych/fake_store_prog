import 'package:equatable/equatable.dart';

class ItemViewerState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ItemViewerInitial extends ItemViewerState {}

class ItemViewerError extends ItemViewerState {
  final String message;

  ItemViewerError({required this.message});

  @override
  List<Object?> get props => [message];
}