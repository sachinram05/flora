import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flora/providers/floraProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloraDetail extends ConsumerStatefulWidget {
  const FloraDetail({super.key, required this.floraData});

  final floraData;

  @override
  ConsumerState<FloraDetail> createState() => _FloraDetailState();
}

class _FloraDetailState extends ConsumerState<FloraDetail> {
  var florfireData;

  late String id;
  late String title;
  late String desc;
  late String image;
  late String amount;
  late String place;
  var favorite;

  mainFloraData() async {
    try {
      await FirebaseFirestore.instance
          .collection('flora')
          .doc(widget.floraData.id)
          .get()
          .then((snap) => {
                if (snap.exists)
                  {
                    setState(() {
                      setState(() {
                        id = snap.data()!['id'];
                        title = snap.data()!['floraName'];
                        desc = snap.data()!['description'];
                        image = snap.data()!['image_url'];
                        amount = snap.data()!['amount'];
                        place = snap.data()!['place'];
                        favorite = snap.data()!['favorite'];
                      });
                    })
                  },
              });
    } catch (error) {
       ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details access failed!'))); 
    }
  }

  void onFavoriteHandler() async {
    setState(() {
      favorite = !favorite;
    });
    try {
      await ref.watch(floraProvider).editFlora(favorite, widget.floraData.id);
      await mainFloraData();

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(favorite
              ? 'Flora added as a favorite'
              : 'flora removed as a favorite')));
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(favorite
              ? 'Flora not added as a favorite,try again'
              : 'flora not removed as a favorite ,try again')));
    }
  }

  @override
  void initState() {
    mainFloraData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.floraData.title),
          actions: [
            IconButton(
                onPressed: onFavoriteHandler,
                icon: Icon(
                  favorite ?? widget.floraData.favorite
                      ? Icons.star
                      : Icons.star_border,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ))
          ],
        ),
        body: Card(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.network(
                        widget.floraData.image,
                        fit: BoxFit.fill,
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.floraData.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.star,
                              color: Color.fromRGBO(252, 185, 14, 0.914)),
                          Icon(Icons.star,
                              color: Color.fromRGBO(252, 185, 14, 0.914)),
                          Icon(Icons.star,
                              color: Color.fromRGBO(252, 185, 14, 0.914)),
                          Icon(Icons.star,
                              color: Color.fromRGBO(252, 185, 14, 0.914)),
                          Icon(
                            Icons.star_border,
                            color: Color.fromRGBO(252, 185, 14, 0.914),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.floraData.place,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const Icon(
                                Icons.location_on_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ]),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee_sharp,
                              size: 24,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text('${widget.floraData.amount}.00',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge) //.toStringAsFixed(2)
                          ],
                        )
                      ]),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(widget.floraData.desc,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Buy Now',
                            style: Theme.of(context).textTheme.titleLarge)),
                  )
                ],
              ),
            )));
  }
}
