class RafModel {
  RafModel({this.RAF});

  String? RAF;

  RafModel.fromJson(Map<String, dynamic> json) {
    RAF = json['RAF'];

  
  }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = Map<String, dynamic>();

      data['RAF'] = RAF;

      return data;
    }
}
