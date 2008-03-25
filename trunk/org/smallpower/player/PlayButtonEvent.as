package org.smallpower.player {
  import flash.events.*;
  
  public class PlayButtonEvent extends Event {
    public static const PLAY_CLICK:String = "playclick";
    public var state:String;
    
    public function PlayButtonEvent (type:String, bubbles:Boolean = false, cancelable:Boolean = false, state:String = "") {
      super(type, bubbles, cancelable);
      this.state = state;
    }
    
    public override function clone():Event {
      return new PlayButtonEvent(type, bubbles, cancelable, state);
    }
    
    public override function toString():String {
      return formatToString("PlayButtonEvent", "type", "bubbles", "cancelable", "eventPhase", "state");
    }
  }
  
}
