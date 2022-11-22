import 'package:twitter_dl/twitter_dl.dart';

void main() async {
  final Twitter twitter = Twitter();
  // paste your twitter post link or id
  final result = await twitter.get('1589715742684954624');
  print(result);
}
