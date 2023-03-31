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
              const SizedBox(
                height: 30,
              ),
              _ContactUsItem(
                tittle: 'Faqs',
                subtittle: 'Frequently asked questions',
                icon: LineIcons.question,
                onTap: () {
                  Navigator.pushNamed(context, faqsPath);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              _ContactUsItem(
                tittle: 'Phone Number',
                subtittle: '0901234567',
                icon: LineIcons.phone,
                onTap: () {
                  final Uri phoneLaunchUri = Uri(
                    scheme: 'tel',
                    path: '0901234567',
                    query: '',
                  );
                  launchUrl(
                    phoneLaunchUri,
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(
                height: 20,
              ),
              _ContactUsItem(
                tittle: 'Twitter',
                subtittle: '@creativemovers',
                icon: LineIcons.twitter,
                onTap: () {
                  final Uri _url = Uri.parse(
                    'https://twitter.com/createmovers',
                  );
                  launchUrl(_url, mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _ContactUsItem(
                tittle: 'Facebook',
                subtittle: 'Create Movers',
                icon: LineIcons.twitter,
                onTap: () {
                  final Uri _url = Uri.parse(
                    'https://web.facebook.com/create.movers.1',
                  );
                  launchUrl(_url, mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _ContactUsItem(
                tittle: 'Instagram',
                subtittle: 'Creative Movers',
                icon: LineIcons.instagram,
                onTap: () {
                  final Uri _url =
                      Uri.parse('https://www.instagram.com/createmovers/');
                  launchUrl(_url, mode: LaunchMode.externalApplication);
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black45,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tittle,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  subtittle,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            )),
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
