import 'package:equatable/equatable.dart';

class ProductViewerState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProductViewerInitial extends ProductViewerState {}

class ProductViewerError extends ProductViewerState {
  final String message;

  ProductViewerError({required this.message});

  @override
  List<Object?> get props => [message];
}