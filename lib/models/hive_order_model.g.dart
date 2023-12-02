part of 'hive_order_model.dart';

class HiveOrderModelAdapter extends TypeAdapter<HiveOrderModel> {
  @override
  final int typeId = 1;

  @override
  HiveOrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveOrderModel(
      orderID: fields[0] as int,
      bookedDate: fields[3] as String,
      deliveryDate: fields[4] as String,
      totalPrice: fields[1] as int,
      totalItems: fields[2] as int,
      status: fields[5] as String,
      products: (fields[6] as List).cast<HiveCartModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveOrderModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.orderID)
      ..writeByte(1)
      ..write(obj.totalPrice)
      ..writeByte(2)
      ..write(obj.totalItems)
      ..writeByte(3)
      ..write(obj.bookedDate)
      ..writeByte(4)
      ..write(obj.deliveryDate)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveOrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
