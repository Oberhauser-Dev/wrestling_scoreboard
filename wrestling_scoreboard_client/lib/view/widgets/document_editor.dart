import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrestling_scoreboard_client/view/widgets/font.dart';

class DocumentEditor extends StatelessWidget {
  final QuillController quillController;

  const DocumentEditor({super.key, required this.quillController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillSimpleToolbar(
          controller: quillController,
          config: QuillSimpleToolbarConfig(
            buttonOptions: QuillSimpleToolbarButtonOptions(
              fontSize: const QuillToolbarFontSizeButtonOptions(
                items: {
                  'Clear': '0',
                  '6 px': '6',
                  '8 px': '8',
                  '10 px': '10',
                  '12 px': '12',
                  '14 px': '14',
                  '16 px': '16',
                  '18 px': '18',
                  '22 px': '22',
                  '26 px': '26',
                  '30 px': '30',
                  '32 px': '32',
                  '34 px': '34',
                  '38 px': '38',
                  '42 px': '42',
                  '44 px': '44',
                  '64 px': '64',
                  '96 px': '96',
                  '128 px': '128',
                },
              ),
              fontFamily: QuillToolbarFontFamilyButtonOptions(
                items: Font.supportedFontFamilies.asMap().map((key, value) => MapEntry(value, value)),
                renderFontFamilies: true,
                childBuilder: (dynamic options, dynamic extraOptions) {
                  return _FontButton(
                    controller: quillController,
                    options: (options as QuillToolbarFontFamilyButtonOptions),
                    extraOptions: extraOptions,
                  );
                },
              ),
            ),
            showAlignmentButtons: true,
            showLineHeightButton: true,
          ),
        ),
        AspectRatio(
          aspectRatio: 1 / math.sqrt(2),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.onSurface)),
            child: QuillEditor.basic(
              controller: quillController,
              config: QuillEditorConfig(
                textSpanBuilder: (context, node, nodeOffset, text, style, recognizer) {
                  return TextSpan(
                    text: text,
                    style: style?.fontFamily == null
                        ? style
                        : GoogleFonts.getFont(style!.fontFamily!, textStyle: style),
                    recognizer: recognizer,
                    mouseCursor: (recognizer != null) ? SystemMouseCursors.click : null,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FontButton extends StatelessWidget {
  final QuillController controller;
  final QuillToolbarFontFamilyButtonOptions options;
  final QuillToolbarFontFamilyButtonExtraOptions extraOptions;

  const _FontButton({required this.options, required this.extraOptions, required this.controller});

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      isSelected: false,
      onPressed: () {
        Font.showFontDialog(
          context,
          supportedFontFamilies: options.items?.keys,
          initialFontFamily: extraOptions.currentValue,
          onSelect: (value) {
            controller.formatSelection(Attribute.fromKeyValue(Attribute.font.key, value == 'Clear' ? null : value));
            options.onSelected?.call(value ?? 'Clear');
          },
        );
      },
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(extraOptions.currentValue), Icon(Icons.arrow_drop_down)],
      ),
      iconTheme: null,
    );
  }
}
