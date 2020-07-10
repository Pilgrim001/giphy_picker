library giphy_picker;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_search_page.dart';
import 'package:giphy_picker/src/widgets/media_bottom_sheet.dart';

export 'package:giphy_picker/src/widgets/giphy_image.dart';

typedef ErrorListener = void Function(dynamic error);

/// Provides Giphy picker functionality.
class GiphyPicker {
  /// Renders a full screen modal dialog for searching, and selecting a Giphy image.
  static Future<GiphyGif> pickGif({
    @required BuildContext context,
    @required String apiKey,
    @required AppBar appBar,
    Widget title,
    IconThemeData actionsIconTheme,
    IconThemeData iconTheme,
    Brightness brightness,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    ErrorListener onError,
    bool showPreviewPage = true,
    String searchText = 'Search gifs',
  }) async {
    GiphyGif result;

    PikerBottomSheet.show(context, animationDuraion: Duration(milliseconds: 600), tiles: [
      GiphyContext(
        child: GiphySearchPage(
          appBar: appBar,
          title: title,
          actionsIconTheme: actionsIconTheme,
          iconTheme: iconTheme,
          brightness: brightness,
        ),
        apiKey: apiKey,
        rating: rating,
        language: lang,
        onError:
        onError ?? (error) => _showErrorDialog(context, error),
        onSelected: (gif) {
          result = gif;

          // pop preview page if necessary
          if (showPreviewPage) {
            Navigator.pop(context);
          }
          // pop giphy_picker
          Navigator.pop(context);
        },
        showPreviewPage: showPreviewPage,
        searchText: searchText,
      )
    ]).then((value) {

    });

//    await Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (BuildContext context) => GiphyContext(
//                  child: GiphySearchPage(
//                    appBar: appBar,
//                    title: title,
//                    actionsIconTheme: actionsIconTheme,
//                    iconTheme: iconTheme,
//                    brightness: brightness,
//                  ),
//                  apiKey: apiKey,
//                  rating: rating,
//                  language: lang,
//                  onError:
//                      onError ?? (error) => _showErrorDialog(context, error),
//                  onSelected: (gif) {
//                    result = gif;
//
//                    // pop preview page if necessary
//                    if (showPreviewPage) {
//                      Navigator.pop(context);
//                    }
//                    // pop giphy_picker
//                    Navigator.pop(context);
//                  },
//                  showPreviewPage: showPreviewPage,
//                  searchText: searchText,
//                ),
//            fullscreenDialog: true));

    return result;
  }

  static void _showErrorDialog(BuildContext context, dynamic error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Giphy error'),
          content: new Text('An error occurred. $error'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
