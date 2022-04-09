import 'package:hexcolor/hexcolor.dart';

import '../const/list_colors.dart';

final palette = {
  'white': HexColor("#F4F4F6"), 
  'darkBlue': HexColor("#0C064D"), 
  'red': HexColor("#BE0909"), 
  'blue': HexColor("#4A93E2"), 
  'grey': HexColor("#B0A3A7"), 
  'darkPurple': HexColor("#817290"), 
}; 

final listColorToColor = {
  ListColor.blue: palette['blue'], 
  ListColor.red: palette['red'], 
  ListColor.grey: palette['grey'], 
  ListColor.darkPurple: palette['darkPurple'], 
  ListColor.darkBlue: palette['darkBlue'], 
}; 
