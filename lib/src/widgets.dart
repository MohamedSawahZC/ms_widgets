import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



typedef IconBuilder = Icon Function(double value, int index);

class defaultRate extends StatefulWidget {
  /// Allows half a start to be selectable, like 2.5 stars. Defaults to `false`
  final bool allowHalf;

  /// Allows clearing if clicked in the same points. Defaults to `true`
  final bool allowClear;

  /// If read only, click is blocked
  final bool readOnly;

  /// Size of the icon
  final double iconSize;

  /// Color of the icon
  final Color color;

  /// Initial value, defaults to `0`
  final double initialValue;

  /// Function called whenever the rating changes
  final void Function(double value)? onChange;

  /// Custom icon builder, in case you need something more customizable
  final IconBuilder? iconBuilder;

  const defaultRate({
    Key? key,
    this.allowHalf = false,
    this.allowClear = true,
    this.readOnly = false,
    this.iconSize = 24,
    this.color = Colors.yellow,
    this.initialValue = 0.0,
    this.onChange,
    this.iconBuilder,
  }) : super(key: key); // coverage:ignore-line

  @override
  State<defaultRate> createState() => _defaultRateState();
}

class _defaultRateState extends State<defaultRate> {
  double _value = 0;
  double? _hoverValue;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _valueChangeAction(double value) {
    final newValue = widget.allowClear && _value == value ? 0.0 : value;

    if (mounted) {
      setState(() => _value = newValue);
    }

    widget.onChange?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStar(0),
        _buildStar(1),
        _buildStar(2),
        _buildStar(3),
        _buildStar(4),
      ],
    );
  }

  Widget _buildStar(int index) {
    var icon =
        widget.iconBuilder?.call(_value, index) ?? _defaultIconBuilder(index);

    final iconSize = icon.size ?? widget.iconSize;

    return GestureDetector(
      key: Key('star_rate_$index'),
      onTapDown: widget.readOnly
          ? null
          : (details) {
        if (details.localPosition.dx < ((iconSize / 2) + 1) &&
            widget.allowHalf) {
          _valueChangeAction(index + 0.5);
        } else {
          _valueChangeAction(index + 1);
        }
      },
      child: MouseRegion(
        cursor: widget.readOnly ? MouseCursor.defer : SystemMouseCursors.click,
        onHover: widget.readOnly
            ? null
            : (event) {
          if (event.localPosition.dx < ((iconSize / 2) + 1) &&
              widget.allowHalf) {
            setState(() => _hoverValue = index + 0.5);
          } else {
            setState(() => _hoverValue = index + 1);
          }
        },
        onExit: widget.readOnly
            ? null
            : (_) {
          setState(() {
            _hoverValue = null;
          });
        },
        child: icon,
      ),
    );
  }

  Icon _defaultIconBuilder(int index) {
    var icon = (_hoverValue ?? _value) > index.toDouble()
        ? Icons.star
        : Icons.star_border;

    if (widget.allowHalf && (_hoverValue ?? _value) == (index + 0.5)) {
      icon = Icons.star_half;
    }

    return Icon(icon, size: widget.iconSize, color: widget.color);
  }
}


void defaultToast({
  required String? msg,
  required ToastStates? state,
  required double? fontSize,
  required ToastGravity? gravity,
  int? duration,
  required Color? textColor,
}){
  Fluttertoast.showToast(
      msg: msg!,
      backgroundColor: chooseToastColor(state!),
      textColor: textColor,
      gravity: gravity,
      fontSize: fontSize,
      timeInSecForIosWeb: duration!,
      toastLength: Toast.LENGTH_SHORT
  );
}

enum ToastStates { SUCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amberAccent;
      break;
  }
  return color;
}

