import 'package:hexcolor/hexcolor.dart';

import '../const/list_colors.dart';

final customWhite =  HexColor("#F4F4F6"); 
final customDarkBlue =  HexColor("#0C064D"); 
final customRed =  HexColor("#BE0909"); 
final customBlue =  HexColor("#4A93E2"); 
final customGrey =  HexColor("#B0A3A7"); 
final customPurple =  HexColor("#817290"); 

HexColor listColorToColor(ListColor col) {
  switch(col) {
    case ListColor.blue: return customBlue; 
    case ListColor.red: return customRed; 
    case ListColor.grey: return customGrey; 
    case ListColor.darkPurple: return customPurple; 
    case ListColor.darkBlue: return customDarkBlue; 
  }
}