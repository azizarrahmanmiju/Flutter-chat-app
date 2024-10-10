import 'package:flutter/material.dart';

class Singlelist extends StatelessWidget {
  final String image;
  final String name;
  const Singlelist({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 240, 255, 247),
              Color.fromARGB(255, 250, 245, 239),
            ]),
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(183, 197, 196, 196),
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(0, 5),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  image,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "${name}",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              )
            ],
          ),
        ),
      ),
    );
  }
}
