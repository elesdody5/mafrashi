import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RatingDialog extends StatefulWidget {
  String productId;
  RatingDialog(this.productId);
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _reviewRating = 0;
  final _reviewNameController = TextEditingController();
  final _reviewCommentController = TextEditingController();
  Future<void> _submitReview() async {
    bool result = await Provider.of<ProductsProvider>(context, listen: false)
        .createProductReview(widget.productId, _reviewRating.toString(),
            _reviewNameController.text, _reviewCommentController.text);
    result ? _showSubmitReviewSuccessfully() : _showErrorDialog();
  }

  void _showSubmitReviewSuccessfully() {
    Alert(
      context: context,
      type: AlertType.success,
      title: AppLocalizations.of(context).translate('review_submitted'),
      style: AlertStyle(isCloseButton: false),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('continue'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(
            AppLocalizations.of(context).translate('something_went_wrong')),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBar(
            initialRating: 0,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Theme.of(context).accentColor,
            ),
            onRatingUpdate: (rating) {
              print(rating);
              _reviewRating = rating;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
              controller: _reviewNameController,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration.collapsed(
                hintText: AppLocalizations.of(context).translate('name'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey)),
              )),
          SizedBox(
            height: 20,
          ),
          TextFormField(
              maxLines: 10,
              minLines: 5,
              controller: _reviewCommentController,
              style: TextStyle(fontSize: 18),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('comment'),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey)),
              )),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).translate('cancel')),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).translate('submit')),
          onPressed: () {
            _submitReview();
          },
        ),
      ],
    );
  }
}
