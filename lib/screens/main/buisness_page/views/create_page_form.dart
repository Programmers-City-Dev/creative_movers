
import 'package:creative_movers/blocs/buisness/buisness_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
import 'package:creative_movers/screens/widget/filled_form_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CreatePageForm extends StatefulWidget {
  const CreatePageForm({Key? key}) : super(key: key);

  @override
  _CreatePageFormState createState() => _CreatePageFormState();
}

class _CreatePageFormState extends State<CreatePageForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> stages = ['Pre-seed', 'Seed', 'Start up', 'Expansion'];
  List<String> categories = [];

  String image = '';

  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _contactController = TextEditingController();
  final _aboutPageController = TextEditingController();
  final _capitalController = TextEditingController();

  String stage = 'Seed';
  final BuisnessBloc _buisnessBloc = BuisnessBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuisnessBloc, BuisnessState>(
      bloc: _buisnessBloc,
      listener: (context, state) {
        _listenToCreatePageState(context, state);
        // TODO: implement listener
      },
      child: Form(
          key: _formKey,
          child: Scaffold(
            backgroundColor: AppColors.smokeWhite,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  AddImageWidget(
                    onUpload: _fetchImage,
                    imagePath: image,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Add Image to this page ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Use Images that represent what he page is all about '
                        'like logo , This will appear in the search result',
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FilledFormField(
                    labeled: true,
                    controller: _nameController,
                    hint: 'Enter the name of this page',
                    validator: MultiValidator(
                        [RequiredValidator(errorText: "Enter page name")]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledFormField(
                    labeled: true,

                    controller: _websiteController,
                    hint: 'Website Address (optional)',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledFormField(
                    labeled: true,

                    hint: 'Contact Info',
                    controller: _contactController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledFormField(
                    labeled: true,

                    keyboardType: TextInputType.number,
                    controller: _capitalController,
                    hint: 'Estimated capital',
                    prefix: const Text(
                      '\$ ',
                      style: TextStyle(fontSize: 16),
                    ),
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Enter you estimated capital")
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormField<List<String>>(
                    initialValue: categories,
                    validator: ((value) {
                      if (categories.isEmpty) {
                        return 'Please select your category of investment';
                      }
                      return null;
                    }),
                    builder: (field) =>
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.start,
                              direction: Axis.horizontal,
                              spacing: 5,
                              children: List<Widget>.generate(
                                  categories.length,
                                      (index) =>
                                      Chip(
                                        label: Text(categories[index]),
                                        deleteIcon: const Icon(Icons.close),
                                        onDeleted: () {
                                          setState(() {
                                            categories.remove(
                                                categories[index]);
                                          });
                                        },
                                      )),
                            ),
                            InkWell(
                                child: Container(
                                  decoration:
                                  const BoxDecoration(color: AppColors.white),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                        'Select Category Of Investment'),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        SearchDropdown(
                                          onSaved: (list) {
                                            setState(() {
                                              categories = list;
                                            });
                                          },
                                        ),
                                  );
                                }),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              field.hasError ? field.errorText! : '',
                              // ?? state.value?.length.toString()! + '/5 selected',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: field.hasError
                                      ? Colors.redAccent
                                      : Colors.green),
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Select your stage of investment')
                      ]),
                      onChanged: (value) {
                        stage = value!;
                      },
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.white,
                          focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                          labelStyle: TextStyle(color: AppColors.textColor),
                          labelText: 'Select stage of investment',
                          contentPadding: EdgeInsets.all(16),
                          border:
                          OutlineInputBorder(borderSide: BorderSide.none)),
                      value: 'Seed',
                      items: stages
                          .map((e) =>
                          DropdownMenuItem<String>(value: e, child: Text(e)))
                          .toList()),
                  const SizedBox(
                    height: 10,
                  ),
                  FilledFormField(
                      labeled: true,

                      controller: _aboutPageController,
                      hint: 'Whats this page all about',
                      maxlines: 5,
                      validator: RequiredValidator(
                          errorText: 'This field shouldn\'t be empty')),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 18),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {
                          createPage();
                        },
                        child: const Text(
                          'DONE',
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _fetchImage() async {
    var images = await AppUtils.fetchImages(allowMultiple: false);
    if (images.isNotEmpty) {
      setState(() {
        image = images[0];
      });
    }
  }

  void _listenToCreatePageState(BuildContext context, BuisnessState state) {
    if (state is CreatePageLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }

    if (state is CreatePageFailureState) {
      Navigator.pop(context);
      CustomSnackBar.showError(context, message: state.error);
    }

    if (state is CreatePageSuccesState) {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => const MyPageTab()),  ModalRoute.withName(bizPath));

    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyPageTab(),));

    CustomSnackBar.show(context, message: 'You Successfully created a page',backgroundColor: Colors.green);
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => state.accountTypeResponse.connect.isNotEmpty
    //           ? ConnectionScreen(
    //         connections: state.accountTypeResponse.connect,
    //         role: state.accountTypeResponse.userRole?.role,
    //       )
    //           : const PaymentScreen(),
    //     ),
    //         (route) => false);
  }
  }

  void createPage() {
    if (_formKey.currentState!.validate()) {
      image.isNotEmpty ?
      _buisnessBloc.add(CreatePageEvent(
          contact: _contactController.text,
          name: _nameController.text,
          stage: stage,
          est_capital: _capitalController.text,
          photo: image,
          description: _aboutPageController.text,
          category: categories,
          website: _websiteController.text)) : AppUtils.showCustomToast(
          'Select An Image');
    }
  }
}
