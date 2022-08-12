import 'package:flutter/material.dart';

const double MARGIN_NORMAL = 16;
const double CHIP_BORDER_RADIUS = 30;
const double MARGIN_SMALL = 8;
const double PADDING_SMALL = 8;

enum CustomizedStepState { SELECTED, UNSELECTED }

enum Type { TOP, BOTTOM, LEFT, RIGHT }

class CustomizedStep {
  final String title;
  final Widget widget;
  bool isValid;
  CustomizedStepState state;

  CustomizedStep({
    required this.title,
    required this.widget,
    this.state = CustomizedStepState.UNSELECTED,
    required this.isValid,
  });
}

class CustomizedStepper extends StatefulWidget {
  final List<CustomizedStep> steps;
  final Color selectedColor;
  final double circleRadius;
  final Color unSelectedColor;
  final Color selectedOuterCircleColor;
  final TextStyle textStyle;
  final Color leftBtnColor;
  final Color rightBtnColor;
  final Type type;
  final VoidCallback onComplete;
  final Color btnTextColor;
  bool buttons;

  CustomizedStepper({
    required this.steps,
    required this.selectedColor,
    required this.circleRadius,
    required this.unSelectedColor,
    required this.selectedOuterCircleColor,
    required this.textStyle,
    this.type = Type.TOP,
    required this.leftBtnColor,
    required this.rightBtnColor,
    required this.btnTextColor,
    required this.onComplete,
    required this.buttons,
  });

  @override
  State<StatefulWidget> createState() => _CustomizedStepState(
    steps: this.steps,
    selectedColor: selectedColor,
    unSelectedColor: unSelectedColor,
    circleRadius: circleRadius,
    selectedOuterCircleColor: selectedOuterCircleColor,
    textStyle: textStyle,
    type: type,
    leftBtnColor: leftBtnColor,
    rightBtnColor: rightBtnColor,
    onComplete: onComplete,
    btnTextColor: btnTextColor,
  );
}

class _CustomizedStepState extends State<StatefulWidget> {
  final List<CustomizedStep> steps;
  final Color selectedColor;
  final Color unSelectedColor;
  final double circleRadius;
  final TextStyle textStyle;
  final Type type;
  final Color leftBtnColor;
  final Color rightBtnColor;
  final VoidCallback onComplete;
  final Color btnTextColor;

  Color selectedOuterCircleColor;
  PageController _controller = PageController();
  int currentStep = 0;

  _CustomizedStepState({
    required this.steps,
    required this.selectedColor,
    required this.circleRadius,
    required this.unSelectedColor,
    required this.selectedOuterCircleColor,
    required this.textStyle,
    required this.type,
    required this.leftBtnColor,
    required this.rightBtnColor,
    required this.onComplete,
    required this.btnTextColor,
  });

  @override
  void initState() {
    _controller = PageController();
    _controller.addListener(() {
      if (!steps[currentStep].isValid) {
        _controller.jumpToPage(currentStep);
      }
    });
    super.initState();
  }

  void changeStatus(int index) {
    if (isForward(index)) {
      markAsCompletedForPrecedingSteps();
    } else {
      markAsUnselectedToSucceedingSteps();
    }
    setState(() {
      currentStep = index;
      steps[index].state =CustomizedStepState.SELECTED;
    });
  }

  void markAsUnselectedToSucceedingSteps() {
    for (int i = steps.length - 1; i >= currentStep; i--) {
      steps[i].state = CustomizedStepState.UNSELECTED;
    }
  }

  void markAsCompletedForPrecedingSteps() {
    for (int i = 0; i <= currentStep; i++) {
      steps[i].state = CustomizedStepState.SELECTED;
    }
  }

  bool _isLast(int index) {
    return steps.length - 1 == index;
  }
/////////////////// here

   void _goToPage(int k) {
    currentStep = k;
    setState(() {});
    _controller.jumpToPage(k);
    // this is the key to your fault
    markAsCompletedForPrecedingSteps();

  }
  void _goToNextPage() {
    if (_isLast(currentStep)) {
      onComplete.call();
    }
    if (currentStep < steps.length - 1) {
      currentStep++;
      setState(() {});
      _controller.jumpToPage(currentStep);
    }
  }

