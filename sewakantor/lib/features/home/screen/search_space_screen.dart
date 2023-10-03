import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sewakantor/core/network/network_aware.dart';
import 'package:sewakantor/core/network/no_connection_screen.dart';
import 'package:sewakantor/features/home/widget/search_field.dart';
import 'package:sewakantor/features/home/widget/search_screen_widget/list_radio_button.dart';
import 'package:sewakantor/features/navigation/view_model/navigasi_view_model.dart';
import 'package:sewakantor/features/offices/view_model/office_view_models.dart';
import 'package:sewakantor/features/spaces/view_model/search_spaces_view_model.dart';
import 'package:sewakantor/utils/adapt_size.dart';
import 'package:sewakantor/utils/colors.dart';
import 'package:sewakantor/widgets/button_widget.dart';
import 'package:sewakantor/widgets/default_appbar_widget.dart';
import 'package:sewakantor/widgets/horizontal_filter_location.dart';
import 'package:sewakantor/widgets/read_only_form.dart';

class SearchSpaceScreen extends StatefulWidget {
  const SearchSpaceScreen({Key? key}) : super(key: key);

  @override
  State<SearchSpaceScreen> createState() => _SearchSpaceScreenState();
}

class _SearchSpaceScreenState extends State<SearchSpaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  ValueNotifier<String> stringOfficeTypeVal =
      ValueNotifier<String>('coworking space');
  ValueNotifier<String> stringOfficeLocationVal =
      ValueNotifier<String>('South Jakarta');

  @override
  void initState() {
    super.initState();
    final officeProvider =
        Provider.of<OfficeViewModels>(context, listen: false);
    Future.delayed(Duration.zero, () {
      officeProvider.fetchAllOffice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppbarWidget(
        contexts: context,
        leadIconFunction: () {
          context.read<NavigasiViewModel>().navigasiPop(context);
        },
        isCenterTitle: false,
        titles: 'Search',
      ),
      body: NetworkAware(
        offlineChild: const NoConnectionScreen(),
        onlineChild: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AdaptSize.screenWidth * .016,
                  right: AdaptSize.screenWidth * .016,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2.5,
                      color: MyColor.neutral900,
                      shadowColor: MyColor.grayLightColor.withOpacity(.4),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: AdaptSize.screenWidth * .008,
                          bottom: AdaptSize.screenHeight * .022,
                          top: AdaptSize.screenHeight * .022,
                          right: AdaptSize.screenWidth * .008,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'With whom did you come here ?',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: AdaptSize.pixel16,
                                  ),
                            ),

                            /// text field
                            searchPlace(
                              /// search field
                              context: context,
                              margin: EdgeInsets.only(
                                top: AdaptSize.screenHeight * 0.016,
                                bottom: AdaptSize.screenHeight * 0.016,
                              ),
                              hintText: 'Search Office',

                              controller: _searchController,
                              prefixIcon: Icon(
                                Icons.search,
                                color: MyColor.darkColor.withOpacity(.8),
                              ),
                              onTap: () {
                                context
                                    .read<NavigasiViewModel>()
                                    .navigasiToFilterSearch(context);
                              },
                              readOnly: true,
                            ),

                            /// list of all office by location
                            SizedBox(
                              height: AdaptSize.screenHeight * 0.193,
                              width: double.infinity,
                              child: horizontalFilterLocation(
                                contexts: context,
                                isSelected: stringOfficeLocationVal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: AdaptSize.screenHeight * 0.034,
                    ),

                    /// date picker
                    Container(
                      height: AdaptSize.screenWidth / 1000 * 310,
                      width: double.infinity,
                      padding: EdgeInsets.all(AdaptSize.screenHeight * .01),
                      decoration: BoxDecoration(
                        color: MyColor.neutral900,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(1, 2),
                            color: MyColor.grayLightColor.withOpacity(.4),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'When you\'r come ?',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: AdaptSize.pixel16),
                          ),

                          SizedBox(
                            height: AdaptSize.screenHeight * 0.014,
                          ),

                          /// date text field
                          Flexible(
                            fit: FlexFit.loose,
                            child: readOnlyWidget(
                              controller: _dateController,
                              enblBorderRadius: 16,
                              errBorderRadius: 16,
                              fcsBorderRadius: 16,
                              hint: 'day, date month year',
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: MyColor.grayLightColor,
                                  ),
                              onTap: () {
                                pickedDate(context);
                              },
                              suffixIcon: Icon(
                                CupertinoIcons.calendar,
                                color: MyColor.grayLightColor,
                                size: AdaptSize.pixel24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: AdaptSize.screenHeight * 0.034,
                    ),

                    /// list of value button
                    listValueButton(
                      context: context,
                      stringOfficeTypeVal: stringOfficeTypeVal,
                      controllerValue1: 'coworking space',
                      controllerValue2: 'meeting room',
                      controllerValue3: 'office',
                    ),

                    SizedBox(
                      height: AdaptSize.pixel18,
                    ),
                  ],
                ),
              ),

              /// find place button
              Container(
                height: AdaptSize.screenWidth / 1000 * 200,
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: AdaptSize.pixel8,
                  right: AdaptSize.pixel8,
                  top: AdaptSize.pixel14,
                  bottom: AdaptSize.pixel14,
                ),
                decoration: BoxDecoration(
                  color: MyColor.neutral800,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: MyColor.grayLightColor.withOpacity(.4),
                        blurRadius: 3,
                        blurStyle: BlurStyle.solid),
                  ],
                ),
                child: buttonWidget(
                  sizeheight: AdaptSize.pixel40,
                  sizeWidth: double.infinity,
                  onPressed: () {
                    context
                        .read<NavigasiViewModel>()
                        .navigasiToSearchBySelected(
                          context,
                          stringOfficeLocationVal.value,
                          stringOfficeTypeVal.value,
                          _dateController.text.isNotEmpty
                              ? _dateController.text
                              : 'Date Unselected',
                        );
                  },
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: MyColor.darkBlueColor,
                  child: Text(
                    'Find Place',
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: MyColor.whiteColor,
                          fontSize: AdaptSize.screenHeight * 0.018,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// show date picker
  Future pickedDate(BuildContext context) async {
    final dateProvider =
        Provider.of<SearchSpacesViewModel>(context, listen: false);

    dateProvider.dateNow = (await showDatePicker(
      context: context,
      initialDate: dateProvider.dateTime,
      firstDate: DateTime(1999),
      lastDate: DateTime(2050),
      fieldLabelText: 'Booking Date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: MyColor.darkBlueColor,
              surface: MyColor.whiteColor,
              onPrimary: MyColor.whiteColor,
              onSurface: MyColor.darkColor,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: MyColor.darkBlueColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ))!;

    dateProvider.pickdate();
    _dateController.text = dateProvider.datePicked;
  }
}
