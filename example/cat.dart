/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of EventableExample;

class Cat extends Object with EventDetector{

  void dogBarkHandler(BarkEvent event){
    if(event.volume > 10){
      runaway();
    }else{
      print('cat not disturbed');
    }
  }

  void runaway(){
    print('cat running away');
  }

}