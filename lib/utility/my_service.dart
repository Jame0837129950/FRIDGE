import 'package:intl/intl.dart';

class MyService {
  String dateToString({required DateTime dateTime}){
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(dateTime);
  }
  
}