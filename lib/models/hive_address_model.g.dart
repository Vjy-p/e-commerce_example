part of 'hive_address_model.dart';

class HiveAddressModelAdapter extends TypeAdapter<HiveAddressModel> {
  @override
  final int typeId = 3;

  @override
  HiveAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAddressModel(
      id: fields[0] as String,
      flatNumber: fields[1] as String,
      optional: fields[2] as String,
      buildingName: fields[3] as String,
      colonyRoadName: fields[4] as String,
      landmark: fields[5] as String,
      area: fields[6] as String,
      pincode: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveAddressModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.flatNumber)
      ..writeByte(2)
      ..write(obj.optional)
      ..writeByte(3)
      ..write(obj.buildingName)
      ..writeByte(4)
      ..write(obj.colonyRoadName)
      ..writeByte(5)
      ..write(obj.landmark)
      ..writeByte(6)
      ..write(obj.area)
      ..writeByte(7)
      ..write(obj.pincode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
