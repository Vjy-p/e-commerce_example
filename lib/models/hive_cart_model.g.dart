part of 'hive_cart_model.dart';

class HiveCartModelAdapter extends TypeAdapter<HiveCartModel> {
  @override
  final int typeId = 0;

  @override
  HiveCartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCartModel(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as int,
      discountPercentage: fields[3] as double,
      rating: fields[4] as double?,
      brand: fields[5] as String,
      thumbnail: fields[6] as String,
      quantity: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCartModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.discountPercentage)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.brand)
      ..writeByte(6)
      ..write(obj.thumbnail)
      ..writeByte(7)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
