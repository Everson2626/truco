import 'package:sqflite/sqflite.dart';

class MatchHelper {

  static final MatchHelper _instance = MatchHelper.internal();

  factory MatchHelper() => _instance;

  MatchHelper.internal();

}