class defaultExpansionTile extends StatelessWidget {
  final BorderRadius? borderRadius;
  final Widget? icon;
  final Color? unCollapsedIconColor;
  final Color? collapsedTextColor;
  final Color? unCollapsedTextColor;
  final Color? collapsedIconColor;
  final Color? unCollapsedBackgroundColor;
  final Color? collapsedBackgroundColor;
  final String? title;
  final TextStyle? titleStyle;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? children;
  defaultExpansionTile({
    this.borderRadius=BorderRadius.zero,
    this.icon,
    this.unCollapsedIconColor,
    this.title="",
    this.titleStyle,
    this.collapsedIconColor=Colors.blue,
    this.collapsedTextColor=Colors.blue,
    this.unCollapsedTextColor=Colors.blue,
    this.unCollapsedBackgroundColor=Colors.blue,
    this.padding,
    this.collapsedBackgroundColor=Colors.blue,
    this.children,
    this.elevation,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: elevation,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ExpansionTile(
          leading: icon,
          title:Text(
            title!,
            style: titleStyle,
          ),
          collapsedTextColor: collapsedTextColor,
          collapsedIconColor: collapsedIconColor,
          backgroundColor: unCollapsedBackgroundColor,
          iconColor: unCollapsedIconColor,
          textColor: unCollapsedTextColor,
          tilePadding: padding,
          collapsedBackgroundColor: collapsedBackgroundColor,
          children: children!,
        ),
      ),
    );
  }
}

class defaultButton extends StatelessWidget {
  double buttonWidth = double.infinity;
  double buttonHeight = 40;
  Color backgroundColor = Colors.blue;
  bool isUpperCase = false;
  final BorderRadiusGeometry? borderRadius ;
  VoidCallback function;
  String text;
  TextStyle textStyle;
  defaultButton({
    required this.buttonWidth,
    required this.buttonHeight,
    required this.backgroundColor,
    required this.function,
    required this.text,
    required this.textStyle,
    required this.isUpperCase,
    this.borderRadius = BorderRadius.zero,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: textStyle,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
    );
  }
}

class defaultTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Color borderColor;
  final Color? hintColor;
  final TextEditingController? textFieldController;
  final Function? suffixTap;
  final Function? validateTextField;
  final Function? onSubmit;
  final Color? filledColor;
  final Color? inputColor;
  final Color? labelColor;
  final bool isSecure;
  final int lineHeight;
  final double labelFontSize;
  final BorderRadius? borderRadius;
  final double hintFontSize;
  final double? width;
  final double? height;
  final bool enableEditing;

  const defaultTextFormField({
    Key? key,
    this.hintColor,
    this.labelColor,
    this.inputColor,
    this.width,
    this.height,
    this.borderRadius= BorderRadius.zero,
    this.hintText='',
    this.labelText="",
    this.prefixWidget,
    this.suffixWidget,
    this.borderColor = Colors.blue,
    this.textFieldController,
    this.suffixTap,
    this.onSubmit,
    this.enableEditing = true,
    this.validateTextField,
    this.filledColor = Colors.lightBlue,
    this.isSecure = false,
    this.lineHeight = 1,
    this.labelFontSize = 16,
    this.hintFontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        onFieldSubmitted: (String? value) {
          return onSubmit!(value);
        },
        enabled: enableEditing,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          height: 2,
          color: inputColor,
        ),
        controller: textFieldController,
        obscureText: isSecure,
        maxLines: lineHeight,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          errorStyle: const TextStyle(
            fontSize: 16,
          ),
          filled: true,
          fillColor: filledColor,
          hintText: hintText,
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          labelText: labelText,
          labelStyle: TextStyle(
            color: labelColor,
            fontSize: labelFontSize,
          ),
          hintStyle: TextStyle(
            fontSize: hintFontSize,
            color: hintColor,
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius! ,
            borderSide: BorderSide(
              color: borderColor,
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius!,
            borderSide: BorderSide(
              width: 0.5,
              style: BorderStyle.solid,
              color: borderColor,
            ),
          ),
          enabledBorder:OutlineInputBorder(
            borderRadius: borderRadius!,
            borderSide: BorderSide(
              width: 0.5,
              style: BorderStyle.solid,
              color: borderColor,
            ),
          ),
        ),
        validator: (String? value) {
          return validateTextField!(value);
        },

      ),
    );
  }
}


class defaultOnBoarding extends StatelessWidget {

