import 'package:adhikar/common/widgets/bottom_nav_bar.dart';
import 'package:adhikar/common/widgets/snackbar.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/auth/controllers/auth_controller.dart';
import 'package:adhikar/features/expert/controller/meetings_controller.dart';
import 'package:adhikar/features/expert/controller/transaction_controller.dart';
import 'package:adhikar/features/expert/widgets/meetings_list.dart';
import 'package:adhikar/models/user_model.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ReviewOrder extends ConsumerStatefulWidget {
  final UserModel expertUserModel;
  final String phone;
  ReviewOrder({
    super.key,
    required this.expertUserModel,
    required this.phone,
  });

  @override
  ConsumerState<ReviewOrder> createState() => _ReviewOrderState();
}

class _ReviewOrderState extends ConsumerState<ReviewOrder> {
  late Razorpay _razorpay;
  bool isPaymentProcessing = false;

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) return;

    setState(() => isPaymentProcessing = true);

    // 1. Create meeting
    final meetingRes = await ref
        .read(meetingsControllerProvider.notifier)
        .createMeeting(
          userModel: currentUser,
          expertUserModel: widget.expertUserModel,
          phone: widget.phone,
          transactionID: response.paymentId.toString(),
          context: context,
        );

    await meetingRes.fold(
      (failure) {
        setState(() => isPaymentProcessing = false);
        showSnackbar(context, "Failed to create meeting: ${failure.message}");
      },
      (meetingDoc) async {
        // 2. Create transaction (Success)
       await ref
            .read(transactionControllerProvider.notifier)
            .createTransaction(
              userModel: currentUser,
              expertUserModel: widget.expertUserModel,
              amount: 300, // Fixed amount for consultation
              paymentStatus: 'Success',
              phone: widget.phone,
              paymentID: response.paymentId.toString(),
              context: context,
            );

        setState(() => isPaymentProcessing = false);
        showSnackbar(
          context,
          "Payment successful and meeting is created with the expert.",
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
          (route) => false,
        );
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) return;

    setState(() => isPaymentProcessing = false);

    // Only create a failed transaction, do NOT create meeting
    ref
        .read(transactionControllerProvider.notifier)
        .createTransaction(
          userModel: currentUser,
          expertUserModel: widget.expertUserModel,
          amount: 300,
          paymentStatus: 'Failed',
          phone: widget.phone,
          paymentID: response.error.toString(),
          context: context,
        );

    showSnackbar(context, "Payment failed. Please try again.");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
      (route) => false,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => isPaymentProcessing = false);
    showSnackbar(context, "External wallet selected: ${response.walletName}");
    // Do NOT create meeting or transaction here!
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(String name, String description, String email) {
    setState(() {
      isPaymentProcessing = true; // Show loader
    });
    var options = {
      'key': AppwriteConstants.razorpayKey,
      'amount': (double.parse('300') * 100).toInt(),
      'name': name,
      'description': description,
      'prefill': {'contact': widget.phone, 'email': email},
    };

    try {
      _razorpay.open(options);
      // Optionally, you can set isPaymentProcessing = false in payment success/error handlers if you want to hide loader after Razorpay closes.
    } catch (e) {
      setState(() {
        isPaymentProcessing = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDataProvider).value;
    if (currentUser == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Review your order',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 18.0,
          right: 18,
          bottom: 60,
          top: 20,
        ),
        child: GestureDetector(
          onTap: isPaymentProcessing
              ? null
              : () {
                  openCheckout(
                    '${currentUser.firstName} ${currentUser.lastName}',
                    'Payment for consultation with ${widget.expertUserModel.firstName} ${widget.expertUserModel.lastName}',
                    currentUser.email,
                  );
                },
          child: Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isPaymentProcessing
                  ? Colors.grey
                  : const Color.fromRGBO(231, 209, 95, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isPaymentProcessing
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Pallete.backgroundColor,
                      ),
                    )
                  : Text(
                      'Continue to Payment',
                      style: TextStyle(
                        color: Pallete.backgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 580,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Pallete.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        widget.expertUserModel.profileImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                    // Bottom-to-top gradient overlay for blur effect
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 100, // adjust for blur height
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          Text(
                            '${widget.expertUserModel.firstName} ${widget.expertUserModel.lastName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: SvgPicture.asset(
                              'assets/svg/verified.svg',
                              height: 30,
                              colorFilter: ColorFilter.mode(
                                Pallete.secondaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 0,
                ),

                child: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 15,
                    color: Pallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '${currentUser.firstName} ${currentUser.lastName}',
                  style: TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 0,
                ),

                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 15,
                    color: Pallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  currentUser.email,
                  style: TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 10.0,
                  bottom: 0,
                ),

                child: Text(
                  'Contact Number',
                  style: TextStyle(
                    fontSize: 15,
                    color: Pallete.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.phone,
                  style: TextStyle(
                    color: Pallete.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        color: Pallete.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹300',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(231, 209, 95, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
