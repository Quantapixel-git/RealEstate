// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProductPage extends StatefulWidget {
//   final String id;
//   const EditProductPage({Key? key, required this.id}) : super(key: key);

//   @override
//   State<EditProductPage> createState() => _EditProductPageState();
// }

// class _EditProductPageState extends State<EditProductPage> {
//   final ImagePicker _picker = ImagePicker();

//   File? selectedImage;
//   File? additionalImage1;
//   File? additionalImage2;
//   bool _isLoading = false;
//   // Selected Category ID
//   int? selectedCategoryId;
//   ModelCategory? selectedValue;
//   Future<List<ModelCategory>>? _categoriesFuture;
//   // List of Categories
//   List<ModelCategory> categories = [];

//   // Controllers for the fields
//   TextEditingController categoryIdController = TextEditingController();
//   TextEditingController productNameController = TextEditingController();
//   TextEditingController productPriceController = TextEditingController();
//   TextEditingController productDiscountController = TextEditingController();
//   TextEditingController stockController = TextEditingController();
//   TextEditingController productDescriptionController = TextEditingController();

//   // Image URLs
//   String selectedImageUrl = '';
//   String additionalImage1Url = '';
//   String additionalImage2Url = '';

//   @override
//   void initState() {
//     super.initState();
//     _categoriesFuture = CategoryApiServices().fetchCategories();
//     _fetchProductData();
//   }

//   Future<void> _fetchProductData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final productData = await ProductService().fetchProductById(widget.id);
//       print(productData);

//       if (productData != null) {
//         categoryIdController.text = productData['category_id'] ?? '';
//         productNameController.text = productData['product_name'] ?? '';
//         productPriceController.text =
//             productData['product_price']?.toString() ?? '';
//         productDiscountController.text =
//             productData['product_discount']?.toString() ?? '';
//         stockController.text = productData['stock']?.toString() ?? '';
//         productDescriptionController.text =
//             productData['product_description'] ?? '';

//         // Check for the URLs of images
//         setState(() {
//           selectedImageUrl = productData['product_image_url'] ?? '';
//           additionalImage1Url = productData['additional_image_1_url'] ?? '';
//           additionalImage2Url = productData['additional_image_2_url'] ?? '';
//         });
//         print(selectedImageUrl);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to load product data')),
//         );
//       }
//     } catch (e) {
//       print("Error fetching product data: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching product data: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> pickImage({required int imageIndex}) async {
//     try {
//       final image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           if (imageIndex == 0) {
//             selectedImage = File(image.path);
//           } else if (imageIndex == 1) {
//             additionalImage1 = File(image.path);
//           } else if (imageIndex == 2) {
//             additionalImage2 = File(image.path);
//           }
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error selecting image: $e")),
//       );
//     }
//   }

//   Future<void> _EditProductPage() async {
//     if (selectedValue == null ||
//         productNameController.text.isEmpty ||
//         productPriceController.text.isEmpty ||
//         stockController.text.isEmpty ||
//         productDescriptionController.text.isEmpty ||
//         (selectedImage == null && selectedImageUrl.isEmpty)) {
//       // Ensure main image is selected
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all required fields')),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Parse numeric values
//       final productPrice = double.tryParse(productPriceController.text) ?? 0.0;
//       final productDiscount =
//           double.tryParse(productDiscountController.text) ?? 0.0;
//       final stock = int.tryParse(stockController.text) ?? 0;

//       final response = await ProductService().editProduct(
//         productId: widget.id,
//         productImage: selectedImage ?? File(''),
//         additionalImage1: additionalImage1 ?? File(''),
//         additionalImage2: additionalImage2 ?? File(""),
//         categoryId: categoryIdController.text,
//         productName: productNameController.text,
//         productPrice: productPrice.toString(),
//         productDiscount: productDiscount.toString(),
//         stock: stock.toString(),
//         productDescription: productDescriptionController.text,
//       );

//       if (response?.statusCode == 200 || response?.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Product updated successfully')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Failed to update product. Status: ${response?.statusCode}')),
//         );
//       }
//     } catch (e) {
//       print("Error updating product: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hintText,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Product'),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 235, 235, 41),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: FutureBuilder<List<ModelCategory>>(
//                     future: _categoriesFuture,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Center(
//                           child: Text(
//                             'Error: ${snapshot.error}',
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         );
//                       } else if (snapshot.hasData) {
//                         final categories = snapshot.data!;
//                         for (int i = 0; i < categories.length; i++) {
//                           if (int.parse(categoryIdController.text) ==
//                               categories[i].id) {
//                             selectedValue = categories[i];
//                           }
//                         }

