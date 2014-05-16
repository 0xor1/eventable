/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of eventable.example;

class Cat extends Object with EventDetector{

  void dogBarkHandler(Event event){
    var bark = event.data as Bark;
    if(bark.volume > 10){
      runaway();
    }else{
      print('cat not disturbed');
    }
  }

  void runaway(){
    print('cat running away');
  }

}