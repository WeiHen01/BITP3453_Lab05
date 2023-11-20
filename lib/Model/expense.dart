import '../Controller/request_controller.dart';

class Expense{
  String desc;
  double amount;
  String dateTime;
  Expense(this.amount, this.desc, this.dateTime);

  Expense.fromJson(Map<String, dynamic> json)
    : desc = json['desc'],
      amount = json['amount'],
      dateTime = json['dateTime'];

  Map<String, dynamic> toJson() =>
      {'desc': desc, 'amount': amount, 'dateTime': dateTime};

  Future<bool> save() async {
    RequestController req = RequestController(path: "/api/expenses.php");
    req.setBody(toJson());

    try{
      await req.post();
      print(req.status());
      if (req.status() == 200){
        return true;
      }
    } catch (e) {
      print("Exception during HTTP request: $e");
    }
    return false;
  }


  static Future<List<Expense>> loadAll() async{
    List<Expense> result = [];
    RequestController req = RequestController(path: "/api/expenses.php");
    await req.get();

    if(req.status() == 200 && req.result() != null){
      for (var item in req.result()){
        result.add(Expense.fromJson(item));
      }
    }
    return result;
  }
}