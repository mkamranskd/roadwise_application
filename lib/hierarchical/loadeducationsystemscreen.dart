import 'package:flutter/material.dart';
import 'package:org_chart/org_chart.dart';
import 'package:roadwise_application/global/style.dart';

class EducationalChart extends StatefulWidget {
  const EducationalChart({super.key});

  @override
  State<EducationalChart> createState() => _EducationalChartState();
}

class _EducationalChartState extends State<EducationalChart> {
  final OrgChartController<Map> orgChartController = OrgChartController<Map>(
    boxSize: const Size(300, 80),
    items: [
      {
        "id": '0',
        "text": 'Education System',
      },
      {
        "id": '1',
        "text": 'Pre-Primary Education',
        "to": '0',
      },
      {
        "id": '2',
        "text": 'Primary Education',
        "to": '0',
      },
      {
        "id": '3',
        "text": 'Middle Education',
        "to": '0',
      },
      {
        "id": '4',
        "text": 'Secondary Education (Matriculation)',
        "to": '0',
      },
      {
        "id": '5',
        "text": 'Higher Secondary Education (Intermediate)',
        "to": '0',
      },
      {
        "id": '6',
        "text": 'Tertiary Education (Undergraduate)',
        "to": '0',
      },
      {
        "id": '7',
        "text": 'Postgraduate Education',
        "to": '0',
      },
      {
        "id": '8',
        "text": 'Technical and Vocational Education',
        "to": '0',
      },
      {
        "id": '9',
        "text": 'Madrasah Education',
        "to": '0',
      },
      {
        "id": '10',
        "text": 'Age Group: 3-5 years',
        "to": '1',
      },
      {
        "id": '11',
        "text": 'Levels: Nursery, Kindergarten (KG)',
        "to": '1',
      },
      {
        "id": '12',
        "text": 'Age Group: 5-10 years',
        "to": '2',
      },
      {
        "id": '13',
        "text": 'Classes: Grade 1 ,2 ,3 ,4 ,5 ,6)',
        "to": '2',
      },
      {
        "id": '14',
        "text": 'Age Group: 11-13 years',
        "to": '3',
      },
      {
        "id": '15',
        "text": 'Classes: Grade 6 ,7 ,8)',
        "to": '3',
      },
      {
        "id": '16',
        "text": 'Age Group: 14-16 years',
        "to": '4',
      },
      {
        "id": '17',
        "text": 'Classes: Grade 9 ,10)',
        "to": '4',
      },
      {
        "id": '18',
        "text": 'Examination: SSC Part I, SSC Part II',
        "to": '4',
      },
      {
        "id": '19',
        "text": 'Streams: Science Group, Arts Group',
        "to": '4',
      },
      {
        "id": '20',
        "text": 'Age Group: 16-18 years',
        "to": '5',
      },
      {
        "id": '21',
        "text": 'Classes: Grade 11 (First Year/Intermediate Part I), Grade 12 (Second Year/Intermediate Part II)',
        "to": '5',
      },
      {
        "id": '22',
        "text": 'Examination: HSSC Part I, HSSC Part II',
        "to": '5',
      },
      {
        "id": '23',
        "text": 'Streams: Pre-Medical, Pre-Engineering, Computer Science, Commerce, Arts/Humanities',
        "to": '5',
      },
      {
        "id": '24',
        "text": 'Duration: Typically 2-4 years',
        "to": '6',
      },
      {
        "id": '25',
        "text": 'Degrees: Associate Degree, Bachelor\'s Degree',
        "to": '6',
      },
      {
        "id": '26',
        "text": 'Departments: Sciences, Engineering, Medical and Health Sciences, Business and Management, Social Sciences and Humanities, Arts and Design, Law',
        "to": '6',
      },
      {
        "id": '27',
        "text": 'Duration: Typically 2-3 years for Master’s, 4-6 years for PhD',
        "to": '7',
      },
      {
        "id": '28',
        "text": 'Degrees: Master’s Degree, Doctorate Degree',
        "to": '7',
      },
      {
        "id": '29',
        "text": 'Departments: Sciences, Engineering, Medicine, Business and Management, Social Sciences, Humanities, Law, Education',
        "to": '7',
      },
      {
        "id": '30',
        "text": 'Institutes: Technical Training Centers, Polytechnics',
        "to": '8',
      },
      {
        "id": '31',
        "text": 'Programs: Diploma of Associate Engineering, Vocational Training Certificates',
        "to": '8',
      },
      {
        "id": '32',
        "text": 'Fields: Electrical Technology, Mechanical Technology, Civil Technology, Information Technology, Automotive Technology, Health Technology',
        "to": '8',
      },
      {
        "id": '33',
        "text": 'Levels: Ibtedaiya, Mutawassitah, Sanawiyah Amma, Sanawiyah Khasa, Aalmiya',
        "to": '9',
      },
      {
        "id": '34',
        "text": 'Focus: Islamic studies, Quranic education, general education subjects',
        "to": '9',
      }
    ]
    ,
    idProvider: (data) => data["id"],
    toProvider: (data) => data["to"],
    toSetter: (data, newID) => data["to"] = newID,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                primaryBlueColor
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: OrgChart<Map>(
                    // graph: orgChartController,
                    cornerRadius: 0,
                    controller: orgChartController,
                    isDraggable: false,
                    linePaint: Paint()
                      ..color = Colors.black
                      ..strokeWidth = 5
                      ..style = PaintingStyle.stroke,
                    onTap: (item) {
                      orgChartController.addItem({
                        "id": orgChartController.uniqueNodeId,
                        "text": 'New Block',
                        "to": item["id"],
                      });
                      setState(() {});
                    },
                    onDoubleTap: (item) async {
                      String? text = await getBlockText(context, item);
                      if (text != null) setState(() => item["text"] = text);
                    },
                    builder: (details) {
                      return GestureDetector(
                        child: Card(
                          elevation: 5,
                          color: details.isBeingDragged
                              ? Colors.green.shade100
                              : details.isOverlapped
                              ? Colors.red.shade200
                              : Colors.teal.shade50,
                          child: Center(
                              child: Text(
                                details.item["text"],
                                style: TextStyle(
                                    color: Colors.purple.shade900, fontSize: 20),
                              )),
                        ),
                      );
                    },
                    optionsBuilder: (item) {
                      return [
                        const PopupMenuItem(
                            value: 'Remove', child: Text('Remove')),
                      ];
                    },
                    onOptionSelect: (item, value) {
                      if (value == 'Remove') {
                        orgChartController.removeItem(
                            item["id"], ActionOnNodeRemoval.unlink);
                      }
                    },
                    onDrop: (dragged, target, isTargetSubnode) {
                      if (isTargetSubnode) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'You cannot drop a node on a subnode'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ]);
                            });
                        orgChartController.calculatePosition();
                        orgChartController.orientation = OrgChartOrientation.topToBottom;

                        return;
                      }
                      dragged["to"] = target["id"];
                      orgChartController.calculatePosition();
                    },
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                      'Slide Left a little'),
                ),

                Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton( onPressed: () {

                      Navigator.pop(context);
                    },style:const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                    ),
                      icon: const Icon(Icons.arrow_back_ios_new),color: primaryBlueColor,)
                ),

              ],
            ),
            /*floatingActionButton: FloatingActionButton.extended(
                label: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                  //orgChartController.switchOrientation();
                }
              ),*/
          ),
        ),
      ],
    );
  }

  Future<String?> getBlockText(
      BuildContext context, Map<dynamic, dynamic> item) async {
    final String? text = await showDialog(
      context: context,
      builder: (context) {
        String text = item["text"];
        return AlertDialog(
          title: const Text('Enter Text'),
          content: TextFormField(
            initialValue: item["text"],
            onChanged: (value) {
              text = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(text);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return text;
  }
}