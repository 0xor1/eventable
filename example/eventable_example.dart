/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library eventable.example;

import 'package:eventable/eventable.dart';

part 'bark.dart';
part 'cat.dart';
part 'dog.dart';

/**
 * trivial example just to show basic usage pattern
 */
void main(){

  var dog = new Dog();
  var cat = new Cat();

  cat.listen(dog, Bark, cat.dogBarkHandler);

  dog.bark(9);  // cat not disturbed
  dog.bark(11); // cat runs away

}