  void _goToPreviousPage() {
    if (currentStep > 0) {
      currentStep--;
      _controller.jumpToPage(currentStep);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return (type == Type.TOP || type == Type.BOTTOM) ?
    Column(
      children: type == Type.TOP ? _getTopTypeWidget(width):_getBottomTypeWidget(width),
    ):
        Row(
          children:  type == Type.LEFT ? _getLeftTypeWidget(height) :
    _getRightTypeWidget(height),
        );
  }

  List<Widget> _getBottomTypeWidget(double width) {
    return [
      _getPageWidgets(),
      _getIndicatorWidgets(width),
      const SizedBox(
        height: MARGIN_SMALL,
      ),
      _getTitleWidgets(),
      _getButtons()
    ];
  }

  Widget _getPageWidgets() {
    return Expanded(
      child: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() {
          changeStatus(index);
        }),
        children: _getPages(),
      ),
    );
  }
  Widget _getPageWidgetsOnSide() {
    return SizedBox(
      child: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() {
          changeStatus(index);
        }),
        children: _getPages(),
      ),
    );
  }

  Widget _getTitleWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: getTitles(),
    );
  }
  Widget _getTitleWidgetsOnSide() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Widget _getIndicatorWidgets(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: PADDING_SMALL,
        bottom: PADDING_SMALL
      ),
      child:Container(
        child: Column(
              children: <Widget>[
                Row(
                  children: _getStepCircles(),
                )
              ],
            ),
      ),
    );
  }
 Widget _getIndicatorWidgetsOnSide(double width) {
    return Container(
      width: width,
      height: MediaQuery.of(context).size.height-50.0,
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: PADDING_SMALL,
        bottom: PADDING_SMALL
      ),
      child:SizedBox(
        //height: MediaQuery.of(context).size.height-100.0,
        //width: 40.0,
        child: Row(
            children: <Widget>[
              Column(
                children: _getStepCircles(),
              )
            ],
          ),
      )
    );

  }

  List<Widget> _getTopTypeWidget(double width) {
    return [
      _getIndicatorWidgets(width),
      SizedBox(
        height: MARGIN_SMALL,
      ),
      _getTitleWidgets(),
      _getPageWidgets(),
      // hey boy uncomment this if you want buttons
      _getButtons()
    ];
  }
  List<Widget> _getLeftTypeWidget(double height) {
    return [
      _getIndicatorWidgetsOnSide(height),
      SizedBox(
        width: MARGIN_SMALL,
      ),
      _getTitleWidgetsOnSide(),
      _getPageWidgetsOnSide(),
      // hey boy uncomment this if you want buttons
      _getButtons()
    ];
  }

  List<Widget> _getRightTypeWidget(double height) {
    return [
      _getIndicatorWidgetsOnSide(height),
      SizedBox(
        height: MARGIN_SMALL,
      ),
      _getTitleWidgetsOnSide(),
      _getPageWidgetsOnSide(),
      _getButtonsOnSide(),
      // hey boy uncomment this if you want buttons
      //_getButtons()
    ];
  }

  Widget _getButtons() {
    return Container(
      padding: const EdgeInsets.all(
        MARGIN_NORMAL,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onTap: () => _goToPreviousPage(),
              child: Container(
                padding: const EdgeInsets.all(
                  MARGIN_NORMAL,
                ),
                child: Center(
                  child: Text(
                    "BACK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      ///////////// heyyy i am here u idiot
                      color:  (btnTextColor != null) ? btnTextColor : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: leftBtnColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                    topLeft: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onTap: () => steps[currentStep].isValid ? _goToNextPage() : null,
              child: Container(
                padding: const EdgeInsets.all(
                  MARGIN_NORMAL,
                ),
                child: Center(
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 14,
                      color: (btnTextColor != null) ? btnTextColor : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                  color:
                  steps[currentStep].isValid ? rightBtnColor : Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                    topRight: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _getButtonsOnSide() {
    return Container(
      padding: const EdgeInsets.all(
        MARGIN_NORMAL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onTap: () => _goToPreviousPage(),
              child: Container(
                padding: const EdgeInsets.all(
                  MARGIN_NORMAL,
                ),
                child: Center(
                  child: Text(
                    "BACK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      ///////////// heyyy i am here u idiot
                      color:  (btnTextColor != null) ? btnTextColor : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: leftBtnColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                    topLeft: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onTap: () => steps[currentStep].isValid ? _goToNextPage() : null,
              child: Container(
                padding: const EdgeInsets.all(
                  MARGIN_NORMAL,
                ),
                child: Center(
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 14,
                      color: (btnTextColor != null) ? btnTextColor : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                  color:
                  steps[currentStep].isValid ? rightBtnColor : Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                    topRight: Radius.circular(
                      CHIP_BORDER_RADIUS,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> getTitles() {
    return steps
        .map((e) => Flexible(
      child: Center(
        child: Text(
          e.title,
          style: (textStyle != null) ? textStyle :
              const TextStyle(
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),
        ),
      ),
    ))
        .toList();
  }

  List<Widget> _getStepCircles() {
    List<Widget> widgets = [];
    steps.asMap().forEach((key, value) {
      widgets.add(
        InkWell(
          onTap: () {
            _goToPage(key);
          },
          child: _StepCircle(value, circleRadius, selectedColor,
              unSelectedColor, selectedOuterCircleColor, key+1),
        )
      );
      if (key != steps.length - 1) {
        widgets.add(_StepLine(
          steps[key + 1],
          selectedColor,
          unSelectedColor,
          type
        ));
      }
    });
    return widgets;
  }

  List<Widget> _getPages() {
    return steps.map((e) => e.widget).toList();
  }

  bool isForward(int index) {
    return index > currentStep;
  }
}

class _StepLine extends StatelessWidget {
  final CustomizedStep step;
  final Color selectedColor;
  final Color unSelectedColor;
  final Type type;

  _StepLine(
      this.step,
      this.selectedColor,
      this.unSelectedColor,
      this.type
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:  (type == Type.LEFT || type == Type.RIGHT) ?

        Container(
          margin: const EdgeInsets.only(
            top: 4,
            bottom: 4,
          ),
          width: 3,
          color: step.state == CustomizedStepState.SELECTED
              ? selectedColor
              : unSelectedColor,
        )

            :
        Container(
          margin: const EdgeInsets.only(
            left: 4,
            right: 4,
          ),
          height: 3,
          color: step.state == CustomizedStepState.SELECTED
              ? selectedColor
              : unSelectedColor,
        ));
  }
}

class _StepCircle extends StatelessWidget {
  final CustomizedStep step;
  final double circleRadius;
  final Color selectedColor;
  final Color unSelectedColor;
  final Color selectedOuterCircleColor;
  late final int currentStep;

  _StepCircle(
      this.step,
      this.circleRadius,
      this.selectedColor,
      this.unSelectedColor,
      this.selectedOuterCircleColor,
      this.currentStep
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: circleRadius,
      width: circleRadius,
      decoration: BoxDecoration(
        border: Border.all(
          width: _getColor() == this.selectedColor ? 0 : 2 ,
          color: _getColor(),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(circleRadius),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          _getColor() == this.selectedColor ? 0 : 2,
        ),
        child: Container(
          child: Center(
            child: Text(this.currentStep.toString() ,
            style: TextStyle(
              color: Colors.white
            ),),
          ),
            decoration: BoxDecoration(
              color: step.state == CustomizedStepState.SELECTED
                  ? selectedColor
                  : unSelectedColor,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  circleRadius,
                ),
              ),
            )),
      ),
    );
  }

  Color _getColor() {
    if (step.state == CustomizedStepState.SELECTED) {
      return selectedOuterCircleColor != null
          ? selectedOuterCircleColor
          : selectedColor;
    }
    return unSelectedColor;
  }
}