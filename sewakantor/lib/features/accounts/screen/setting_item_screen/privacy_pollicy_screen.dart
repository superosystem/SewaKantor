import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppbarWidget(
        contexts: context,
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        isCenterTitle: false,
        titles: 'Privacy Policy',
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: AdaptSize.pixel16,
            right: AdaptSize.pixel16,
            top: AdaptSize.pixel16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy Better Space',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: AdaptSize.pixel16),
              ),
              SizedBox(
                height: AdaptSize.pixel16,
              ),

              /// no 1
              Text(
                '1. Definition',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
              ),
              SizedBox(
                height: AdaptSize.pixel10,
              ),
              Text(
                '1.1 “user” means an individual who (a) has contacted us by any means to find out more about any Service we provide, or (b) may, or has, entered into a contract with us for our provision of any Service, (c) or interact with us and/or through various applications and online platforms that we manage.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '1.2. “personal data” means data, whether true or not, about an identifiable user: (a) of that data; or (b) from that data and other information to which we have or are likely to have access.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),

              SizedBox(
                height: AdaptSize.pixel10,
              ),

              /// no 2
              Text(
                '2. Sample Persona Data collected',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
              ),
              Text(
                'Depending on the nature of your interactions with us, some examples of personal data we may collect from you include your name, email address, phone number, gender, biometric data such as your profile picture.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),

              SizedBox(
                height: AdaptSize.pixel10,
              ),

              /// no 3
              Text(
                '3. Collection, use and disclosure of personal data',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
              ),
              Text(
                'We generally do not collect your personal data unless (a) the data is voluntarily provided to us by you directly or through a third party who has been authorized by you to disclose your personal data to us (“your authorized representative”) after (i) You (or your authorized representative) have been informed of the purposes for which the data is collected, and (ii) you (or your authorized representative) have given written consent for the collection and use of your personal data for such purposes, or (b) the collection and use of personal data without approval permitted or required by PDPA or other laws. We will ask for your consent before collecting any additional personal data and before using your personal data for purposes that have not been notified to you (unless permitted or permitted by law).',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),

              /// no 4
              Text(
                '4. Purpose of data collection and use',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
              ),
              Text(
                'We may collect and use your personal data for any or all of the following purposes:',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(a) perform the obligations Selma or in connection with the provision of our Services to you;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(b) verify your identity;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(c) respond to, handle and process your inquiries, requests, applications, complaints and feedback;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(d) managing your relationship with us and with the Host;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(e) processing payment or credit transactions;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(f) to comply with applicable laws, regulations, codes of practice, guidelines or rules, or to assist law enforcement and investigations conducted by government authorities and/or regulators;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(g) transmit to unaffiliated third parties including our third party service providers and agents, and relevant government and/or regulatory authorities, whether in Singapore or overseas, for the purposes set out above;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(h) other incidental business purposes related to or in connection with the above;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(i) to develop, test and improve our Services, including by conducting surveys and research, and testing and troubleshooting new products and features;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(j) to send you marketing and promotional communications (including our business partners and sponsors), communicate with you about our Services, surveys, and inform you about our policies and terms. We also use your information to respond to you when you contact us;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(k) where applicable, to administer awarding and awarding of prizes in surveys or other non-commercial competitions we may run from time to time;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(l) other purposes for which you provide the information; and',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(m) use and share your personal data with our affiliates globally, including our subsidiaries and parent companies where applicable, for the purposes set out in this Section 5, including to send you marketing and promotions on the Services, offered by our affiliates.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),

              SizedBox(
                height: AdaptSize.pixel10,
              ),

              /// no 5
              Text(
                '5. We may disclose your personal data:',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
              ),
              Text(
                '(a) if the disclosure is necessary to perform an obligation during or in connection with providing our Services to you;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(b) to third party service providers, vendors, contractors, agents and other organizations that we have engaged to perform one of the functions with reference to the purposes stated above;',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),
              Text(
                '(c) to our affiliates globally, and in such case your information may be transferred, stored or processed in a country outside of your place of residence for the purposes described in this Privacy Policy.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),

              SizedBox(
                height: AdaptSize.pixel10,
              ),

              Text(
                'The purposes set out in the clauses above may continue to apply even in situations where your relationship with us (for example, our commercial, business and/or employment relationship has ended) has been terminated or changed in any way, for reasonable reasons. the period thereafter (including, if applicable, the period during which we may enforce our rights under a contract with you).',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: AdaptSize.pixel14),
                textAlign: TextAlign.justify,
              ),

              SizedBox(
                height: AdaptSize.pixel10,
              ),

              Text(
                'Last revised on November 20, 2022',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: AdaptSize.pixel14),
              ),

              SizedBox(
                height: AdaptSize.screenHeight * .05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
