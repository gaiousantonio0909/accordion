import 'dart:async';
import 'dart:math';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// `AccordionSection` is one section within the `Accordion` widget.
/// Usage:
/// ```dart
/// Accordion(
///   disableBorderContent: true, // Optional
/// 	maxOpenSections: 1,
/// 	leftIcon: Icon(Icons.audiotrack, color: Colors.white),
/// 	children: [
/// 		AccordionSection(
/// 			isOpen: true,
/// 			header: Text('Introduction', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 			content: Icon(Icons.airplanemode_active, size: 200),
/// 		),
/// 		AccordionSection(
/// 			isOpen: true,
/// 			header: Text('About Us', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 			content: Icon(Icons.airline_seat_flat, size: 120),
/// 		),
/// 		AccordionSection(
/// 			isOpen: true,
/// 			header: Text('Company Info', style: TextStyle(color: Colors.white, fontSize: 20)),
/// 			content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
/// 		),
/// 	],
/// )
/// ```
class AccordionSection extends StatelessWidget with CommonParams {
  late final SectionController sectionCtrl;
  late final Key? uniqueKey;
  late final int index;

  /// The text to be displayed in the header
  final Widget header;

  /// The widget to be displayed as the content of the section when open
  final Widget content;

  AccordionSection({
    Key? key,
    this.uniqueKey,
    this.index = 0,
    bool isOpen = false,
    required this.header,
    required this.content,
    Color? headerBackgroundColor,
    Color? headerBackgroundColorOpened,
    double? headerBorderRadius,
    EdgeInsets? headerPadding,
    Widget? leftIcon,
    Widget? rightIcon,
    bool? flipRightIconIfOpen = true,
    Color? contentBackgroundColor,
    Color? contentBorderColor,
    bool? disableBorderContent = false,
    double? contentBorderWidth,
    double? contentBorderRadius,
    double? contentHorizontalPadding,
    double? contentVerticalPadding,
    double? paddingBetweenOpenSections,
    double? paddingBetweenClosedSections,
    ScrollIntoViewOfItems? scrollIntoViewOfItems,
    SectionHapticFeedback? sectionOpeningHapticFeedback,
    SectionHapticFeedback? sectionClosingHapticFeedback,
  }) : super(key: key) {
    sectionCtrl = SectionController();
    sectionCtrl.isSectionOpen.value = isOpen;

    // if (isOpen) listCtrl.openSections.add(Key(index.toString()));
    this.headerBackgroundColor = headerBackgroundColor;
    this.headerBackgroundColorOpened =
        headerBackgroundColorOpened ?? headerBackgroundColor;
    this.headerBorderRadius = headerBorderRadius;
    this.headerPadding = headerPadding;
    this.leftIcon = leftIcon;
    this.rightIcon = rightIcon;
    this.flipRightIconIfOpen?.value = flipRightIconIfOpen ?? true;
    this.disableBorderContent?.value = disableBorderContent ?? true;
    this.contentBackgroundColor = contentBackgroundColor;
    this.contentBorderColor = contentBorderColor;
    this.contentBorderWidth = contentBorderWidth ?? 1;
    this.contentBorderRadius = contentBorderRadius ?? 10;
    this.contentHorizontalPadding = contentHorizontalPadding ?? 10;
    this.contentVerticalPadding = contentVerticalPadding ?? 10;
    this.paddingBetweenOpenSections = paddingBetweenOpenSections ?? 10;
    this.paddingBetweenClosedSections = paddingBetweenClosedSections ?? 10;
    this.scrollIntoViewOfItems =
        scrollIntoViewOfItems ?? ScrollIntoViewOfItems.fast;
    this.sectionOpeningHapticFeedback = sectionOpeningHapticFeedback;
    this.sectionClosingHapticFeedback = sectionClosingHapticFeedback;
  }

  get _flipQuarterTurns =>
      flipRightIconIfOpen?.value == true ? (_isOpen ? 2 : 0) : 0;

  get _isOpen {
    // final open = listCtrl.openSections.contains(key);
    // final open = isOpen;
    // sectionCtrl.isSectionOpen.value =
    final open = sectionCtrl.isSectionOpen.value;

    Timer(
      sectionCtrl.firstRun
          ? (listCtrl.initialOpeningSequenceDelay + min(index * 200, 1000))
              .milliseconds
          : 0.seconds,
      () {
        if (Accordion.sectionAnimation) {
          sectionCtrl.controller
              .fling(velocity: open ? 1 : -1, springDescription: springFast);
        } else {
          sectionCtrl.controller.value = open ? 1 : 0;
        }
        sectionCtrl.firstRun = false;
      },
    );

    return open;
  }

