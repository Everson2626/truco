import 'package:flutter/material.dart';
import 'package:truco/helpers/player_helper.dart';

class PlayersPage extends StatefulWidget {



  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayersPage> {


  TextEditingController addPlayer = TextEditingController();

  PlayerHelper helper = PlayerHelper();
  List<Player> players = List();
  List<Player> teste = List();


  @override
  Widget build(BuildContext context) {

    getAllPlayers();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Adicionar jogadores"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: TextField(
              controller: addPlayer,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0
                ),
                border: OutlineInputBorder(),
                labelText: "Adicione Jogador",
              ),
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
          RaisedButton(
              child: Text("Adicionar"),
              onPressed: () {
                if(addPlayer != null && addPlayer.text.isNotEmpty && addPlayer.text.length < 13){
                  setState(() {
                    adicionar();
                  });
                }
              }
          ),
          Divider(color: Colors.black,),
          Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (BuildContext context, int index){
                  return _cardPlayer(context, index);
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget _cardPlayer(BuildContext context, int index){
    return Card(
      borderOnForeground: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              players[index].name,
              style: TextStyle(
                  fontSize: 30.0
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              height: 80.0,
              width: 80.0,
              color: Colors.red,
              child: Icon(
                  Icons.delete
              ),
            ),
            onTap: (){
              remover(players[index].id);
            },
          )
        ],
      ),
    );
  }
  remover(int id){
    setState(() {
      helper.deletePlayer(id);
    });
  }
  adicionar(){
    //helper.deletePlayer(5);
    Player p = Player();
    p.name = addPlayer.text;
    helper.savePlayer(p);
    addPlayer.text = "";
  }

  void getAllPlayers(){
    helper.getAllPlayers().then((list) =>
        setState(() {
          players = list;
        }),
    );
  }

}