import 'package:flutter/material.dart';

import 'package:area/request_classes/area.dart';
import 'package:area/search_page.dart';

class IfCard extends StatefulWidget {
  final List<AreaData> selectedAreas;
  final int nmSelectedAreas;
  final int index;

  IfCard(this.selectedAreas, this.nmSelectedAreas, this.index, {super.key});

  @override
  State<IfCard> createState() => _IfCardState();
}

class _IfCardState extends State<IfCard> {


  @override
  Widget build(BuildContext context) {
    if (widget.nmSelectedAreas == 0) {
      return InkWell(
          onTap: () {
            // _navigateAndDisplaySelection(context);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.black,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      'If This',
                      style: TextStyle(color: Colors.white, fontSize: 60),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: const Text(
                          'Ajouter',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    } else if (widget.nmSelectedAreas == widget.index) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Center(
                  child: Text(
                    'Then That',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        child: Text('TEST'),
      );
    }
  }
}
