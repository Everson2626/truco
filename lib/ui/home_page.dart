import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truco/helpers/player_helper.dart';
import 'package:truco/helpers/team_helper.dart';
import 'package:truco/ui/cont_page.dart';
import 'package:truco/ui/players_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlayerHelper helper = PlayerHelper();
  TeamHelper teamHelper = TeamHelper();
  List playersList = List();
  Map<String, List> players = {"team1": List<int>(3), "team2": List<int>(3)};
  Map<String, List> playersName = {"team1": List<String>(3), "team2": List<String>(3)};

  int _resultTeamPlayer = 2;
  int _radioValueTeamPlayer = 2;
  int _resultPoints = 12;
  int _radioValuePoints = 12;

  @override
  void initState() {
    getAllPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            "Configurações da partida",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PlayersPage()));
                getAllPlayers();
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Dados da partida",
                style: TextStyle(fontSize: 40.0),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text("Pontos", style: TextStyle(fontSize: 20.0),),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 12,
                                      groupValue: _radioValuePoints,
                                      onChanged: _pointsRadioChange,
                                    ),
                                    Text("12"),
                                    Radio(
                                      value: 15,
                                      groupValue: _radioValuePoints,
                                      onChanged: _pointsRadioChange,
                                    ),
                                    Text("15"),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text("Tamanho dos times", style: TextStyle(fontSize: 20.0),),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: _radioValueTeamPlayer,
                                      onChanged: _teamRadioChange,
                                    ),
                                    Text("1"),
                                    Radio(
                                      value: 2,
                                      groupValue: _radioValueTeamPlayer,
                                      onChanged: _teamRadioChange,
                                    ),
                                    Text("2"),
                                    Radio(
                                      value: 3,
                                      groupValue: _radioValueTeamPlayer,
                                      onChanged: _teamRadioChange,
                                    ),
                                    Text("3"),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Times",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [dropDownTeam("team1"), dropDownTeam("team2")],
              ),
              Divider(),
              RaisedButton(
                color: Colors.black,
                child: Text(
                  "JOGAR",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
                onPressed: () async {
                  if(verificar()){

                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ContPage(_resultPoints, _resultTeamPlayer, players))
                    );
                  }else{
                    alertMensage("Informe todos os jogadores");
                  }
                },
              ),
            ],
          ),
        )
    );
  }

  void getAllPlayers() {
    playersList.clear();
    helper.getAllPlayers().then(
          (list) => setState(() {
            list.forEach((element) {
              playersList.add(element);
            });
          }),
        );
  }

  void _teamRadioChange(int value){
    setState(() {
      _radioValueTeamPlayer = value;

      switch(_radioValueTeamPlayer){
        case 1:
          _resultTeamPlayer = 1;
          break;
        case 2:
          _resultTeamPlayer = 2;
          break;
        case 3:
          _resultTeamPlayer = 3;
      }
    });
  }

  void _pointsRadioChange(int value){
    setState(() {
      _radioValuePoints = value;

      switch(_radioValuePoints){
        case 12:
          _resultPoints = 12;
          break;
        case 15:
          _resultPoints = 15;
          break;
      }
    });
  }

  Widget dropDownTeam(String team) {
    switch(_resultTeamPlayer){
      case 1:
        return Column(
          children: [
            DropDownBarTeam(team, 0),
          ],
        );
        break;
      case 2:
        return Column(
          children: [
            DropDownBarTeam(team, 0),
            DropDownBarTeam(team, 1),
          ],
        );
        break;
      case 3:
        return Column(
          children: [
            DropDownBarTeam(team, 0),
            DropDownBarTeam(team, 1),
            DropDownBarTeam(team, 2),
          ],
        );
        break;
      default:
        return Column(
          children: [
            DropDownBarTeam(team, 0),
            DropDownBarTeam(team, 1),
          ],
        );
    }
  }

  Widget DropDownBarTeam(String team, int player){
    if(playersName[team][player] == null){
      playersName[team][player] = "Selecione...";
    }
    return DropdownButton(
      hint: Text(playersName[team][player].toString()),

      style: TextStyle(fontSize: 20.0),
        onChanged: (newValue) {
          setState(() {
            bool verificar = true;

            players.forEach((key, value) {
              for(int cont = 0; cont < value.length; cont++){
                if(newValue == value[cont]){
                  verificar = false;
                }
              }
            });
            if(verificar){
              setState(() {
                players[team][player] = newValue;
              });
            }else{
              alertMensage("Jogador já selecionado");
            }
          });
        },
      items: playersList
          .map((e) => DropdownMenuItem(
        value: e.id,
        child: Text(e.name, style: TextStyle(color: Colors.black),),
        onTap: (){
          setState(() {
            helper.getPlayer(e.id).then((value) {
              playersName[team][player] = value.name;
            });
          });
        },
      ))
          .toList(),
    );
  }

  alertMensage(String mensagem) {
    return showOkAlertDialog(
      context: context,
      title: mensagem,
    );
  }
  bool verificar(){
    bool ok = true;

    players.forEach((key, value) {
      for(int cont = 0; cont < _resultTeamPlayer; cont++){
        if(value[cont] == null){
          ok = false;
        }
      }
    });
    return ok;
  }
}
