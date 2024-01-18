import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtub7/board_tile.dart';
import 'package:youtub7/tile_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TIC TAC',
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Orientation orientation = Orientation.portrait;
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);
  var _currentTurn = TileState.CROSS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 222, 179, 1),
      appBar: CupertinoNavigationBar(
        leading: IconButton(
            onPressed: _returnGame,
            icon: const Icon(CupertinoIcons.refresh_thin)),
        backgroundColor: const Color.fromRGBO(245, 222, 179, 1),
        middle: const Text(
          'TIC TAC',
          style: TextStyle(
              color: Color.fromRGBO(149, 69, 53, 1),
              fontSize: 25,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Stack(clipBehavior: Clip.none, children: [
              Image.asset('images/board.png'),
              _boardTiles(),
            ]),
          ),
          const SizedBox(height: 20),
          const Text.rich(
              TextSpan(text: 'Developed By Flutter 2022, Updated in 2023')),
        ],
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tileDimension = boardDimension / 3;

      return SizedBox(
        width: boardDimension,
        height: boardDimension,
        child: Column(
          children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;

            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return BoardTile(
                    dimension: tileDimension,
                    onPressed: () => _updateTileStateForIndex(tileIndex),
                    tileState: tileState);
              }).toList(),
            );
          }).toList(),
        ),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });
      final winner = _findWinner();
      if (winner != null) {
        _showWinnerDialog(winner);
      }
    }
  }

  TileState? _findWinner() {
    winnerForMatch(a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return null;
    }

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];
    TileState? winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != null) {
        winner = checks[i];
        break;
      }
    }
    return winner;
  }

  void _showWinnerDialog(TileState tileState) {
    showAdaptiveDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog.adaptive(
            elevation: 40,
            backgroundColor: const Color.fromRGBO(245, 222, 179, 1),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            shadowColor: const Color.fromRGBO(149, 69, 53, 1),
            title: const Center(
                child: Text(
              'Winner',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Color.fromRGBO(149, 69, 53, 1),
              ),
            )),
            content: Image.asset(
                tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                    onPressed: _resetGame,
                    child: const Text(
                      'New Game',
                      style: TextStyle(
                          color: Color.fromRGBO(149, 69, 53, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    )),
              )
            ],
          );
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
    Navigator.of(context).pop();
  }

  void _returnGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }
}
