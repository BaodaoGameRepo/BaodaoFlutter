import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gobang/common_widget/screen_sp.dart';

import 'constants/mj_colors.dart';


class MJStyleTextField extends StatefulWidget {
  final String hint;

  final String iconText;

  final String errorText;

  final double textSize;

  final bool isPassword;

  final TextEditingController textController;

  final TextInputType keyboardType;

  final List<TextInputFormatter> inputFormatters;

  final Color boardColor;

  const MJStyleTextField({
    Key? key,
    required this.hint,
    required this.textController,
    this.iconText = "",
    this.errorText = "",
    this.textSize = 15,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.boardColor = MJColors.black15,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MJStyleTextFieldState();
}

class _MJStyleTextFieldState extends State<MJStyleTextField> {
  late StreamController<int> streamController;

  late FocusNode node;

  bool display = false;

  @override
  void initState() {
    super.initState();
    node = FocusNode();
    streamController = StreamController();
    widget.textController.addListener(() {
      streamController.add(widget.textController.text.length);
    });
    node.addListener(onFocuseChange);
  }

  void onFocuseChange() {
    int n = 0;
    if (node.hasFocus) {
      n = widget.textController.text.length;
    } else {
      n = 0;
    }
    streamController.add(n);
  }

  @override
  Widget build(BuildContext context) {
    double padding = 20.csp;
    Widget icon = GestureDetector(
      onTap: () {
        node.unfocus();
      },
      child: Text(widget.iconText, style: TextStyle(fontSize: 16.csp, color: MJColors.black90)),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 0).csp,
      height: 44.csp,
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
          color: MJColors.blackLogin,
          borderRadius: BorderRadius.all(Radius.circular(12.csp)),
          border: Border.all(color: widget.boardColor, width: 0.5.csp),
      ),
      child: TextField(
          focusNode: node,
          cursorColor: MJColors.lightBlue,
          cursorWidth: 1.5,
          controller: widget.textController,
          keyboardType: widget.keyboardType,
          textAlignVertical: TextAlignVertical.center,
          inputFormatters: widget.inputFormatters,
          obscureText: widget.isPassword && !display,
          style: TextStyle(
              fontSize: widget.textSize.csp, color: MJColors.white, fontFamily: 'MiSans'),
          decoration: InputDecoration(
            isDense: true,
            icon: widget.iconText.isEmpty ? null : icon,
            errorText: widget.errorText.isEmpty ? null : widget.errorText,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: MJColors.black15, width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: MJColors.black60, width: 0.5),
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: widget.textSize.csp,
              color: MJColors.white30,
            ),
            suffixIcon: buildSuffixRow(widget.textController, streamController),
          )),
    );
  }

  Widget buildSuffixRow(
    TextEditingController controller,
    StreamController<int> streamController,
  ) {
    return StreamBuilder<int>(
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (snapshot.data != 0) buildClearIcon(),
            if (widget.isPassword) buildEyeIcon(),
          ],
        );
      },
      stream: streamController.stream,
      initialData: 0,
    );
  }

  Widget buildEyeIcon() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10).csp,
        child: SvgPicture.asset(
          display ? 'images/svg/icon_input_hide.svg' : 'images/svg/icon_input_show.svg',
          width: 16.csp,
          height: 16.csp,
        ),
      ),
      onTap: () {
        setState(() {
          display = !display;
        });
      },
    );
  }

  Widget buildClearIcon() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12).csp,
        child: SvgPicture.asset(
          'images/svg/icon_input_clear.svg',
          width: 16.csp,
        ),
      ),
      onTap: () {
        widget.textController.text = '';
      },
    );
  }
  //TODO:长度 ？？

  @override
  void dispose() {
    super.dispose();
    node.dispose();
  }
}
