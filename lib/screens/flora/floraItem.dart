import 'package:flora/models/floraModel.dart';
import 'package:flora/screens/flora/floraDetail.dart';
import 'package:flutter/material.dart';

class FloraItem extends StatelessWidget {
  const FloraItem({super.key, required this.floraData});

  final Flora floraData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FloraDetail(floraData: floraData)));
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          borderOnForeground: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              children: [
                Image.network(
                  floraData.image,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(floraData.title,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '₹ ${floraData.amount}.00',
                      style: Theme.of(context).textTheme.titleLarge,
                    ) //.toStringAsFixed(2)
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        alignment: Alignment.bottomLeft,
                        child: Text(floraData.desc,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text('Buy Now',
                              style: Theme.of(context).textTheme.titleMedium))
                    ])
              ],
            ),
          ),
        ));
  }
}
