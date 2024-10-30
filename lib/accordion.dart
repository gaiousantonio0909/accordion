/// Copyright 2021-2022 Christian Gotschim.
///
/// Published under the new BSD license.
///
/// Simple to use accordion widget with lots of preset properties.
///
/// Use the `maxOpenSections` property to automatically close sections
/// when opening a new section. This is especially helpful if you
/// always want your list to look clean -- just set this parameter
/// to 1 and whenever you open a new section the previous one closes.
///
/// `scrollIntoView` paramter can be set to `fast`, `slow`, or `none`.
/// This parameter will only take affect if there are enough items in
/// the list so scrolling is feasible.
///
/// Many parameters can be set globally on `Accordion` as well as individually
/// on each `AccordionSection` (see list below).
///
/// The header consists of the left and right icons (right icon is preset
/// to arrow down). Both can be set globally and individually. The
/// `header` parameter is required and needs to be set for each
/// `AccordionSection`.
/// `headerText`, `headerTextAlign`, `headerTextStyle` have been
/// deprecated as of version 2.0 and should be replaced with `header`
///
/// The content area basically provides the container in which you drop
/// whatever you want to display when `AccordionSection` opens. Background
/// and borders can be set globally or individually per section.
///
/// ```dart
/// 	Accordion(
/// 		maxOpenSections: 1,
/// 		headerTextStyle:
/// 			TextStyle(color: Colors.white, fontSize: 17),
/// 		leftIcon: Icon(Icons.audiotrack, color: Colors.white),
/// 		children: [
/// 			AccordionSection(
/// 				isOpen: true,
/// 				header: Text('Introduction', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 				content: Icon(Icons.airplanemode_active, size: 200),
/// 			),
/// 			AccordionSection(
/// 				isOpen: true,
/// 				header: Text('About Us', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 				content: Icon(Icons.airline_seat_flat, size: 120),
/// 			),
/// 			AccordionSection(
/// 				isOpen: true,
/// 				header: Text('Company Info', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 				content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
/// 			),
/// 		],
/// 	)
/// ```
library accordion;

import 'package:accordion/accordion_section.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

export 'accordion_section.dart';

/// The container list for all accordion sections. Usage:
/// ```dart
/// 	Accordion(
/// 		maxOpenSections: 1,
/// 		leftIcon: Icon(Icons.audiotrack, color: Colors.white),
/// 		children: [
/// 			AccordionSection(
/// 				isOpen: true,
/// 				header: Text('Introduction', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 				content: Icon(Icons.airplanemode_active, size: 200),
/// 			),
/// 			AccordionSection(
/// 				isOpen: true,
/// 				header: Text('About Us', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 				content: Icon(Icons.airline_seat_flat, size: 120),
/// 			),
/// 			AccordionSection(
/// 				isOpen: true,
/// 				header: Text('Company Info', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 				content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
/// 			),
/// 		],
/// 	)
/// ```
class Accordion extends StatelessWidget with CommonParams {
  final List<AccordionSection>? children;
  final double paddingListHorizontal;
  final double paddingListTop;
  final double paddingListBottom;
  final bool disableScrolling;
  static bool sectionAnimation = true;