  _playHapticFeedback(bool opening) {
    final feedback =
        opening ? sectionOpeningHapticFeedback : sectionClosingHapticFeedback;

    switch (feedback) {
      case SectionHapticFeedback.light:
        HapticFeedback.lightImpact();
        break;
      case SectionHapticFeedback.medium:
        HapticFeedback.mediumImpact();
        break;
      case SectionHapticFeedback.heavy:
        HapticFeedback.heavyImpact();
        break;
      case SectionHapticFeedback.selection:
        HapticFeedback.selectionClick();
        break;
      case SectionHapticFeedback.vibrate:
        HapticFeedback.vibrate();
        break;
      default:
    }
  }

  @override
  build(context) {
    final _borderRadius = headerBorderRadius ?? 10;

    return Obx(
      () => Column(
        // key: uniqueKey,
        children: [
          InkWell(
            onTap: () {
              // listCtrl.updateSections(key);
              sectionCtrl.isSectionOpen.toggle();

              _playHapticFeedback(_isOpen);

              if (_isOpen &&
                  scrollIntoViewOfItems != ScrollIntoViewOfItems.none &&
                  listCtrl.controller.hasClients) {
                Timer(
                  250.milliseconds,
                  () {
                    listCtrl.controller.cancelAllHighlights();
                    listCtrl.controller.scrollToIndex(index,
                        preferPosition: AutoScrollPosition.middle,
                        duration:
                            (scrollIntoViewOfItems == ScrollIntoViewOfItems.fast
                                    ? .5
                                    : 1)
                                .seconds);
                  },
                );
              }
            },
            child: AnimatedContainer(
              duration: Accordion.sectionAnimation
                  ? 750.milliseconds
                  : 0.milliseconds,
              curve: Curves.easeOut,
              alignment: Alignment.center,
              padding: headerPadding,
              decoration: BoxDecoration(
                color: (_isOpen
                        ? headerBackgroundColorOpened
                        : headerBackgroundColor) ??
                    Theme.of(context).primaryColor,
                borderRadius:  disableBorderContent == true ? null : BorderRadius.vertical(
                  top: Radius.circular(_borderRadius),
                  bottom: Radius.circular(_isOpen ? 0 : _borderRadius),
                ),
              ),
              child: Row(
                children: [
                  if (leftIcon != null) leftIcon!,
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: leftIcon == null ? 0 : 15),
                      child: header,
                    ),
                  ),
                  if (rightIcon != null)
                    RotatedBox(
                        quarterTurns: _flipQuarterTurns, child: rightIcon!),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: _isOpen
                    ? paddingBetweenOpenSections!
                    : paddingBetweenClosedSections!),
            child: SizeTransition(
              sizeFactor: sectionCtrl.controller,
              child: ScaleTransition(
                scale: sectionCtrl.controller,
                child: Center(
                  child: disableBorderContent == true
                      ? Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: disableBorderContent == true
                                  ? null
                                  : BorderRadius.vertical(
                                      bottom: Radius.circular(
                                          contentBorderRadius! / 1.02))),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: contentBackgroundColor,
                                borderRadius: disableBorderContent == true
                                    ? null
                                    : BorderRadius.vertical(
                                        bottom: Radius.circular(
                                            contentBorderRadius! / 1.02))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: contentHorizontalPadding!,
                                vertical: contentVerticalPadding!,
                              ),
                              child: Center(
                                child: content,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: contentBorderColor ??
                                Theme.of(context).primaryColor,
                            borderRadius: disableBorderContent == true
                                ? null
                                : BorderRadius.vertical(
                                    bottom:
                                        Radius.circular(contentBorderRadius!)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              contentBorderWidth ?? 1,
                              0,
                              contentBorderWidth ?? 1,
                              contentBorderWidth ?? 1,
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: disableBorderContent == true
                                      ? null
                                      : BorderRadius.vertical(
                                          bottom: Radius.circular(
                                              contentBorderRadius! / 1.02))),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: contentBackgroundColor,
                                    borderRadius: disableBorderContent == true
                                        ? null
                                        : BorderRadius.vertical(
                                            bottom: Radius.circular(
                                                contentBorderRadius! / 1.02))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: contentHorizontalPadding!,
                                    vertical: contentVerticalPadding!,
                                  ),
                                  child: Center(
                                    child: content,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
