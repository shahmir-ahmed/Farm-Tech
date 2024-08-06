import 'dart:io';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:farm_tech/backend/model/product.dart';
import 'package:farm_tech/backend/model/user.dart';
import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/seller/shop/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadProductView extends StatefulWidget {
  const UploadProductView({super.key});

  @override
  State<UploadProductView> createState() => _UploadProductViewState();
}

class _UploadProductViewState extends State<UploadProductView> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String title = '';
  int price = 0;
  int stockQuantity = 0;
  int minOrder = 0;
  String category = '';
  String description = '';
  // product images file objects
  List<File?> productImages = [];
  // image error text
  String fileError = '';
  // dropdown error text
  String dropdownError = '';

  // product categories
  List<String> categories = [
    "Category",
    "Crops",
    "Forestry",
    "Livestock",
    "Dairy",
    "Fish Farming",
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();

  // product services instance
  final ProductServices _productServices = ProductServices();

  // return logged in user uid
  _getUserUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("uId") as String;
  }

  // select source to upload image i.e. gallery/camera
  void mediaPickerOptions(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Pic image from",
                    style: Utils.kAppHeading6BoldStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    primaryButton: true,
                    secondaryButton: false,
                    onButtonPressed: () {
                      // close this modal bottom sheet
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                    buttonText: "Camera",
                    buttonHeight: 50,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomButton(
                    primaryButton: true,
                    secondaryButton: false,
                    onButtonPressed: () {
                      // close this modal bottom sheet
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                    buttonText: "Gallery",
                    buttonHeight: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Pick image
  void pickImage(ImageSource imageType) async {
    try {
      // app crashes if heavy image is selected (so not more than 15mb image should be allowed to be uploaded)
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;

      const maxFileSize = 5 * 1024 * 1024; // 10 MB in bytes

      // if image size is more than 10mb show error
      if (File(photo.path).lengthSync() > maxFileSize) {
        // print('large image');
        floatingSnackBar(
            message:
                'The image you are trying to upload is too large. The maximum file size allowed is 5 MB. Please select a smaller image.',
            context: context,
            duration: const Duration(seconds: 6));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     duration: Duration(seconds: 6),
        //     content: Text(
        //         'The image you are trying to upload is too large. The maximum file size allowed is 10 MB.  Please select a smaller image.')));
        // return; (not closes the modal sheet so snackbar not visible so commented this)
      } else {
        // print('photo.path: ${photo.path}'); // jpg file

        // if image is less than or equal to 10MB
        // compress photo using flutter image compress package
        File? tempImage = await compressFile(File(photo.path));

        // if error compressing
        if (tempImage == null) tempImage = File(photo.path);

        // print(photo.path); // jpg file

        // print('tempImage.path: ${tempImage.path}');

        // update the image and error variable and notify the widget to update its state using setState
        setState(() {
          productImages.add(tempImage);
          fileError = '';
        });
      }

      // Close the image picker screen (but it closes the modal bottom sheet)
      // Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // flutter_image_compress
  // The flutter_image_compress package is fairly simple to use and it appears to be much better at actually reducing the file size.
  Future<File?> compressFile(File file) async {
    try {
      final filePath = file.absolute.path;

      // Create output file path with .jpg extension
      final outPath =
          "${filePath.substring(0, filePath.lastIndexOf('.'))}_out.jpg";

      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        format: CompressFormat.jpeg, // Ensure the format is set to JPEG
        quality: 25,
      );

      if (result == null) {
        print("Compression failed");
        return null;
      }

      print('Original file size: ${file.lengthSync()} bytes');
      result
          .length()
          .then((value) => print('Compressed file size: ${value} bytes'));

      return File(result.path);
    } catch (e) {
      print("Error in compressing image: $e");
      return null;
    }
  }

  // for carousel
  onPageChanged(index) {
    setState(() {
      _current = index;
    });
  }

  @override
  void initState() {
    category = categories[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar('Upload Product', [], context),
      backgroundColor: Utils.whiteColor,
      body: _getBody(),
    );
  }

  _getBody() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // space
      const SizedBox(
        height: 20,
      ),
      // pics
      productImages.isEmpty
          ?
          // empty box
          Container(
              color: const Color.fromARGB(255, 241, 241, 241),
              height: 200,
            )
          : ProductImagesCarousel(
              controller: _controller,
              onPageChanged: onPageChanged,
              productImages: productImages,
              current: _current,
              carouselHeight: 250,
              forUploadProductScreen: true,
            ),
      // space
      const SizedBox(
        height: 20,
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              // one by one image box selectable
              productImages.isEmpty
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // max 4 images
                      children: productImages.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () {
                            _controller.animateToPage(entry.key);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            width: 70,
                            height: 64,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Utils.lightGreyColor1)),
                            child: productImages.length >= entry.key + 1
                                ? Image.file(
                                    productImages[entry.key]!,
                                  )
                                : const SizedBox(),
                          ),
                        );
                      }).toList(),
                    ),

              // space
              const SizedBox(
                height: 30,
              ),

              // form
              Form(
                key: _formKey,
                child: Column(children: [
                  // upload photos field
                  DottedBorder(
                    // strokeWidth: 2,
                    color: fileError.isEmpty
                        ? Utils.greenColor
                        : const Color.fromARGB(255, 180, 44, 44),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [7, 7],
                    child: GestureDetector(
                      onTap: productImages.length == 4
                          ? () {
                              floatingSnackBar(
                                  message: 'Maximum four images allowed',
                                  context: context);
                            }
                          : () {
                              // remove focus from last text field filled
                              FocusScope.of(context).unfocus();
                              mediaPickerOptions(context);
                            },
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width - 53,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // text
                              Text(
                                'Upload Photos',
                                style: Utils.kAppBody3RegularStyle,
                              ),

                              // upload icon
                              Image.asset(
                                'assets/images/upload-icon.png',
                                width: 24,
                                height: 24,
                              )
                            ],
                          )),
                    ),
                  ),

                  fileError.isNotEmpty
                      ? const SizedBox(
                          height: 5.0,
                        )
                      : const SizedBox(),

                  // file error text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // space
                      const SizedBox(width: 25),
                      Text(
                        fileError,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 180, 44, 44),
                            fontSize: 12),
                      ),
                    ],
                  ),

                  fileError.isNotEmpty
                      ? const SizedBox(
                          height: 20.0,
                        )
                      : const SizedBox(),

                  // space
                  const SizedBox(
                    height: 12.0,
                  ),

                  // title field
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    // onFieldSubmitted: (_) {
                    //   FocusScope.of(context).nextFocus();
                    // },
                    onChanged: (value) {
                      setState(() {
                        title = value.trim();
                      });
                    },
                    decoration:
                        Utils.inputFieldDecoration.copyWith(hintText: 'Title'),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                    style: Utils.kAppBody3MediumStyle,
                  ),

                  // space
                  const SizedBox(
                    height: 30.0,
                  ),

                  // price field
                  TextFormField(
                    // focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        price = int.parse(value);
                      });
                    },
                    decoration:
                        Utils.inputFieldDecoration.copyWith(hintText: 'Price'),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Price is required';
                      }
                      return null;
                    },
                    style: Utils.kAppBody3MediumStyle,
                  ),

                  // space
                  const SizedBox(
                    height: 30.0,
                  ),

                  // stock quantity field
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        stockQuantity = int.parse(value);
                      });
                    },
                    decoration: Utils.inputFieldDecoration
                        .copyWith(hintText: 'Stock Quantity'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Stock quantity is required';
                      } else if (int.parse(value) < 1) {
                        return 'Stock quantity must be greater than 0';
                      }
                      return null;
                    },
                    style: Utils.kAppBody3MediumStyle,
                  ),

                  // space
                  const SizedBox(
                    height: 30.0,
                  ),

                  // minimum order field
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        minOrder = int.parse(value);
                      });
                    },
                    decoration: Utils.inputFieldDecoration.copyWith(
                      hintText: 'Min Order',
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Minimum order is required';
                      }
                      return null;
                    },
                    style: Utils.kAppBody3MediumStyle,
                  ),

                  // space
                  const SizedBox(
                    height: 30.0,
                  ),

                  // category dropdown field
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 13),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: dropdownError.isNotEmpty
                                ? const Color.fromARGB(255, 180, 44, 44)
                                : Utils.lightGreyColor1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Theme(
                      data: ThemeData(highlightColor: Utils.whiteColor),
                      child: DropdownButton<String>(
                        dropdownColor: Utils.whiteColor,
                        value: category,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Utils.lightGreyColor1,
                        ),
                        // elevation: 16,
                        style: Utils.kAppBody3RegularStyle,
                        underline: const SizedBox(
                          height: 0,
                        ),
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            category = value!;
                          });
                        },
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Utils.kAppBody3MediumStyle.copyWith(
                                  color: value == "Category"
                                      ? Utils.lightGreyColor1
                                      : Utils.blackColor2),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  dropdownError.isNotEmpty
                      ? const SizedBox(
                          height: 5.0,
                        )
                      : const SizedBox(),

                  // dropdown error
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // space
                      const SizedBox(width: 25),
                      Text(
                        dropdownError,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 180, 44, 44),
                            fontSize: 12),
                      ),
                    ],
                  ),

                  fileError.isNotEmpty
                      ? const SizedBox(
                          height: 20.0,
                        )
                      : const SizedBox(),

                  // space
                  const SizedBox(
                    height: 12.0,
                  ),

                  // description field
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 5,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    onChanged: (value) {
                      setState(() {
                        description = value.trim();
                      });
                    },
                    decoration: Utils.inputFieldDecoration
                        .copyWith(hintText: 'Description'),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                    style: Utils.kAppBody3MediumStyle,
                  ),

                  // space
                  const SizedBox(
                    height: 30,
                  ),

                  // upload button
                  CustomButton(
                    primaryButton: true,
                    secondaryButton: false,
                    onButtonPressed: () async {
                      // single image is not present
                      if (productImages.isEmpty) {
                        setState(() {
                          fileError = "Minimum one image is required";
                        });
                      }
                      // category value is not selected
                      if (category == categories[0]) {
                        setState(() {
                          dropdownError = "Category is required";
                        });
                      }
                      // form is valid and dropdown value is selected and at least one image is present
                      if (_formKey.currentState!.validate() &&
                          productImages.isNotEmpty &&
                          category != categories[0]) {
                        // for (var productImage in productImages) {
                        //   print(productImage!.path);
                        // }
                        // print(title);
                        // print(price);
                        // print(stockQuantity);
                        // print(minOrder);
                        // print(category);
                        // print(description);

                        // show loading alert dialog
                        Utils.showLoadingAlertDialog(context, 'upload_product');

                        final uId =
                            await _getUserUid(); // get user uid from shared pref

                        // create new product doc with seller id of the logged in user
                        final result = await _productServices.createProductDoc(
                            ProductModel(
                                title: title,
                                price: price,
                                stockQuantity: stockQuantity,
                                minOrder: minOrder,
                                category: category,
                                description: description,
                                imagesCount: productImages.length,
                                sellerId: uId));

                        // upload images
                        // images wont be uploaded if creating document error occured
                        // error
                        if (result == null) {
                          // close alert
                          Navigator.pop(context);

                          // show snackbar
                          floatingSnackBar(
                              message:
                                  'Unable to upload product please try again later.',
                              context: context);
                        } else {
                          print('product doc created');

                          // if only one image
                          if (productImages.length == 1) {
                            // upload product image
                            final result2 =
                                await _productServices.uploadProductImage(
                                    result, productImages[0]!.path);

                            // error
                            if (result2 == null) {
                              // close alert
                              Navigator.pop(context);

                              // show snackbar
                              floatingSnackBar(
                                  message:
                                      'Error uploading image. Please try later.',
                                  context: context);
                            }
                            // success
                            else {
                              // close alert
                              Navigator.pop(context);

                              // show snackbar
                              floatingSnackBar(
                                  message: 'Product uploaded successfully.',
                                  context: context);

                              // close screen
                              Navigator.pop(context);
                            }
                          }
                          // if more than one image
                          else {
                            List<String?> result2 =
                                []; // image uploading results returned list

                            // loop less than size
                            for (int i = 0; i < productImages.length; i++) {
                              // upload each image
                              var result3 =
                                  await _productServices.uploadProductImage(
                                      '${result}_${i + 1}',
                                      productImages[i]!.path);

                              result2.add(
                                  result3); // adding all results one by one
                            }
                            // if results list contains any error
                            if (result2.contains(null)) {
                              for (var i = 0; i < result2.length; i++) {
                                // close alert
                                Navigator.pop(context);

                                // show snackbar
                                floatingSnackBar(
                                    message:
                                        'Error uploading product image ${result2.indexOf(null) + 1}.',
                                    context: context);
                              }
                            } else {
                              // close alert
                              Navigator.pop(context);

                              // show snackbar
                              // success no error
                              floatingSnackBar(
                                  message: 'Product uploaded successfully',
                                  context: context);

                              // close screen
                              Navigator.pop(context);
                            }
                          }
                        }
                      }
                    },
                    buttonText: 'Upload',
                    buttonWidth: MediaQuery.of(context).size.width,
                    buttonHeight: 70,
                  ),

                  // space
                  const SizedBox(
                    height: 10,
                  ),
                ]),
              )
            ],
          )),
    ]));
  }
}
