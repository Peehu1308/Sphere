import 'package:flutter/material.dart';

class MusicBox extends StatefulWidget {
  final int index;
  const MusicBox({super.key,required this.index});

  @override
  State<MusicBox> createState() => _MusicBoxState();
}

class _MusicBoxState extends State<MusicBox> {
  final List<Color> MusicBoxColors = [
    Color.fromARGB(255, 150, 127, 161),
    Color.fromARGB(255, 139, 115, 126),
    Color(0xFFF2B79F),
    Color(0xFF3E92CC),
    Color(0xFF0A2463),
  
  ];
  @override
  Widget build(BuildContext context) {
    final color=MusicBoxColors[widget.index % MusicBoxColors.length];
    return Padding(
      padding: const EdgeInsets.only(top:4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 80,
        decoration: BoxDecoration(color: color),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/album.jpg",height: 50,width: 50,),
                    const SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Music Title ${widget.index + 1}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text("Artist Name ${widget.index + 1}",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ),
      
          ],
        ),
      ),
    );
  }
}
