import 'package:flutter/material.dart';

class CAMTextField extends StatefulWidget {
  const CAMTextField(
      {super.key,
      this.obscureText = false,
      this.keyboardType,
      this.hintText,
      this.onSubmitted,
      this.textInputAction = TextInputAction.next,
      this.controller,
      this.autofillHints,
      this.autofocus,
      this.maxLines = 1,
      this.showsClearButton = true,
      this.scrollPadding});

  final TextEditingController? controller;
  final bool showsClearButton;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool? autofocus;
  final int? maxLines;
  final EdgeInsets? scrollPadding;

  @override
  State<CAMTextField> createState() => _CAMTextFieldState();
}

class _CAMTextFieldState extends State<CAMTextField> {
  bool _obscureTextIsVisible = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller?.text.isNotEmpty == true;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        setState(() {
          _hasText = text.isNotEmpty;
        });
      },
      controller: widget.controller,
      obscureText: widget.obscureText && !_obscureTextIsVisible,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      autofillHints: widget.autofillHints,
      autofocus: widget.autofocus == true,
      maxLines: widget.maxLines,
      scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          suffixIcon: _buildSuffixIcon()),
    );
  }

  Widget? _buildSuffixIcon() {
    if (!_hasText || (!widget.showsClearButton && !widget.obscureText)) {
      return null;
    }
    return Focus(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        child: Builder(builder: (context) {
          if (widget.obscureText) {
            return IconButton(
              icon: Icon(_obscureTextIsVisible
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureTextIsVisible = !_obscureTextIsVisible;
                });
              },
            );
          }
          if (widget.showsClearButton) {
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.controller?.clear();
                setState(() {
                  _hasText = false;
                });
              },
            );
          }
          return const SizedBox();
        }));
  }
}
