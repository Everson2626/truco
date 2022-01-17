import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truco/helpers/player_helper.dart';
import 'package:truco/helpers/team_helper.dart';
import 'package:truco/ui/players_page.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class ContPage extends StatefulWidget {

  ContPage(this._resultPoints, this._resultTeamPlayer, this._teams);
  final _resultPoints;
  final _resultTeamPlayer;
  final _teams;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<ContPage> {
  PlayerHelper helper = PlayerHelper();
  TeamHelper teamHelper = TeamHelper();

  int pontos1 = 0;
  int pontos2 = 0;
  int acrescentar = 1;

  Map truco = {1: 'PONTO', 3: 'TRUCO', 6: 'SEIS', 9: 'NOVE', 12: 'DOZE'};
  Map<String, String> nameTeamPlayers = {"team1": null, "team2": null};
  String botaoTruco = "TRUCO";

  @override
  initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Contador",
          style: TextStyle(fontSize: 30.0),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${acrescentar} Ponto",
              style: TextStyle(color: Colors.red, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Column(
                    children: [
                      playersNameTeams("team1",widget._resultTeamPlayer),
                      Text(
                        "${pontos1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.0,
                        ),
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            color: Colors.black,
                            child: Text(
                              "+",
                              style:
                              TextStyle(fontSize: 70, color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                pontos1 += acrescentar;
                                acrescentar = 1;
                                botaoTruco = truco[3];
                              });
                              if (pontos1 >= widget._resultPoints) {
                                Vencedor(this.nameTeamPlayers["team1"]);
                                Zerar();
                              }
                            },
                          ),
                          RaisedButton(
                            color: Colors.black,
                            child: Text(
                              "-",
                              style:
                              TextStyle(fontSize: 70, color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                if (pontos1 > 0) {
                                  pontos1 -= 1;
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      playersNameTeams("team2",widget._resultTeamPlayer),
                      Text(
                        "${pontos2}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.0,
                        ),
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            color: Colors.black,
                            child: Text(
                              "+",
                              style:
                              TextStyle(fontSize: 70, color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                pontos2 += acrescentar;
                                acrescentar = 1;
                                botaoTruco = truco[3];
                              });
                              if (pontos2 >= widget._resultPoints) {
                                Vencedor(this.nameTeamPlayers["team2"]);
                                Zerar();
                              }
                            },
                          ),
                          RaisedButton(
                            color: Colors.black,
                            child: Text(
                              "-",
                              style:
                              TextStyle(fontSize: 70, color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                if (pontos2 > 0) {
                                  pontos2 -= 1;
                                }
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  child: Text("${botaoTruco}"),
                  onPressed: () {
                    setState(() {
                      if (botaoTruco == "TRUCO") {
                        acrescentar = 3;
                        botaoTruco = truco[6];
                      } else if (botaoTruco == "SEIS") {
                        acrescentar = 6;
                        botaoTruco = truco[9];
                      } else if (botaoTruco == "NOVE") {
                        acrescentar = 9;
                        botaoTruco = truco[12];
                      } else if (botaoTruco == "DOZE") {
                        acrescentar = 12;
                        botaoTruco = truco[1];
                      } else if (botaoTruco == "PONTO") {
                        acrescentar = 1;
                        botaoTruco = truco[3];
                      }
                    });
                  },
                ),
                RaisedButton(
                  child: Text("ZERAR"),
                  onPressed: () {
                    Zerar();
                  },
                ),
              ],
            ),

            Text(widget._resultPoints.toString(), style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }

  Vencedor(String vencedor) {
    int timeAtual = 0;
    teamHelper.obterTimeId().then((value) => {
      if(value != null){
        timeAtual = int.parse(value.idTeam) + 1,

        widget._teams["team1"].forEach((value) {
          Team teamAtual = new Team();
          teamAtual.idTeam = timeAtual.toString();
          teamAtual.idPlayer = value.toString();

          teamHelper.saveTeam(teamAtual);
        }),

        timeAtual = timeAtual+1,

        widget._teams["team2"].forEach((value) {
          Team teamAtual = new Team();
          teamAtual.idTeam = timeAtual.toString();
          teamAtual.idPlayer = value.toString();

          teamHelper.saveTeam(teamAtual);
        }),

      }
    });



    return showOkAlertDialog(
      context: context,
      title: vencedor + "Venceu",
    );
  }

  void Zerar() {
    setState(() {
      pontos1 = 0;
      pontos2 = 0;
      acrescentar = 1;
      botaoTruco = truco[3];
    });
  }

  Widget playersNameTeams(String team, int numberPlayer){
    if(this.nameTeamPlayers[team] == null){
      this.nameTeamPlayers[team] = "";
      for(int cont = 0; cont < numberPlayer; cont++){
        helper.getPlayer(widget._teams[team][cont]).then((value) => setState(() {
          this.nameTeamPlayers[team] = this.nameTeamPlayers[team] + value.name+"\n";
        }),
        );
      }
    }
    //print(this.nameTeamPlayers[team]);
    return Text(
      this.nameTeamPlayers[team],
      style: TextStyle(color: Colors.white,fontSize: 25.0),
    );
  }

}