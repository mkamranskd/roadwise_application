import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:roadwise_application/global/style.dart';


class JobDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //title: const Text('Job Details'),
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.bookmark_border_rounded, size: 20, color: Colors.black),
              onPressed: () {

              },
            ),
          ),
        ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.share_rounded, size: 20, color: Colors.black),
                onPressed: () {

                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage:
                      AssetImage('assets/profile_bg.png'), // Change with your image
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        const Text(
                          'Job Title',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Job Description",
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 30,
                              color: primaryBlueColor,
                            ),
                            Text(
                              "New York, USA",
                              style: TextStyle(
                                  color: primaryBlueColor, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: GestureDetector(
                                onTap: () {
                                  // Add navigation functionality here
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.money),
                                    ),
                                    title: const Text(
                                      'Salary',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    subtitle: Text(
                                      '40k - 50k',
                                      style: TextStyle(
                                          color: primaryBlueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: GestureDetector(
                                onTap: () {
                                  // Add navigation functionality here
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.shopping_bag_outlined),
                                    ),
                                    title: const Text(
                                      'Job Type',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    subtitle: Text(
                                      'Full - Time',
                                      style: TextStyle(
                                          color: primaryBlueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: GestureDetector(
                                onTap: () {
                                  // Add navigation functionality here
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.business),
                                    ),
                                    title: const Text(
                                      'Working Model',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    subtitle: Text(
                                      'Remote',
                                      style: TextStyle(
                                          color: primaryBlueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: GestureDetector(
                                onTap: () {
                                  // Add navigation functionality here
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.poll_sharp),
                                    ),
                                    title: const Text(
                                      'level',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    subtitle: Text(
                                      'Internship',
                                      style: TextStyle(
                                          color: primaryBlueColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('About This Job',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.',style: TextStyle(fontSize: 13,),),
                          SizedBox(height: 12),
                          Divider(),
                          Text('Job Description',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.',style: TextStyle(fontSize: 13,),),
                          SizedBox(height: 12),

                          Divider(),
                          Text('About Company',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.',style: TextStyle(fontSize: 13,),),
                          SizedBox(height: 12),


                          Divider(),
                          Text('Reviews',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Video provides a powerful way to help you prove your point. When you click Online Video, you can paste in the embed code for the video you want to add. You can also type a keyword to search online for the video that best fits your document.',style: TextStyle(fontSize: 13,),),
                          SizedBox(height: 12),





                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FadeInUp(
              duration: const Duration(milliseconds: 1900),
              child: ElevatedButton(
                onPressed: () {
                  // Add your onPressed function here
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, backgroundColor: primaryBlueColor, // Use the desired color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Apply Now",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )

          ),


        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: JobDetailsScreen(),
  ));
}




