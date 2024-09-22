import 'package:farm_tech/backend/model/buyer.dart';
import 'package:farm_tech/backend/services/buyer_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeAddressView extends StatefulWidget {
  ChangeAddressView({required this.buyerModel});

  BuyerModel buyerModel; // buyer id model

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  final _formKey = GlobalKey<FormState>();

  final _addressFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar('Change Address', [], context),
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    // consume buyer address stream
    final buyerModel = Provider.of<BuyerModel?>(context);

    if (buyerModel != null) {
      // print('buyerAdress: ${buyerModel.address!}');
      _addressFieldController.text = buyerModel.address!;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // space
          SizedBox(
            height: 10,
          ),

          buyerModel == null
              ? SizedBox(
                  height: 100,
                  child: Center(
                    child: Utils.circularProgressIndicator,
                  ),
                )
              :

              // input field
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // address field with initial value as current address
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _addressFieldController,
                        decoration: Utils.inputFieldDecoration
                            .copyWith(hintText: "Address"),
                        minLines: 4,
                        maxLines: 4,
                        style: Utils.kAppBody3MediumStyle,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Address is required';
                          } else {
                            return null;
                          }
                        },
                      ),

                      // space
                      SizedBox(
                        height: 30,
                      ),

                      // change address button
                      CustomButton(
                        onButtonPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // show loading alert
                            Utils.showLoadingAlertDialog(context, "update_address");

                            // print('newAddress: ${_addressFieldController.text}');
                            // form is valid
                            // update buyer address
                            final result = await BuyerServices().updateAddress(
                                BuyerModel(
                                    docId: widget.buyerModel.docId!,
                                    address: _addressFieldController.text));

                            if (result == 'success') {
                              // close loading alert
                              Navigator.pop(context);
                              
                              // close screen
                              Navigator.pop(context);

                              // show snackbar
                              floatingSnackBar(
                                  message: 'Address updated successfully',
                                  context: context, duration: Duration(seconds: 2));
                            } else {
                              // show snackbar
                              floatingSnackBar(
                                  message:
                                      'Error updating address. Please try again later.',
                                  context: context, duration: Duration(seconds: 2));
                            }
                          }
                        },
                        buttonText: 'Update address',
                        primaryButton: true,
                        secondaryButton: false,
                        buttonWidth: MediaQuery.of(context).size.width,
                        buttonHeight: 60,
                      )
                    ],
                  ))
        ],
      ),
    );
  }
}
