// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:creative_movers/cubit/in_app_payment_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool? isFromSignup;

  const SubscriptionScreen({Key? key, this.isFromSignup = false})
      : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final List<String> _subIds = [
    'com.creativemovers.m7',
  ];

  String? _selectedProductId;
  final InAppPaymentCubit _appPaymentCubit = InAppPaymentCubit(injector.get());

  @override
  void initState() {
    super.initState();
    _selectedProductId = _subIds.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
        leading: widget.isFromSignup!
            ? null
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: TextButton(onPressed: () {}, child: const Text("Restore")),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Full Access\nAnd Move Forward',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Post Stories without limit',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Post Stories without limit',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Connect with unlimited movers',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(
              height: 32.0,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    const Spacer(),
                    TrialStatement(
                      pId: _selectedProductId ?? '',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SubscriptionOptions(
                        subIds: _subIds, onSubSelected: (id) {}),
                    const SizedBox(
                      height: 32 * 2,
                    ),
                    BlocConsumer<InAppPaymentCubit, InAppPaymentState>(
                      bloc: _appPaymentCubit,
                      listener: (context, state) {
                        if (state is InAppPaymentError) {
                          AppUtils.showErrorDialog(context,
                              message: state.error.errorMessage,
                              title: "Subscription Error",
                              confirmButtonText: "Close",
                              onConfirmed: () => Navigator.pop(context));
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          onTap: state is InAppPaymentLoading
                              ? null
                              : () {
                                  if (_selectedProductId != null) {
                                    _appPaymentCubit.purchaseStoreProduct(
                                        _selectedProductId!);
                                  }
                                },
                          radius: 32,
                          color: Colors.white,
                          child: Text(
                            "Subscribe Now",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrialStatement extends StatelessWidget {
  final String pId;
  TrialStatement({
    Key? key,
    required this.pId,
  }) : super(key: key);

  final InAppPaymentCubit _appPaymentCubit = InAppPaymentCubit(injector.get());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<InAppPaymentCubit, InAppPaymentState>(
        bloc: _appPaymentCubit..fetchProduct(pId),
        builder: (context, state) {
          if (state is ProductsFetched) {
            return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Try 7 days for free.\nThen '
                          '${state.product.priceString}/month',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ))
                ]));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class SubscriptionOptions extends StatefulWidget {
  final List<String> subIds;
  final Function(String) onSubSelected;
  const SubscriptionOptions({
    Key? key,
    required this.subIds,
    required this.onSubSelected,
  }) : super(key: key);

  @override
  State<SubscriptionOptions> createState() => _SubscriptionOptionsState();
}

class _SubscriptionOptionsState extends State<SubscriptionOptions> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.subIds.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SubscriptionItem(
                isActive: _activeIndex == index,
                subscriptionId: widget.subIds[index],
                onSelected: (id) {
                  setState(() {
                    widget.onSubSelected(id);
                    _activeIndex = index;
                  });
                },
              ),
            ));
  }
}

class SubscriptionItem extends StatefulWidget {
  final bool? isActive;
  final String subscriptionId;
  final Function(String subscriptionId) onSelected;
  const SubscriptionItem({
    Key? key,
    this.isActive = false,
    required this.subscriptionId,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<SubscriptionItem> createState() => _SubscriptionItemState();
}

class _SubscriptionItemState extends State<SubscriptionItem> {
  final InAppPaymentCubit _appPaymentCubit = InAppPaymentCubit(injector.get());

  @override
  void initState() {
    super.initState();
    _appPaymentCubit.fetchProduct(widget.subscriptionId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onSelected(widget.subscriptionId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(
              color: widget.isActive! ? Colors.white : Colors.black12,
              width: 2),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio(
                  value: widget.isActive! ? 1 : 0,
                  groupValue: 1,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return Colors.black12;
                  }),
                  activeColor: Colors.white,
                  onChanged: (value) {},
                ),
                Text("Monthly",
                    style: TextStyle(
                        color: widget.isActive! ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ],
            ),
            BlocBuilder<InAppPaymentCubit, InAppPaymentState>(
              bloc: _appPaymentCubit,
              builder: (context, state) {
                if (state is ProductsFetched) {
                  return RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${state.product.priceString}/month",
                        style: TextStyle(
                            color: widget.isActive!
                                ? Colors.white
                                : Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 16))
                  ]));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
