import 'dart:developer';

import 'homeDrawer.dart';
import 'package:flutter/material.dart';

class DrawerUserController extends StatefulWidget {
  final double drawerWidth;
  final Function(DrawerIndex) onDrawerCall;
  final Widget? screenView;
  final Function(AnimationController) animationController;
  final Function(bool)? drawerIsOpen;
  final AnimatedIconData animatedIconData;
  final Widget? menuView;
  final DrawerIndex? screenIndex;

  const DrawerUserController({
    Key? key,
    this.drawerWidth = 200,
    required this.onDrawerCall,
    this.screenView,
    required this.animationController,
    this.animatedIconData = AnimatedIcons.arrow_menu,
    this.menuView,
     this.drawerIsOpen,
    this.screenIndex,
  }) : super(key: key);
  @override
  _DrawerUserControllerState createState() => _DrawerUserControllerState();
}

class _DrawerUserControllerState extends State<DrawerUserController>
    with TickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController iconAnimationController;
  late AnimationController animationController;

  double scrollOffset = 0.0;
  bool isSetDrawer = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    iconAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 0));
    iconAnimationController.animateTo(1.0,
        duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
    scrollController =
        ScrollController(initialScrollOffset: widget.drawerWidth);
    scrollController
      .addListener(() {
        if (scrollController.offset <= 0) {
          if (scrollOffset != 1.0) {
            setState(() {
              scrollOffset = 1.0;
              try {
                widget.drawerIsOpen!(true);
              } catch (e) {
                log(e.toString());
              }
            });
          }
          iconAnimationController.animateTo(0.0,
              duration: const Duration(milliseconds: 0), curve: Curves.linear);
        } else if (scrollController.offset > 0 &&
            scrollController.offset < widget.drawerWidth) {
          iconAnimationController.animateTo(
              (scrollController.offset * 100 / (widget.drawerWidth)) / 100,
              duration: const Duration(milliseconds: 0),
              curve: Curves.linear);
        } else if (scrollController.offset <= widget.drawerWidth) {
          if (scrollOffset != 0.0) {
            setState(() {
              scrollOffset = 0.0;
              try {
                widget.drawerIsOpen!(false);
              } catch (e) {
                log(e.toString());
              }
            });
          }
          iconAnimationController.animateTo(1.0,
              duration: const Duration(milliseconds: 0), curve: Curves.linear);
        }
      });
    getInitState();
    super.initState();
  }

  Future<bool> getInitState() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      widget.animationController(iconAnimationController);
    } catch (e) {
      log(e.toString());
    }
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.jumpTo(
      widget.drawerWidth,
    );
    setState(() {
      isSetDrawer = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        // scrolloffset == 1.0
        //     ? PageScrollPhysics(parent: ClampingScrollPhysics())
        //     : PageScrollPhysics(parent: NeverScrollableScrollPhysics()),
        child: Opacity(
          opacity: isSetDrawer ? 1 : 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + widget.drawerWidth,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: widget.drawerWidth,
                  height: MediaQuery.of(context).size.height,
                  child: AnimatedBuilder(
                    animation: iconAnimationController,
                    builder: (BuildContext context, Widget? child) {
                      return  Transform(
                        transform:  Matrix4.translationValues(
                            scrollController.offset, 0.0, 0.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: widget.drawerWidth,
                          child: HomeDrawer(
                            screenIndex: widget.screenIndex == null
                                ? DrawerIndex.Home
                                : widget.screenIndex as DrawerIndex,
                            iconAnimationController: iconAnimationController,
                            callBackIndex: (DrawerIndex indexType) {
                              onDrawerClick();
                              try {
                                widget.onDrawerCall(indexType);
                              } catch (e) {
                                log(e.toString());
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Theme.of(context).accentColor.withOpacity(0.5),
                            blurRadius: 24),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        IgnorePointer(
                          ignoring: scrollOffset == 1 ? true : false,
                          child: widget.screenView ?? Container(
                                  color: Colors.white,
                                ),
                        ),
                        scrollOffset == 1.0
                            ? InkWell(
                                onTap: () {
                                  onDrawerClick();
                                },
                              )
                            : const SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 8,
                              left: 8),
                          child: SizedBox(
                            width: AppBar().preferredSize.height - 8,
                            height: AppBar().preferredSize.height - 8,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:  BorderRadius.circular(
                                    AppBar().preferredSize.height),
                                child: Center(
                                  child: widget.menuView ?? AnimatedIcon(
                                          icon: widget.animatedIconData ,
                                          color: Colors.transparent,
                                          progress: iconAnimationController),
                                ),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  onDrawerClick();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDrawerClick() {
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        widget.drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
