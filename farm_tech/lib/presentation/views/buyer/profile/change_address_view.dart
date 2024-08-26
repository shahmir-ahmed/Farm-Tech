import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChangeAddressView extends StatefulWidget {
  const ChangeAddressView({super.key});

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar('Change Address', [], context),
      body: _getBody(),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Text('Address', style: Utils.kAppBody2MediumStyle,),

          //space
          SizedBox(
            height: 20,
          ),

          // input field
          Form(
            key: _formKey,
              child: Column(
            children: [
              TextFormField(
                decoration: Utils.inputFieldDecoration,
                minLines: 3,
                maxLines: 5,
              ),

              // space
              SizedBox(
                height: 30,
              ),

              // change address button
              CustomButton(
                onButtonPressed: () {
                  if(_formKey.currentState!.validate()){
                    // if form is valid
                    // update buyer address
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