  Accordion({
    Key? key,
    int? maxOpenSections,
    this.children,
    int? initialOpeningSequenceDelay,
    Color? headerBackgroundColor,
    Color? headerBackgroundColorOpened,
    double? headerBorderRadius,
    Widget? leftIcon,
    Widget? rightIcon,
    Widget? header,
    bool? flipRightIconIfOpen,
    bool? disableBorderContent = false,
    Color? contentBackgroundColor,
    Color? contentBorderColor,
    double? contentBorderWidth,
    double? contentBorderRadius,
    double? contentHorizontalPadding,
    double? contentVerticalPadding,
    this.paddingListTop = 20.0,
    this.paddingListBottom = 40.0,
    this.paddingListHorizontal = 10.0,
    EdgeInsets? headerPadding,
    double? paddingBetweenOpenSections,
    double? paddingBetweenClosedSections,
    ScrollIntoViewOfItems? scrollIntoViewOfItems,
    this.disableScrolling = false,
    SectionHapticFeedback? sectionOpeningHapticFeedback,
    SectionHapticFeedback? sectionClosingHapticFeedback,
    bool? openAndCloseAnimation,
  }) : super(key: key) {
    listCtrl.initialOpeningSequenceDelay = initialOpeningSequenceDelay ?? 0;
    this.headerBackgroundColor = headerBackgroundColor;
    this.headerBackgroundColorOpened =
        headerBackgroundColorOpened ?? headerBackgroundColor;
    this.headerBorderRadius = headerBorderRadius;
    this.leftIcon = leftIcon;
    this.rightIcon = rightIcon;
    this.flipRightIconIfOpen?.value = flipRightIconIfOpen ?? true;
    this.disableBorderContent?.value = disableBorderContent ?? false;
    this.contentBackgroundColor = contentBackgroundColor;
    this.contentBorderColor = contentBorderColor;
    this.contentBorderWidth = contentBorderWidth;
    this.contentBorderRadius = contentBorderRadius ?? 10;
    this.contentHorizontalPadding = contentHorizontalPadding;
    this.contentVerticalPadding = contentVerticalPadding;
    this.headerPadding = headerPadding ??
        const EdgeInsets.symmetric(horizontal: 15, vertical: 7);
    this.paddingBetweenOpenSections = paddingBetweenOpenSections ?? 10;
    this.paddingBetweenClosedSections = paddingBetweenClosedSections ?? 3;
    this.scrollIntoViewOfItems = scrollIntoViewOfItems;
    this.sectionOpeningHapticFeedback =
        sectionOpeningHapticFeedback ?? SectionHapticFeedback.none;
    this.sectionClosingHapticFeedback =
        sectionClosingHapticFeedback ?? SectionHapticFeedback.none;
    sectionAnimation = openAndCloseAnimation ?? true;

    int count = 0;
    listCtrl.maxOpenSections = maxOpenSections ?? 1;
    for (var child in children!) {
      // child.key = UniqueKey();
      // print(UniqueKey());
      if (child.sectionCtrl.isSectionOpen.value == true) {
        count++;
        // listCtrl.openSections.add(Key(count.toString()));

        if (count > listCtrl.maxOpenSections) {
          child.sectionCtrl.isSectionOpen.value = false;
        }
        // else if (child.sectionCtrl.isSectionOpen.value) {
        //   listCtrl.openSections.add(key);
        // }
      }
    }
  }

  // buildOpenList() async {
  //   if (child.sectionCtrl.isSectionOpen.value) {
  //     listCtrl.openSections.add(key);
  //     Key(1.toString());
  //   }
  // }

