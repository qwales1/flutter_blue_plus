import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:meta/meta.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  Stream<RawSocketEvent>? udpSocket;
  BluetoothBloc() : super(BluetoothInitial()) {
    on<BluetoothEvent>((event, emit) async {
      switch (state.runtimeType) {
        case BluetoothInitial:
          if (event.runtimeType == BluetoothInitialize) {
            final result = await _turnOnBluetooth();
            if (result == false) {
              emit(BluetoothScanFailure('Bluetooth is not available'));
              return;
            }
            emit(BluetoothReady());
            return;
          }
          break;
        case BluetoothReady:
          {
            if (event.runtimeType == BluetoothScanRequested) {
              emit(BluetoothScan(const []));
              _startScan();
              return;
            }
            break;
          }
        case BluetoothInitialize:
          final result = await _turnOnBluetooth();
          if (result == false) {
            emit(BluetoothScanFailure('Bluetooth is not available'));
            return;
          }
          emit(BluetoothReady());
          break;
        case BluetoothConnect:
          emit(BluetoothConnecting());
          await (event as BluetoothConnect).scanResult.device.connect();

          break;

        case BluetoothScanRequested:
          break;
      }
    });
  }

  _startScan() async {
    if (!FlutterBluePlus.isScanningNow) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    }
  }

  Future<bool> _turnOnBluetooth() async {
    if (await FlutterBluePlus.isAvailable == false) {
      return false;
    }

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
      return true;
    }
    return false;
  }
}
