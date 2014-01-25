library EventableExample;


import 'package:eventable/eventable.dart';


part 'bark_event.dart';
part 'cat.dart';
part 'dog.dart';


/**
 * trivial example just to show basic usage pattern
 */
void main(){

  var dog = new Dog();
  var cat = new Cat();

  cat.listen(dog, Dog.BARK, cat.dogBarkHandler);

  dog.bark(9);  // cat not disturbed
  dog.bark(11); // cat runs away

}