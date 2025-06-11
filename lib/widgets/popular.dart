// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:read_zone_app/screens/book_details.dart';
// import '../data/models/popularbooks_model.dart';

// class Popularitems extends StatelessWidget {
//   final PopularBook book;

//   const Popularitems({super.key, required this.book});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _navigateToBookDetails,
//       child: SizedBox(
//         width: 150,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildBookCover(),
//             const SizedBox(height: 8),
//             _buildBookInfo(),
//             const SizedBox(height: 4),
//             _buildRating(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBookCover() {
//     return Container(
//       height: 180,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         image: DecorationImage(
//           image: book.coverImageUrl.isNotEmpty
//               ? NetworkImage(book.coverImageUrl)
//               : const AssetImage('assets/images/placeholder.png')
//                   as ImageProvider,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   Widget _buildBookInfo() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             book.title,
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//               height: 1.2,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 2),
//           Text(
//             book.authorName,
//             style: GoogleFonts.inter(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               color: Colors.black.withOpacity(0.7),
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRating() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: const Color(0xFFFF9A8C).withOpacity(0.2),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.star,
//               size: 12,
//               color: Color(0xFFFF9A8C),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               book.rating.toStringAsFixed(1),
//               style: GoogleFonts.inter(
//                 fontSize: 10,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToBookDetails() {
//     Get.to(
//       () => BookDetails(bookData: book.toJson()),
//       transition: Transition.fadeIn,
//       duration: const Duration(milliseconds: 300),
//     );
//   }
// }
