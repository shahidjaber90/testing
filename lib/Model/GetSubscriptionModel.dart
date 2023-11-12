// ignore_for_file: unnecessary_this, prefer_collection_literals

class GetSubscriptionModel {
  String? success;
  List<Data>? data;

  GetSubscriptionModel({this.success, this.data});

  GetSubscriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? description;
  String? subscriptionId;
  String? priceId;
  String? amount;
  String? currency;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.description,
      this.subscriptionId,
      this.priceId,
      this.amount,
      this.currency,
      this.status,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    subscriptionId = json['subscription_id'];
    priceId = json['price_id'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['subscription_id'] = this.subscriptionId;
    data['price_id'] = this.priceId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