  final Function? onPageChange;
  PageController? boardController;
  final List<BoardingModel> items;
  final double spacing;
  final double imageWidth;
  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;
  defaultOnBoarding({
    required this.onPageChange,
    required this.items,
    required this.boardController,
    required this.spacing,
    required this.titleTextStyle,
    required this.bodyTextStyle,
    required this.imageWidth,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        onPageChanged: (int? value) {
          return onPageChange!(value);
        },
        physics: const BouncingScrollPhysics(),
        controller: boardController,
        itemBuilder: (context, index) =>
            builBoardingItem(model:items[index],spacing:spacing,bodyTextStyle: bodyTextStyle,ImageWidth: imageWidth,titleTextStyle: titleTextStyle, ),
        itemCount: items.length,
      ),
    );
  }
}


class BoardingModel{
  final String image;
  final String title;
  final String body;
  BoardingModel({
    required this.title,
    required this.body,
    required this.image,
  });
}

class builBoardingItem extends StatelessWidget {
  final BoardingModel model;
  final double ImageWidth;
  final double spacing;
  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;
  builBoardingItem({
    required this.model,
    required this.ImageWidth,
    required this.spacing,
    required this.bodyTextStyle,
    required this.titleTextStyle,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(width: ImageWidth, image: AssetImage('${model.image}')),
        SizedBox(
          height: spacing,
        ),
        Text(
          textAlign: TextAlign.center,
          '${model.title}',
          style: titleTextStyle,
        ),
        SizedBox(
          height: spacing,
        ),
        Text(
          textAlign: TextAlign.center,
          '${model.body}',
          style: bodyTextStyle,
        ),
        SizedBox(
          height: spacing,
        ),
      ],
    );
  }
}

class defaultImageButtonWithText extends StatelessWidget {
  final Color? backgroundColor;
  final String? imagePath;
  final double? width;
  final double? height;
  final String? text;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback onPressed;
  defaultImageButtonWithText({
    this.backgroundColor = Colors.blue,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.text,
    this.borderRadius,
    this.textStyle,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor!,
              borderRadius: borderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(
                image: NetworkImage(
                  imagePath!,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text!,
          style: textStyle,
        ),
      ],
    );
  }
}

class defaultImageButtonWithText2 extends StatelessWidget {
  final Color? backgroundColor;
  final String? imagePath;
  final double? width;
  final double? height;
  final String? text;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback onPressed;
  defaultImageButtonWithText2({
    this.backgroundColor = Colors.blue,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.text,
    this.borderRadius,
    this.textStyle,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor!,
              borderRadius: borderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(
                image: AssetImage(
                  imagePath!,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text!,
          style: textStyle,
        ),
      ],
    );
  }
}

class defaultDropDownMenu extends StatelessWidget {
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget? icon;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? itemTextStyle;
  final String? selectedItem;
  final List<String>? items;
  final Function? onChanged;
  final Color? borderColor;
  final double? borderWidth;
  final Color? dropDownColor;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? contentPadding;
  defaultDropDownMenu({
    this.borderWidth=0,
    this.borderRadius=BorderRadius.zero,
    this.itemTextStyle,
    this.labelText='',
    required this.selectedItem,
    this.onChanged,
    this.icon,
    required this.items,
    this.borderColor=Colors.transparent,
    this.alignment=Alignment.centerLeft,
    this.backgroundColor=Colors.indigo,
    this.dropDownColor=Colors.indigo,
    this.labelStyle,
    this.contentPadding,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: icon,
      focusColor: Colors.indigo,
      style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
      decoration: InputDecoration(
        fillColor: backgroundColor,
        focusColor: backgroundColor,
        hoverColor: backgroundColor,
        labelText: labelText,
        filled: true,

        contentPadding: contentPadding,
        border: OutlineInputBorder(
            borderRadius: borderRadius!,
            borderSide: BorderSide(width: borderWidth!,color: borderColor!)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius!,
            borderSide: BorderSide(width: borderWidth!,color: borderColor!)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius!,
            borderSide: BorderSide(width: borderWidth!,color: borderColor!)
        ),
      ),
      value: selectedItem,
      onChanged: (item){
        return onChanged!(item);
      },
      dropdownColor: dropDownColor,
      borderRadius: borderRadius!,
      alignment: alignment!,
      items: items!
          .map(
            (item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: itemTextStyle,
          ),
        ),
      )
          .toList(),
    );
  }
}