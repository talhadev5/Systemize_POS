import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/widgets/custom_loader.dart';
import 'package:systemize_pos/utils/extensions/string_extension.dart';

// ignore: must_be_immutable
// class CustomCartListview extends StatelessWidget {
//   final String image;
//   final String productName;
//   String productVariation;
//   final String productPrice;
//   final VoidCallback? onDelete;
//   final VoidCallback? onIncrease;
//   final VoidCallback? onDecrease;
//   int? quantity;
//   String addonProduct;
//   String addonPrice;
//   String variationPrice;

//   CustomCartListview({
//     super.key,
//     required this.image,
//     required this.productName,
//     required this.productVariation,
//     required this.productPrice,
//     this.onDelete,
//     this.onDecrease,
//     this.onIncrease,
//     this.quantity,
//     required this.addonProduct,
//     required this.addonPrice,
//     required this.variationPrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: AppColors.customWhiteColor,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [
//           BoxShadow(
//             color: AppColors.customItemContainerShadowColor,
//             spreadRadius: 0,
//             blurRadius: 5,
//             offset: Offset(0, 0),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Image
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: CachedNetworkImage(
//                 imageUrl: image,
//                 // fit: BoxFit.cover,

//                 progressIndicatorBuilder: (context, url, downloadProgress) =>
//                     Center(
//                       child: CircularProgressIndicator(
//                           color: AppColors.customThemeColor,
//                           value: downloadProgress.progress),
//                     ),
//                 errorWidget: (context, url, error) =>
//                     Image.asset('assets/png/placeholder_image.png')),
//           ),
//           const SizedBox(width: 10),
//           // Column for text
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   productName,
//                   style: GoogleFonts.roboto(
//                     textStyle: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.customSearchTextColor),
//                   ),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: 'Price',
//                     style: GoogleFonts.roboto(
//                       textStyle: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         color: AppColors.customThemeColor,
//                       ),
//                     ),
//                     children: [
//                       TextSpan(
//                         text: ' Rs $productPrice',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.customBlackColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 productVariation.isNotEmpty
//                     ? Text.rich(
//                         TextSpan(
//                           text: productVariation,
//                           style: GoogleFonts.roboto(
//                             textStyle: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.customThemeColor,
//                             ),
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' Rs $variationPrice',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.customBlackColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : const SizedBox(),
//                 addonProduct.isNotEmpty
//                     ? Text.rich(
//                         TextSpan(
//                           text: addonProduct,
//                           style: GoogleFonts.roboto(
//                             textStyle: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.customThemeColor,
//                             ),
//                           ),
//                           children: [
//                             TextSpan(
//                               text: ' Rs $addonPrice',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.customBlackColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : const SizedBox()
//               ],
//             ),
//           ),

//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon:
//                     const Icon(Icons.delete, color: AppColors.customThemeColor),
//                 onPressed: onDelete,
//               ),
//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: onDecrease,
//                     child: Container(
//                       width: 25,
//                       height: 25,
//                       decoration: BoxDecoration(
//                           color: AppColors.customWhiteColor,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: AppColors.customThemeColor),
//                           boxShadow: const [
//                             BoxShadow(
//                                 offset: Offset(0, 6),
//                                 blurRadius: 17,
//                                 spreadRadius: 0,
//                                 color: AppColors.customItemContainerShadowColor)
//                           ]),
//                       child: const Icon(
//                         Icons.remove,
//                         color: AppColors.customThemeColor,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.02,
//                   ),

//                   Text(
//                     quantity.toString(),
//                     style: GoogleFonts.roboto(
//                         textStyle: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: AppColors.customSearchTextColor)),
//                   ),

//                   SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.02,
//                   ),
//                   GestureDetector(
//                     onTap: onIncrease,
//                     child: Container(
//                       width: 25,
//                       height: 25,
//                       decoration: BoxDecoration(
//                           color: AppColors.customWhiteColor,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: AppColors.customThemeColor),
//                           boxShadow: const [
//                             BoxShadow(
//                                 offset: Offset(0, 6),
//                                 blurRadius: 17,
//                                 spreadRadius: 0,
//                                 color: AppColors.customItemContainerShadowColor)
//                           ]),
//                       child: const Icon(
//                         Icons.add,
//                         color: AppColors.customThemeColor,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                   // SizedBox(
//                   //   width: MediaQuery.of(context).size.width * 0.03,
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class CustomCartListview extends StatelessWidget {
  final String image;
  final String productName;
  final String productVariation;
  final String productPrice;
  final String variationPrice;
  final String addonProduct;
  final String addonPrice;
  final int quantity;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const CustomCartListview({
    super.key,
    required this.image,
    required this.productName,
    required this.productVariation,
    required this.productPrice,
    required this.variationPrice,
    required this.addonProduct,
    required this.addonPrice,
    required this.quantity,
    this.onDelete,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => const DefultLoader(size: 20),
              errorWidget:
                  (context, url, error) => Image.network(
                    'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=400&q=80',
                  ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),

                // Variation section
                if (productVariation.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.tune,
                        size: 16,
                        color: AppColors.customThemeColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            children: [
                              // const TextSpan(text: "Variation: "),
                              TextSpan(
                                text: productVariation.toString().capitalize(),
                                style: const TextStyle(
                                  color: AppColors.customThemeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: " | "),
                              TextSpan(
                                text: "Rs $variationPrice",
                                style: const TextStyle(
                                  color: AppColors.customBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                // Add-on Section
                if (addonProduct.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        size: 16,
                        color: AppColors.customThemeColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            children: [
                              // const TextSpan(text: "Add-ons: "),
                              TextSpan(
                                text:
                                    addonProduct
                                        .toString()
                                        .capitalizeEachWord(),
                                style: const TextStyle(
                                  color: AppColors.customThemeColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                              const TextSpan(text: " | "),
                              TextSpan(
                                text: "Rs $addonPrice",
                                style: const TextStyle(
                                  color: AppColors.customBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Quantity & Delete Controls
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
              Row(
                children: [
                  // Decrease
                  GestureDetector(
                    onTap: onDecrease,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(Icons.remove, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Increase
                  GestureDetector(
                    onTap: onIncrease,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(Icons.add, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
