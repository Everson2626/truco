import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:truco/helpers/player_helper.dart';


final String teamTable = "teamTable";
final String idColumn = "idColumn";
final String idTeamColumn = "idTeamColumn";
final String playerIdColumn = "playerIdColumn";

class TeamHelper {

  static final TeamHelper _instance = TeamHelper.internal();

  factory TeamHelper() => _instance;

  TeamHelper.internal();

  Database _db;
  int timeId;

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
          "CREATE TABLE $teamTable("
              "$idColumn INTEGER PRIMARY KEY,"
              "$playerIdColumn TEXT,"
              "$idTeamColumn TEXT"
              ")"
      );
    });
  }

  Future<Team>saveTeam(Team team) async{
    if(team.idPlayer != "null"){
      Database dbTeam = await db;
      timeId = await dbTeam.insert(teamTable, team.toMap());
      print(timeId);
      team.toString();
    }
    return team;
  }

  Future<Team> obterTimeId() async{
    Database dbPlayer = await db;
    String sql = "SELECT $idTeamColumn FROM $teamTable LIMIT 1 GROUP BY $idTeamColumn ORDER BY $idTeamColumn DESC";
    print(sql);
    List listMap = await dbPlayer.query(sql);
    for(Map m in listMap){
      return Team.fromMap(m);
    }
  }

  Future<List<Map>>getTeam(int id) async{
    Database dbTeam = await db;
    List<Map> maps = await dbTeam.query(teamTable,
        columns: [idColumn,playerIdColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return maps;
    }else{
      return null;
    }
  }

  Future<List>getAllPlayersTeam(timeId) async{
    Database dbPlayer = await db;
    List listMap = await dbPlayer.rawQuery("SELECT * FROM $teamTable WHERE $idTeamColumn = $timeId");
    List<Player> listPlayer = List();
    for(Map m in listMap){
      listPlayer.add(Player.fromMap(m));
    }
    return listPlayer;
  }

}

class Team{
  int id;
  String idPlayer;
  String idTeam;

  Team();

  Team.fromMap(Map map){
    id = map[idColumn];
    idPlayer = map[playerIdColumn];
    idTeam = map[idTeamColumn];
  }

  Map toMap(){
    Map<String,dynamic> map = {
      idColumn: id,
      playerIdColumn: playerIdColumn,
      idTeam: idTeamColumn
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }
}