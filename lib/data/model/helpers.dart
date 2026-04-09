class PopupObject{
  final String title;
  final String body;
  final String ?buttonText;
  final Function onYesPressed;
  final bool hideTopRightCancelButton;
  PopupObject({required this.title, required this.body, required this.buttonText, required this.onYesPressed, this.hideTopRightCancelButton=false});
}