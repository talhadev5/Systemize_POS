// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsModelAdapter extends TypeAdapter<ProductsModel> {
  @override
  final int typeId = 0;

  @override
  ProductsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductsModel(
      success: fields[0] as bool?,
      data: fields[1] as Data?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 1;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      products: (fields[0] as List).cast<Product>(),
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 2;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      productId: fields[0] as int?,
      companyId: fields[1] as String?,
      branchId: fields[2] as String?,
      categoryId: fields[3] as String?,
      category: fields[4] as String?,
      printerIp: fields[5] as String?,
      kitchenId: fields[6] as int?,
      kitchenName: fields[7] as String?,
      productCode: fields[8] as String?,
      title: fields[9] as String?,
      productImage: fields[10] as String?,
      favouriteItem: fields[11] as String?,
      appUrl: fields[12] as String?,
      price: fields[13] as String?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
      variations: (fields[16] as List).cast<Variation>(),
      addOn: (fields[17] as List).cast<AddOn>(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.branchId)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.printerIp)
      ..writeByte(6)
      ..write(obj.kitchenId)
      ..writeByte(7)
      ..write(obj.kitchenName)
      ..writeByte(8)
      ..write(obj.productCode)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.productImage)
      ..writeByte(11)
      ..write(obj.favouriteItem)
      ..writeByte(12)
      ..write(obj.appUrl)
      ..writeByte(13)
      ..write(obj.price)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.variations)
      ..writeByte(17)
      ..write(obj.addOn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VariationAdapter extends TypeAdapter<Variation> {
  @override
  final int typeId = 3;

  @override
  Variation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Variation(
      variationId: fields[0] as int?,
      productId: fields[1] as String?,
      variationName: fields[2] as String?,
      variationPrice: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Variation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.variationId)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.variationName)
      ..writeByte(3)
      ..write(obj.variationPrice)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VariationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddOnAdapter extends TypeAdapter<AddOn> {
  @override
  final int typeId = 4;

  @override
  AddOn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddOn(
      addOnId: fields[0] as int?,
      productId: fields[1] as String?,
      addOnName: fields[2] as String?,
      addOnPrice: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AddOn obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.addOnId)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.addOnName)
      ..writeByte(3)
      ..write(obj.addOnPrice)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddOnAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
