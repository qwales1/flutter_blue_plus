part of 'bluetooth_bloc.dart';

final class BluetoothConnected extends BluetoothState {
  final ScanResult scanResult;
  final String deviceIp;
  final String udpPort;
  BluetoothConnected(this.scanResult, this.deviceIp, this.udpPort);
}

final class BluetoothConnecting extends BluetoothState {}

final class BluetoothInitial extends BluetoothState {}

final class BluetoothReady extends BluetoothState {}

final class BluetoothScan extends BluetoothState {
  final List<ScanResult> scanResults;
  BluetoothScan(this.scanResults);
}

final class BluetoothScanFailure extends BluetoothState {
  final String message;
  BluetoothScanFailure(this.message);
}

@immutable
sealed class BluetoothState {}
