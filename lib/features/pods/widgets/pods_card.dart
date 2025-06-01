import 'package:adhikar/features/pods/views/pods.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';

class PodsCard extends StatelessWidget {
   final String podName;
   final String podBanner;
  final String podImage;
 
  final String podDescription;
  
  const PodsCard({super.key, required this.podImage, required this.podName, required this.podDescription, required this.podBanner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PodsView(
            podBanner: podBanner,
            podDescription: podDescription,
            podTitle: podName,
            podimage: podImage,
          );
        })),
        child: Card(
          color: const Color.fromARGB(255, 20, 20, 40),
          child: Container(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(
                      podImage,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(podName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(podDescription,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              color: Pallete.greyColor,
                              fontWeight: FontWeight.bold
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}