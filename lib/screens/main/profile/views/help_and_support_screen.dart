import 'package:creative_movers/constants/constants.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black45,
        ),
        backgroundColor: AppColors.smokeWhite,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SvgPicture.asset(
                'assets/svgs/help.svg',
                height: 300,
                width: 100,
              ),
              const SizedBox(
                height: 16,
              ),
              const Center(
                child: Text(
                  'We are here to help so please get \n in touch with us ! ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              _ContactUsItem(
                tittle: 'Faqs',
                subtittle: 'Frequently asked questions',
                icon: LineIcons.question,
                onTap: () {
                  Navigator.pushNamed(context, faqsPath);
                },
              ),

              _ContactUsItem(
                tittle: 'Terms & Conditions',
                subtittle: 'Read about our terms & conditions',
                icon: LineIcons.trademark,
                onTap: () {
                  AppUtils.launchInAppBrowser(
                      context, "${Constants.baseUrl}terms");
                },
              ),

              _ContactUsItem(
                tittle: 'Policies',
                subtittle: 'Read about our policies',
                // Policies icon
                icon: LineIcons.readme,
                onTap: () {
                  AppUtils.launchInAppBrowser(
                      context, "${Constants.baseUrl}policies");
                },
              ),

              _ContactUsItem(
                tittle: 'Support',
                subtittle: 'Contact us for support',
                // Policies icon
                icon: Icons.support_agent_outlined,
                onTap: () {
                  AppUtils.launchInAppBrowser(
                      context, "${Constants.baseUrl}support");
                },
              ),

              // _ContactUsItem(
              //   tittle: 'Phone Number',
              //   subtittle: '0901234567',
              //   icon: LineIcons.phone,
              //   onTap: () {
              //     final Uri phoneLaunchUri = Uri(
              //       scheme: 'tel',
              //       path: '0901234567',
              //       query: '',
              //     );
              //     launchUrl(
              //       phoneLaunchUri,
              //     );
              //   },
              // ),

              _ContactUsItem(
                tittle: 'Email',
                subtittle: 'info@creativemovers.app',
                icon: LineIcons.inbox,
                onTap: () {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'info@creativemovers.app',
                    query: '',
                  );
                  launchUrl(emailLaunchUri);
                },
              ),

              _ContactUsItem(
                tittle: 'Twitter',
                subtittle: '@creativemovers',
                icon: LineIcons.twitter,
                onTap: () {
                  final Uri url = Uri.parse(
                    'https://twitter.com/createmovers',
                  );
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),

              _ContactUsItem(
                tittle: 'Facebook',
                subtittle: 'Create Movers',
                icon: LineIcons.facebook,
                onTap: () {
                  final Uri url = Uri.parse(
                    'https://web.facebook.com/create.movers.1',
                  );
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),

              _ContactUsItem(
                tittle: 'Instagram',
                subtittle: 'Creative Movers',
                icon: LineIcons.instagram,
                onTap: () {
                  final Uri url =
                      Uri.parse('https://www.instagram.com/createmovers/');
                  launchUrl(url, mode: LaunchMode.inAppWebView);
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // _ContactUsItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactUsItem extends StatelessWidget {
  const _ContactUsItem(
      {Key? key,
      required this.tittle,
      required this.subtittle,
      required this.icon,
      this.onTap})
      : super(key: key);
  final String tittle;
  final String subtittle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.black45,
      ),
      title: Text(
        tittle,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtittle,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}
