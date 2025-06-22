import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final _addressFormKey = GlobalKey<FormState>();
  final AddressServices addressServices = AddressServices();
  // final address = context.watch<UserProvider>().user.address;
  // var name = context.watch<UserProvider>().user.name;
  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pinCodeController.dispose();
    cityController.dispose();
  }

  // void onGpayResult(res) {}
  // List<PaymentItem> paymentItems = [
  //   PaymentItem(
  //     label: 'Total',
  //     amount: '1.00',
  //     status: PaymentItemStatus.final_price,
  //   ),
  // ];

  void placeOrder(String address, double totalSum) {
    addressServices.placeOrder(
      context: context,
      address: address,
      totalSum: totalSum,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double sum = 0;
    for (var item in user.cart) {
      final quantity = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
      final product = item['product'];
      int price = 0;
      if (product is Map && product['price'] != null) {
        price = int.tryParse(product['price'].toString()) ?? 0;
      }
      sum += quantity * price;
    }
    final address = context.watch<UserProvider>().user.address;
    final name = context.watch<UserProvider>().user.name;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
              Text(
                address.isNotEmpty ? 'OR' : 'Enter your address',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: pinCodeController,
                      hintText: 'Pincode',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town, City',
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      text: 'Proceed to Pay',
                      onTap: () {
                        if (flatBuildingController.text.isNotEmpty ||
                            areaController.text.isNotEmpty ||
                            pinCodeController.text.isNotEmpty ||
                            cityController.text.isNotEmpty) {
                          String newAddress =
                              '${flatBuildingController.text}, ${areaController.text}, ${pinCodeController.text}, ${cityController.text}.';
                          addressServices.saveUserAddress(
                            context: context,
                            address: newAddress,
                          );
                        }

                        placeOrder(address, sum);

                        // CustomDialog.show(
                        //   context,
                        //   'Hey ${name}! You are a poor man. Don\'t waste money. HAHA HAHA!!😘',
                        //   '',
                        // );
                      },
                    ),
                    //                     GooglePayButton(
                    //   paymentConfigurationAsset: 'assets/gpay.json', // Use the correct asset path
                    //   paymentItems: paymentItems,
                    //   type: GooglePayButtonType.buy,
                    //   height: 100,
                    //   margin: const EdgeInsets.only(top: 15.0),
                    //   onPaymentResult: onGpayResult,
                    //   loadingIndicator: const Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
