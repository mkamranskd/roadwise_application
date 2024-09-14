import 'package:flutter/material.dart';
import 'package:roadwise_application/const/app_const.dart';
import 'package:roadwise_application/features/domain/entities/network_data.dart';
import 'package:roadwise_application/features/presentation/pages/my_network_page/widgets/single_network_card_widget.dart';

import 'package:roadwise_application/global/style.dart';

class MyNetworkPage extends StatefulWidget {
  const MyNetworkPage({Key? key}) : super(key: key);

  @override
  State<MyNetworkPage> createState() => _MyNetworkPageState();
}

class _MyNetworkPageState extends State<MyNetworkPage> {
  final networkData = NetworkDataClass.networkData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.person_add_alt_1_rounded),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              sizeVer(15),
              _rowWidget(
                  text: "Manage my Network", icon: Icons.arrow_forward_rounded),
              sizeVer(5),
              const Divider(
                thickness: 7,
              ),
              _rowWidget(text: "Invitations", icon: Icons.arrow_forward_rounded),
              const Divider(
                thickness: 7,
              ),
              sizeVer(5),
              const Text(
                "People you know who also follow Google",
                style: TextStyle(fontSize: 18),
              ),
              sizeVer(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    GridView.builder(
                      itemCount: networkData.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final network = networkData[index];
                        return SingleNetworkCardWidget(network: network);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _rowWidget({String? text, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$text",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: kPrimaryColor),
          ),
          Icon(icon),
        ],
      ),
    );
  }
}
