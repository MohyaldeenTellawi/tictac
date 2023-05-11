import 'package:flutter/material.dart';
import 'package:youtub7/tile_state.dart';

class BoardTile extends StatelessWidget {

  final TileState tileState;
  final double dimension;
  final VoidCallback onPressed;
  const BoardTile({Key? key,required this.dimension,required this.onPressed,
  required this.tileState
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dimension,height: dimension,child: TextButton(
      onPressed: onPressed,
      child: _widgetForTileState(),
    ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;

    switch(tileState){
      case TileState.EMPTY:{
        widget = Container();
      }break;

      case TileState.CROSS:{
        widget = Image.asset('images/x.png');
      }break;
      case TileState.CIRCLE:{
        widget = Image.asset('images/o.png');
      }break;
    }
    return widget;
  }
}
