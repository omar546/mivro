part of 'sales_cubit.dart';

abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {
  final List<Sale> sales;

  SalesLoaded(this.sales);
}

class SalesError extends SalesState {
  final String message;

  SalesError(this.message);
}
