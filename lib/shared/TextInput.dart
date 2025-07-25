import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final bool? isSuccess;
  final bool? isError;
  final String? errorText;
  final int? minLines;
  final int? maxLines;
  final bool? isMultiline;

  final String label;
  const TextInput({
    required this.controller,
    this.isSuccess,
    this.isError,
    this.errorText,
    required this.label,
    this.minLines,
    this.maxLines,
    this.isMultiline,
    super.key,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  Color borderColor = Colors.purple;

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      if (widget.isError == true) {
        borderColor = Colors.red;
      } else if (widget.isSuccess == true) {
        borderColor = Colors.green;
      } else {
        borderColor = Colors.purple;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          maxLines: widget.isMultiline == true ? (widget.maxLines ?? 3) : 1,
          minLines: widget.isMultiline == true ? (widget.minLines ?? 1) : null,
          keyboardType: widget.isMultiline == true
              ? TextInputType.multiline
              : TextInputType.text,
          decoration: InputDecoration(
            labelText: widget.label,
            alignLabelWithHint: false, // label всегда сверху
            floatingLabelAlignment: FloatingLabelAlignment.start, // прикрепить к верху
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        
        AnimatedOpacity(
          opacity: widget.isError == true ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 15.0,
            ), // уменьшил отступ сверху
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.errorText ?? '',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