//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildDropdown<ModelCategory>(
//                               items: categories,
//                               selectedValue: selectedValue,
//                               hintText: "Select a Category",
//                               lable: "Category",
//                               itemDisplay: (product) =>
//                                   product.name, // Display product name
//                               onChanged: (newProduct) {
//                                 setState(() {
//                                   selectedValue = newProduct;
//                                 });
//                               },
//                             ),
//                             // _buildTextField(
//                             //   controller: categoryIdController,
//                             //   label: "Category ID",
//                             //   hintText: "Enter Category ID",
//                             // ),
//                             _buildTextField(
//                               controller: productNameController,
//                               label: "Product Name",
//                               hintText: "Enter Product Name",
//                             ),
//                             _buildTextField(
//                               controller: productPriceController,
//                               label: "Product Price",
//                               hintText: "Enter Product Price",
//                             ),
//                             _buildTextField(
//                               controller: productDiscountController,
//                               label: "Discounted Price",
//                               hintText: "Enter Discount Price",
//                             ),
//                             _buildTextField(
//                               controller: stockController,
//                               label: "Stock Quantity",
//                               hintText: "Enter Stock Quantity",
//                             ),
//                             _buildTextField(
//                               controller: productDescriptionController,
//                               label: "Product Description",
//                               hintText: "Enter Product Description",
//                             ),
//                             // _buildImagePicker(
//                             //   imageFile: selectedImage,
//                             //   imageUrl: selectedImageUrl,
//                             //   onTap: () => pickImage(imageIndex: 0),
//                             // ),
//                             // _buildImagePicker(
//                             //   imageFile: additionalImage1,
//                             //   imageUrl: additionalImage1Url,
//                             //   onTap: () => pickImage(imageIndex: 1),
//                             // ),
//                             // _buildImagePicker(
//                             //   imageFile: additionalImage2,
//                             //   imageUrl: additionalImage2Url,
//                             //   onTap: () => pickImage(imageIndex: 2),
//                             // ),
//                             const SizedBox(height: 20),
//                             Center(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     'Product Image (Required)',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   GestureDetector(
//                                     onTap: () => pickImage(
//                                         imageIndex:
//                                             0), // Adjust index as needed
//                                     child: Container(
//                                       height: screenHeight * 0.2,
//                                       width: screenWidth * 0.6,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                             color: Colors.grey, width: 2),
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       child: selectedImage != null
//                                           ? ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                               child: Image.file(
//                                                 selectedImage!,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             )
//                                           : (selectedImageUrl.isNotEmpty
//                                               ? ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                   child: Image.network(
//                                                     selectedImageUrl,
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder: (context,
//                                                         error, stackTrace) {
//                                                       return const Icon(
//                                                           Icons.broken_image,
//                                                           size: 50);
//                                                     },
//                                                   ),
//                                                 )
//                                               : const Center(
//                                                   child: Icon(
//                                                     Icons.add_a_photo,
//                                                     size: 50,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 )),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             ),
//                             Center(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     'Additonal Product Image ',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: const Color.fromARGB(255, 0, 0, 0),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   GestureDetector(
//                                     onTap: () => pickImage(imageIndex: 1),
//                                     child: Container(
//                                       height: screenHeight * 0.2,
//                                       width: screenWidth * 0.6,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                             color: Colors.grey, width: 2),
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       child: additionalImage2 != null
//                                           ? ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                               child: Image.file(
//                                                 additionalImage1!,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             )
//                                           : (additionalImage1Url.isNotEmpty
//                                               ? ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                   child: Image.network(
//                                                     additionalImage1Url,
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder: (context,
//                                                         error, stackTrace) {
//                                                       return const Icon(
//                                                           Icons.broken_image,
//                                                           size: 50);
//                                                     },
//                                                   ),
//                                                 )
//                                               : const Center(
//                                                   child: Icon(
//                                                     Icons.add_a_photo,
//                                                     size: 50,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 )),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             ),
//                             Center(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     'Additional Product Image',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: const Color.fromARGB(255, 0, 0, 0),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   GestureDetector(
//                                     onTap: () => pickImage(imageIndex: 2),
//                                     child: Container(
//                                       height: screenHeight * 0.2,
//                                       width: screenWidth * 0.6,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                             color: Colors.grey, width: 2),
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       child: additionalImage2 != null
//                                           ? ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(15),
//                                               child: Image.file(
//                                                 additionalImage2!,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             )
//                                           : (additionalImage2Url.isNotEmpty
//                                               ? ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(15),
//                                                   child: Image.network(
//                                                     additionalImage2Url,
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder: (context,
//                                                         error, stackTrace) {
//                                                       return const Icon(
//                                                           Icons.broken_image,
//                                                           size: 50);
//                                                     },
//                                                   ),
//                                                 )
//                                               : const Center(
//                                                   child: Icon(
//                                                     Icons.add_a_photo,
//                                                     size: 50,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 )),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 30),
//                             Center(
//                               child: ElevatedButton(
//                                 onPressed: _EditProductPage,
//                                 child: const Text('Update Product'),
//                               ),
//                             ),
//                           ],
//                         );
//                       }
//                       return Container();
//                     }),
//               ),
//             ),
//     );
//   }

//   Widget _buildDropdown<T>({
//     required List<T> items, // List of dropdown items
//     required T? selectedValue, // Currently selected value
//     required ValueChanged<T?> onChanged, // Callback for value changes
//     required String hintText, // Placeholder text
//     required String lable, // Label text
//     String Function(T)? itemDisplay, // Optional function to display item text
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: DropdownButtonFormField<T>(
//         value: selectedValue,
//         decoration: InputDecoration(
//           hintText: hintText,
//           labelText: lable,
//           border: OutlineInputBorder(),
//         ),
//         items: items.map((T value) {
//           return DropdownMenuItem<T>(
//             value: value,
//             child: Text(
//               itemDisplay != null ? itemDisplay(value) : value.toString(),
//             ), // Display customized or default text
//           );
//         }).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
