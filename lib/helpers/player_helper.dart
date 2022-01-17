import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';


final String playerTable = "playerTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String teamTable = "teamTable";
final String idTeamColumn = "idTeamColumn";
final String playerIdColumn = "playerIdColumn";


class PlayerHelper {

  static final PlayerHelper _instance = PlayerHelper.internal();

  factory PlayerHelper() => _instance;

  PlayerHelper.internal();

  Database _db;

  List<Player> teste = List();

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
    }
    return _db;
  }

  Future<Database> initDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "truco.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async{
      await db.execute(
          "CREATE TABLE $playerTable("
              "$idColumn INTEGER PRIMARY KEY,"
              "$nameColumn TEXT"
              ");"
          "CREATE TABLE $teamTable("
              "$idColumn INTEGER PRIMARY KEY,"
              "$playerIdColumn TEXT,"
              "$idTeamColumn TEXT"
              ")"
      );
    });
  }

  Future<Player>savePlayer(Player player) async{
    Database dbPlayer = await db;
    player.id = await dbPlayer.insert(playerTable, player.toMap());
    player.toString();
    print(player);
    return player;
  }

  Future<Player>getPlayer(int id) async{
    Database dbPlayer = await db;
    List<Map> maps = await dbPlayer.query(playerTable,
        columns: [idColumn,nameColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Player.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<List>getAllPlayers() async{
    Database dbPlayer = await db;
    List listMap = await dbPlayer.rawQuery("SELECT * FROM $playerTable");
    List<Player> listPlayer = List();
    for(Map m in listMap){
      listPlayer.add(Player.fromMap(m));
    }
    return listPlayer;
  }

  Future<int> deletePlayer(int id) async{
    Database dbPlayer = await db;
    return await dbPlayer.delete(playerTable, where: "$idColumn = ?", whereArgs: [id]);
  }

}

class Player{
  int id;
  String name;

  Player();

  Player.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
  }

  Map toMap(){
    Map<String,dynamic> map = {
      nameColumn: name,
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString(){
    return "Player(id: $id, name: $name)";
  }
}