// import 'package:flutter/material.dart';
// import 'package:read_zone_app/store/pages/checkout_sheet.dart';
// import 'package:read_zone_app/themes/colors.dart';
// import '../models/book_model.dart';

// class BookDetailPage extends StatefulWidget {
//   final Book book;

//   const BookDetailPage({super.key, required this.book});

//   @override
//   _BookDetailPageState createState() => _BookDetailPageState();
// }

// class _BookDetailPageState extends State<BookDetailPage> {
//   int quantity = 1;
//   bool isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 270,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                       offset: const Offset(0, -5),
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: Image.network(
//                         widget.book.coverImageUrl,
//                         height: 220,
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) =>
//                             Icon(Icons.broken_image),
//                       ),

//                       // child: Image.asset(
//                       //   widget.book.imagepath,
//                       //   height: 220,
//                       //   fit: BoxFit.contain,
//                       // ),
//                     ),
//                     Positioned(
//                       top: 15,
//                       left: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back, color: Colors.black),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(widget.book.title,
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold)),
//                         Text(widget.book.author,
//                             style: TextStyle(
//                                 fontSize: 14, color: getTextColor2(context))),
//                       ],
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: getRedColor(context),
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isFavorite = !isFavorite;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         IconButton(
//                           icon:
//                               Icon(Icons.remove, color: getTextColor2(context)),
//                           onPressed: () {
//                             if (quantity > 1) {
//                               setState(() {
//                                 quantity--;
//                               });
//                             }
//                           },
//                         ),
//                         Text(quantity.toString(),
//                             style: const TextStyle(fontSize: 18)),
//                         IconButton(
//                           icon: Icon(Icons.add, color: getRedColor(context)),
//                           onPressed: () {
//                             setState(() {
//                               quantity++;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     Text("\$${widget.book.price.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Product Detail",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Text(
//                       widget.book.description,
//                       style: TextStyle(
//                           fontSize: 14, color: getTextColor2(context)),
//                       // maxLines: 4,
//                       // overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Center(
//                   child: SizedBox(
//                     width: 350,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: getRedColor(context),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       onPressed: () {
//                         showModalBottomSheet(
//                           context: context,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.vertical(top: Radius.circular(30)),
//                           ),
//                           isScrollControlled: true,
//                           builder: (context) =>
//                               CheckoutBottomSheet(price: widget.book.price),
//                         );
//                       },
//                       child: Text("Go to Checkout",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: getTextColor2(context))),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:read_zone_app/store/pages/checkout_sheet.dart';
// import 'package:read_zone_app/themes/colors.dart';
// import '../models/book_model.dart';

// class BookDetailPage extends StatefulWidget {
//   final Book book;

//   const BookDetailPage({super.key, required this.book});

//   @override
//   _BookDetailPageState createState() => _BookDetailPageState();
// }

// class _BookDetailPageState extends State<BookDetailPage> {
//   int quantity = 1;
//   bool isFavorite = false;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 270,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                       offset: const Offset(0, -5),
//                     ),
//                   ],
//                 ),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: Image.network(
//                         widget.book.coverImageUrl,
//                         height: 220,
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) =>
//                             Icon(Icons.broken_image),
//                       ),
//                     ),
//                     Positioned(
//                       top: 15,
//                       left: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back, color: Colors.black),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(widget.book.title,
//                             style: const TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold)),
//                         Text(widget.book.author,
//                             style: TextStyle(
//                                 fontSize: 14, color: getTextColor2(context))),
//                       ],
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: getRedColor(context),
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           isFavorite = !isFavorite;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         IconButton(
//                           icon:
//                               Icon(Icons.remove, color: getTextColor2(context)),
//                           onPressed: () {
//                             if (quantity > 1) {
//                               setState(() {
//                                 quantity--;
//                               });
//                             }
//                           },
//                         ),
//                         Text(quantity.toString(),
//                             style: const TextStyle(fontSize: 18)),
//                         IconButton(
//                           icon: Icon(Icons.add, color: getRedColor(context)),
//                           onPressed: () {
//                             setState(() {
//                               quantity++;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     Text("\$${widget.book.price.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Product Detail",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Container(
//                       height: 120,
//                       child: SingleChildScrollView(
//                         child: Text(
//                           widget.book.description,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: getTextColor2(context),
//                           ),
//                           softWrap: true,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Center(
//                   child: SizedBox(
//                     width: 350,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: getRedColor(context),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       onPressed: () {
//                         showModalBottomSheet(
//                           context: context,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.vertical(top: Radius.circular(30)),
//                           ),
//                           isScrollControlled: true,
//                           builder: (context) =>
//                               CheckoutBottomSheet(price: widget.book.price),
//                         );
//                       },
//                       child: Text("Go to Checkout",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: getTextColor2(context))),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';

import '../models/book_model.dart';
import '../pages/purchash_book.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        widget.book.coverImageUrl,
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            widget.book.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(widget.book.author,
                            style: TextStyle(
                                fontSize: 14, color: getTextColor2(context))),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: getRedColor(context),
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // IconButton(
                        //   icon:
                        //       Icon(Icons.remove, color: getTextColor2(context)),
                        //   onPressed: () {
                        //     if (quantity > 1) {
                        //       setState(() {
                        //         quantity--;
                        //       });
                        //     }
                        //   },
                        // ),
                        // Text(quantity.toString(),
                        //     style: const TextStyle(fontSize: 18)),
                        // IconButton(
                        //   icon: Icon(Icons.add, color: getRedColor(context)),
                        //   onPressed: () {
                        //     setState(() {
                        //       quantity++;
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                    Text("\$${widget.book.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Product Detail",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.book.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: getTextColor2(context),
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    width: 350,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getRedColor(context),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      // onPressed: () {
                      //   showModalBottomSheet(
                      //     context: context,
                      //     shape: const RoundedRectangleBorder(
                      //       borderRadius:
                      //           BorderRadius.vertical(top: Radius.circular(30)),
                      //     ),
                      //     isScrollControlled: true,
                      //     builder: (context) =>
                      //         CheckoutBottomSheet(price: widget.book.price),
                      //   );
                      // },
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PurchaseBookScreen(
                              book: widget.book,
                            ),
                          ),
                        );
                      },

                      child: Text("Order Book",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: getTextColor2(context))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
