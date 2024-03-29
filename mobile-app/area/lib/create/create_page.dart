import 'package:area/setupuser.dart';
import 'package:flutter/material.dart';

import 'package:area/search_page.dart';
import 'package:area/page_title.dart';
import 'package:area/request_classes/area.dart';
import 'package:area/request_classes/serviceWithId.dart';
import 'package:area/tools/get_image.dart';
import 'package:area/tools/fetchServiceWithId.dart';
import 'package:area/create/validation_page.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final USerInfo user = new USerInfo();
  bool hasUserChosenAction = false;
  List<AreaData> selectedAreas = [];
  int nmSelectedAreas = 0;

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SearchPage(
                true,
                hasUserChosenAction,
              )),
    );
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
    selectedAreas.add(result);
    nmSelectedAreas++;
    setState(() {
      hasUserChosenAction = true;
    });
  }

  Future<Image> getImageOfService(int serviceId) async {
    ServiceWithId selectedAreasService = await fetchServiceWithId(serviceId);
    Image serviceIcon =
        await getImage(selectedAreasService.data!.icon!, BoxFit.contain);
    return serviceIcon;
  }

  Widget getContinueButton(int nmSelectedAreas) {
    if (nmSelectedAreas >= 2) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ValidationPage(selectedAreas)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: const Text(
                'Continuer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          PageTitle('Créer'),
          Container(
            padding: EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
            ),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int indexSeparator) {
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: Colors.black,
                      width: 10,
                      thickness: 3,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: nmSelectedAreas + 1,
              itemBuilder: (BuildContext context, int index) {
                if (nmSelectedAreas == 0) {
                  return InkWell(
                    onTap: () {
                      _navigateAndDisplaySelection(context);
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
                                child: CardText(nmSelectedAreas, index)),
                            AddButton(),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (nmSelectedAreas == index) {
                  return InkWell(
                    onTap: () {
                      _navigateAndDisplaySelection(context);
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
                              child: CardText(nmSelectedAreas, index),
                            ),
                            Flexible(child: AddButton())
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    color: Colors.black,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: CardText(nmSelectedAreas, index),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: FutureBuilder<Image>(
                                future: getImageOfService(
                                    selectedAreas[index].serviceId!),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!;
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      '${snapshot.error}',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${selectedAreas[index].description}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 80),
          getContinueButton(nmSelectedAreas),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    );
  }
}

class CardText extends StatelessWidget {
  CardText(this.nmSelectedAreas, this.index);

  final int nmSelectedAreas;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (nmSelectedAreas == 0 && index == 0) {
      return Text('If This',
          style: TextStyle(color: Colors.white, fontSize: 50));
    } else if (index == 0) {
      return Text('If', style: TextStyle(color: Colors.white, fontSize: 50));
    } else {
      return Text('Then', style: TextStyle(color: Colors.white, fontSize: 50));
    }
  }
}
