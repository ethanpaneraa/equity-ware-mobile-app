import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  List<BluetoothService> services = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    checkBluetoothState();
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  void checkBluetoothState() {
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        scanForDevices();
      } else {
        print('Bluetooth is ${state.toString().substring(state.toString().indexOf('.') + 1)}');
        setState(() {
          devicesList.clear();
        });
      }
    });
  }

  void scanForDevices() async {
    setState(() {
      isScanning = true;
    });

    try {
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      print('Scanning for devices...');

      flutterBlue.scanResults.listen((results) {
        setState(() {
          devicesList.clear();
          for (ScanResult result in results) {
            print('Device found: ${result.device.name}, ID: ${result.device.id}');
            if (!devicesList.any((device) => device.id == result.device.id)) {
              devicesList.add(result.device);
            }
          }
        });
      });

      await Future.delayed(Duration(seconds: 4));
    } catch (e) {
      print('Error during scanning: $e');
    } finally {
      flutterBlue.stopScan();
      setState(() {
        isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
        actions: [
          isScanning
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: scanForDevices,
                ),
        ],
      ),
      body: connectedDevice != null
          ? buildConnectedDeviceView()
          : devicesList.isEmpty
              ? Center(child: Text('No devices found'))
              : ListView.builder(
                  itemCount: devicesList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(devicesList[index].name.isNotEmpty ? devicesList[index].name : 'Unknown Device'),
                      subtitle: Text(devicesList[index].id.toString()),
                      onTap: () => connectToDevice(devicesList[index]),
                    );
                  },
                ),
    );
  }

  Widget buildConnectedDeviceView() {
    return Column(
      children: [
        ListTile(
          title: Text(connectedDevice!.name.isNotEmpty ? connectedDevice!.name : 'Unknown Device'),
          subtitle: Text(connectedDevice!.id.toString()),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ExpansionTile(
                title: Text('Service: ${service.uuid}'),
                children: service.characteristics.map((characteristic) {
                  return ListTile(
                    title: Text('Characteristic: ${characteristic.uuid}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Properties: ${characteristic.properties.toString()}'),
                        // Add buttons or actions here to read/write/notify on the characteristic
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      print('Connected to ${device.name}');
      setState(() {
        connectedDevice = device;
      });
      discoverServices(device);
    } catch (e) {
      print('Error connecting to device: $e');
      // Optionally rescan and try connecting again
      scanForDevices();
    }
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    setState(() {
      this.services = services;
    });

    for (BluetoothService service in services) {
      print('Service found: ${service.uuid}');
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        print('Characteristic found: ${characteristic.uuid}');
        // You can perform read/write operations on the characteristic here
      }
    }
  }
}
