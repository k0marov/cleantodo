import 'package:enum_to_string/enum_to_string.dart'; 

enum ListColor {
  darkBlue, 
  blue, 
  red, 
  darkPurple, 
  grey, 
}

String listColorToJson(ListColor color) => 
  EnumToString.convertToString(color); 

ListColor listColorFromJson(String json) => 
  EnumToString.fromString(ListColor.values, json)!; 