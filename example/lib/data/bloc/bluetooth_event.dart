part of 'bluetooth_bloc.dart';

final class BluetoothConnect extends BluetoothEvent {
  final ScanResult scanResult;
  BluetoothConnect(this.scanResult);
}

@immutable
sealed class BluetoothEvent {}

final class BluetoothInitialize extends BluetoothEvent {}

final class BluetoothScanRequested extends BluetoothEvent {}

final class BluetoothScanResultFailure extends BluetoothEvent {
  final String message;
  BluetoothScanResultFailure(this.message);
}

final class BluetoothScanResultsAvailable extends BluetoothEvent {
  final List<ScanResult> scanResults;
  BluetoothScanResultsAvailable(this.scanResults);
}
