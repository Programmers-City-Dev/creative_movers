import 'dart:io';

import 'package:creative_movers/blocs/feed/feed_bloc.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/data/remote/model/report.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportFeedWidget extends StatefulWidget {
  final Feed feed;
  const ReportFeedWidget({Key? key, required this.feed}) : super(key: key);

  @override
  State<ReportFeedWidget> createState() => _ReportFeedWidgetState();
}

class _ReportFeedWidgetState extends State<ReportFeedWidget> {
  final List<FeedReportModel> reasons = dummyOptions;
  FeedReportModel? selectedReport;
  FeedReportModel? selectedReportOption;

  final _feedBloc = FeedBloc(injector.get());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              if (selectedReport != null) {
                setState(() {
                  selectedReport = null;
                  selectedReportOption = null;
                });
              } else {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              selectedReport == null
                  ? Icons.close
                  : Platform.isAndroid
                      ? Icons.arrow_back_outlined
                      : Icons.arrow_back_ios_rounded,
              color: Colors.black,
            )),
        centerTitle: true,
        title: const Text(
          "Report",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocListener<FeedBloc, FeedState>(
        bloc: _feedBloc,
        listener: (context, state) {
          if (state is FeedLoading) {
            AppUtils.showAnimatedProgressDialog(context,
                title: "Submitting report, please wait");
          }
          if (state is FeedReported) {
            Navigator.of(context)
              ..pop()
              ..pop();
            AppUtils.showCustomToast("Report submitted successfully");
          }

          if (state is FeedFailure) {
            Navigator.pop(context);
            AppUtils.showCustomToast(
              state.errorModel.errorMessage,
            );
          }
        },
        child: selectedReport == null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32 * 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Can you tell us why you are reporting this?",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedReport = reasons[index];
                                    });
                                  },
                                  title: Text(reasons[index].title,
                                      style: const TextStyle(
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w500)),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded),
                                ),
                            separatorBuilder: (_, __) => const Divider(),
                            itemCount: reasons.length),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "How is this ${selectedReport?.title.toLowerCase()}?",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) =>
                              RadioListTile<String>(
                                title: Text(
                                    selectedReport!.options![index].title,
                                    style: const TextStyle(
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                    '${selectedReport!.options![index].description}',
                                    style: const TextStyle(
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.w500)),
                                groupValue:
                                    selectedReport!.options![index].title,
                                onChanged: (value) {
                                  setState(() {
                                    selectedReportOption =
                                        selectedReport!.options![index];
                                  });
                                },
                                value: selectedReportOption?.title ?? '',
                              ),
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: selectedReport!.options!.length),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                          onTap: selectedReportOption == null
                              ? null
                              : () {
                                  _feedBloc.add(ReportFeed(
                                      dataId: widget.feed.id,
                                      reason: selectedReportOption!.title,
                                      type: widget.feed.type == "user_feed"
                                          ? "feed"
                                          : "page"));
                                },
                          child: const Text(
                            "Submit Report",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

var dummyOptions = [
  // Report 1
  const FeedReportModel(title: "Suspicious, spam, or fake", options: [
    FeedReportModel(
        title: "Misinformation",
        description:
            "Spreading false or misleading information as if it were true"),
    FeedReportModel(
        title: "Fraud or scam",
        description:
            "Deceptive or misleading practices to trick people into giving up their money or personal information"),
    FeedReportModel(
        title: "Spam",
        description:
            "Repetitive or irrelevant content that are posted to a large number of audience to promote a product or service, or monetarily benefit the poster"),
    FeedReportModel(
        title: "Fake account",
        description: "A profile that is pretending to be someone else"),
  ]),

  // Report 2
  const FeedReportModel(title: "Harrasment or hateful speech", options: [
    FeedReportModel(
        title: "Bullying or trolling",
        description:
            "Repeatedly attacking or harassing someone online, or posting content that is intended to upset or humiliate someone"),
    FeedReportModel(
        title: "Sexual harassment",
        description:
            "Unwanted sexual attention or advances, or posting content that is intended to upset or humiliate someone"),
    FeedReportModel(
        title: "Hateful or abusive speech",
        description:
            "Hateful, degredatory, or abusive speech that is intended to upset or humiliate someone"),
    FeedReportModel(
        title: "Spam",
        description:
            "Sharing irrelevant or offensive content that is intended to boost the poster's profile or monetarily benefit the poster"),
  ]),

  // Report 3
  const FeedReportModel(title: "Voilence or physical harm", options: [
    FeedReportModel(
        title: "Inciting violence or is a threat",
        description: "Encouraging violent acts of threatening physical harm"),
    FeedReportModel(
        title: "Self-harm",
        description: "Suicidal remarks or threatening to harm oneself"),
    FeedReportModel(
        title: "Shocking or gory", description: "Shocking or graphic content"),
    FeedReportModel(
        title: "Terrorism or act of extreme violence",
        description: "Depicting or encouraging terrorist acts or severe harm"),
  ]),

  // Report 4
  const FeedReportModel(title: "Adult content", options: [
    FeedReportModel(
        title: "Nudity or sexual content",
        description: "Nudity, sexual scenes or language, or sex trafficking"),
    FeedReportModel(
        title: "Shocking or gory", description: "Shocking or graphic content"),
    FeedReportModel(
        title: "Sexual harassment",
        description: "Unwanted romantic advances, requests for sexual favors, "
            "or unwelcome sexual remarks"),
  ]),
];



//  "Harrasment or hateful speech",
//     "Voilence or physical harm",
//     "Adult content",
//     "Impersonation or deceptive identity",