  @override
  build(context) {
    int index = 0;

    return Scrollbar(
      controller: listCtrl.controller,
      child: ListView.builder(
          itemCount: children?.length,
          controller: listCtrl.controller,
          shrinkWrap: true,
          physics: disableScrolling
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            top: paddingListTop,
            bottom: paddingListBottom,
            right: paddingListHorizontal,
            left: paddingListHorizontal,
          ),
          cacheExtent: 100000,
          itemBuilder: (context, index) {
            final key = Key(index.toString());
            // UniqueKey();
            final child = children?.elementAt(index);
            if (child != null) {
              // if (child.sectionCtrl.isSectionOpen.value) {
              //   listCtrl.openSections.add(key);
              // }

              return AutoScrollTag(
                key: key,
                // key: ValueKey(key),
                controller: listCtrl.controller,
                index: index,
                child: AccordionSection(
                  key: key,
                  uniqueKey: key,
                  index: index++,
                  isOpen: child.sectionCtrl.isSectionOpen.value,
                  scrollIntoViewOfItems: scrollIntoViewOfItems,
                  headerBackgroundColor:
                      child.headerBackgroundColor ?? headerBackgroundColor,
                  headerBackgroundColorOpened:
                      child.headerBackgroundColorOpened ??
                          headerBackgroundColorOpened ??
                          headerBackgroundColor,
                  headerBorderRadius:
                      child.headerBorderRadius ?? headerBorderRadius,
                  headerPadding: child.headerPadding ?? headerPadding,
                  header: child.header,
                  leftIcon: child.leftIcon ?? leftIcon,
                  rightIcon: child.rightIcon ??
                      rightIcon ??
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white60,
                        size: 20,
                      ),
                  disableBorderContent: child.disableBorderContent?.value ??
                      disableBorderContent?.value,
                  flipRightIconIfOpen: child.flipRightIconIfOpen?.value ??
                      flipRightIconIfOpen?.value,
                  paddingBetweenClosedSections:
                      child.paddingBetweenClosedSections ??
                          paddingBetweenClosedSections,
                  paddingBetweenOpenSections:
                      child.paddingBetweenOpenSections ??
                          paddingBetweenOpenSections,
                  content: child.content,
                  contentBackgroundColor:
                      child.contentBackgroundColor ?? contentBackgroundColor,
                  contentBorderColor:
                      child.contentBorderColor ?? contentBorderColor,
                  contentBorderWidth:
                      child.contentBorderWidth ?? contentBorderWidth,
                  contentBorderRadius:
                      child.contentBorderRadius ?? contentBorderRadius,
                  contentHorizontalPadding: child.contentHorizontalPadding ??
                      contentHorizontalPadding,
                  contentVerticalPadding:
                      child.contentVerticalPadding ?? contentVerticalPadding,
                  sectionOpeningHapticFeedback:
                      child.sectionOpeningHapticFeedback ??
                          sectionOpeningHapticFeedback,
                  sectionClosingHapticFeedback:
                      child.sectionClosingHapticFeedback ??
                          sectionClosingHapticFeedback,
                ),
              );
            } else {
              return Container();
            }
          }
          // children: children!.map(
          //   (child) {
          //     final key = UniqueKey();

          //     if (child.sectionCtrl.isSectionOpen.value) {
          //       listCtrl.openSections.add(key);
          //     }

          //     return AutoScrollTag(
          //       key: ValueKey(key),
          //       controller: listCtrl.controller,
          //       index: index,
          //       child: AccordionSection(
          //         uniqueKey: key,
          //         index: index++,
          //         isOpen: child.sectionCtrl.isSectionOpen.value,
          //         scrollIntoViewOfItems: scrollIntoViewOfItems,
          //         headerBackgroundColor:
          //             child.headerBackgroundColor ?? headerBackgroundColor,
          //         headerBackgroundColorOpened:
          //             child.headerBackgroundColorOpened ??
          //                 headerBackgroundColorOpened ??
          //                 headerBackgroundColor,
          //         headerBorderRadius:
          //             child.headerBorderRadius ?? headerBorderRadius,
          //         headerPadding: child.headerPadding ?? headerPadding,
          //         header: child.header,
          //         leftIcon: child.leftIcon ?? leftIcon,
          //         rightIcon: child.rightIcon ??
          //             rightIcon ??
          //             const Icon(
          //               Icons.keyboard_arrow_down,
          //               color: Colors.white60,
          //               size: 20,
          //             ),
          //         flipRightIconIfOpen: child.flipRightIconIfOpen?.value ??
          //             flipRightIconIfOpen?.value,
          //         paddingBetweenClosedSections:
          //             child.paddingBetweenClosedSections ??
          //                 paddingBetweenClosedSections,
          //         paddingBetweenOpenSections: child.paddingBetweenOpenSections ??
          //             paddingBetweenOpenSections,
          //         content: child.content,
          //         contentBackgroundColor:
          //             child.contentBackgroundColor ?? contentBackgroundColor,
          //         contentBorderColor:
          //             child.contentBorderColor ?? contentBorderColor,
          //         contentBorderWidth:
          //             child.contentBorderWidth ?? contentBorderWidth,
          //         contentBorderRadius:
          //             child.contentBorderRadius ?? contentBorderRadius,
          //         contentHorizontalPadding:
          //             child.contentHorizontalPadding ?? contentHorizontalPadding,
          //         contentVerticalPadding:
          //             child.contentVerticalPadding ?? contentVerticalPadding,
          //         sectionOpeningHapticFeedback:
          //             child.sectionOpeningHapticFeedback ??
          //                 sectionOpeningHapticFeedback,
          //         sectionClosingHapticFeedback:
          //             child.sectionClosingHapticFeedback ??
          //                 sectionClosingHapticFeedback,
          //       ),
          //     );
          //   },
          // ).toList(),
          ),
    );

    // return Scrollbar(
    //   controller: listCtrl.controller,
    //   child: ListView(
    //     controller: listCtrl.controller,
    //     shrinkWrap: true,
    //     physics: disableScrolling
    //         ? const NeverScrollableScrollPhysics()
    //         : const AlwaysScrollableScrollPhysics(),
    //     padding: EdgeInsets.only(
    //       top: paddingListTop,
    //       bottom: paddingListBottom,
    //       right: paddingListHorizontal,
    //       left: paddingListHorizontal,
    //     ),
    //     cacheExtent: 100000,
    //     children: children!.map(
    //       (child) {
    //         final key = UniqueKey();

    //         if (child.sectionCtrl.isSectionOpen.value) {
    //           listCtrl.openSections.add(key);
    //         }

    //         return AutoScrollTag(
    //           key: ValueKey(key),
    //           controller: listCtrl.controller,
    //           index: index,
    //           child: AccordionSection(
    //             uniqueKey: key,
    //             index: index++,
    //             isOpen: child.sectionCtrl.isSectionOpen.value,
    //             scrollIntoViewOfItems: scrollIntoViewOfItems,
    //             headerBackgroundColor:
    //                 child.headerBackgroundColor ?? headerBackgroundColor,
    //             headerBackgroundColorOpened:
    //                 child.headerBackgroundColorOpened ??
    //                     headerBackgroundColorOpened ??
    //                     headerBackgroundColor,
    //             headerBorderRadius:
    //                 child.headerBorderRadius ?? headerBorderRadius,
    //             headerPadding: child.headerPadding ?? headerPadding,
    //             header: child.header,
    //             leftIcon: child.leftIcon ?? leftIcon,
    //             rightIcon: child.rightIcon ??
    //                 rightIcon ??
    //                 const Icon(
    //                   Icons.keyboard_arrow_down,
    //                   color: Colors.white60,
    //                   size: 20,
    //                 ),
    //             flipRightIconIfOpen: child.flipRightIconIfOpen?.value ??
    //                 flipRightIconIfOpen?.value,
    //             paddingBetweenClosedSections:
    //                 child.paddingBetweenClosedSections ??
    //                     paddingBetweenClosedSections,
    //             paddingBetweenOpenSections: child.paddingBetweenOpenSections ??
    //                 paddingBetweenOpenSections,
    //             content: child.content,
    //             contentBackgroundColor:
    //                 child.contentBackgroundColor ?? contentBackgroundColor,
    //             contentBorderColor:
    //                 child.contentBorderColor ?? contentBorderColor,
    //             contentBorderWidth:
    //                 child.contentBorderWidth ?? contentBorderWidth,
    //             contentBorderRadius:
    //                 child.contentBorderRadius ?? contentBorderRadius,
    //             contentHorizontalPadding:
    //                 child.contentHorizontalPadding ?? contentHorizontalPadding,
    //             contentVerticalPadding:
    //                 child.contentVerticalPadding ?? contentVerticalPadding,
    //             sectionOpeningHapticFeedback:
    //                 child.sectionOpeningHapticFeedback ??
    //                     sectionOpeningHapticFeedback,
    //             sectionClosingHapticFeedback:
    //                 child.sectionClosingHapticFeedback ??
    //                     sectionClosingHapticFeedback,
    //           ),
    //         );
    //       },
    //     ).toList(),
    //   ),
    // );
  }
}
