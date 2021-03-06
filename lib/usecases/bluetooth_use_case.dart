import 'package:rxdart/rxdart.dart';

import 'package:nigiru_kun/repositorys/bluetooth_repository.dart';
import 'package:nigiru_kun/datasources/bluetooth/nigirukun_peripheral.dart';

class Peripheral {
  final String name;
  final String id;

  Peripheral(this.name, this.id);
}

class BluetoothUseCase {
  final BluetoothRepository repository = BluetoothRepositoryImpl();
  List<NigirukunPeripheral> _nigirukunList = [];

  Observable<Peripheral> scan() {
    _nigirukunList = [];
    Observable<NigirukunPeripheral> observable = repository.scan();
    observable.listen((data) => _nigirukunList.add(data));
    return observable.map((nigirukun) => Peripheral('にぎるくん', nigirukun.uuid));
  }

  void connect(String id) {
    repository.connect(
        _nigirukunList.where((nigirukun) => nigirukun.uuid == id).first);
  }

  void disconnect() {
    repository.disconnect();
  }

  Peripheral get connectedPeripheral {
    NigirukunPeripheral nigirikun = repository.connectedNigirukunPeripheral;
    return nigirikun == null ? null : Peripheral('にぎるくん', nigirikun.uuid);
  }

  bool get isConnected => repository.connectedNigirukunPeripheral != null;
}
