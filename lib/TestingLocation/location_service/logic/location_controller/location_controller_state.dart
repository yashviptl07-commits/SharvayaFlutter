// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'location_controller_cubit.dart';

abstract class LocationControllerState extends Equatable {
  const LocationControllerState();

  @override
  List<Object> get props => [];
}

//test
class LoadingLocation extends LocationControllerState {}

class StopLocationFetch extends LocationControllerState {}

class LocationFetched extends LocationControllerState {
  final Position location;
  const LocationFetched({
     this.location,
  });
  @override
  List<Object> get props => [location];
}

class LocationError extends LocationControllerState {
  final String error;
  const LocationError({ this.error});
  @override
  List<Object> get props => [error];
}
