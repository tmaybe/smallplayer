package org.smallpower.player {
    
    public class Prefs {
      // default background color
      public static var BACKGROUND_COLOR:Number = 0x0000ff;
      // default play/pause state
      public static var STATE_PLAY:String = "play";
      public static var STATE_PAUSE:String = "pause";
      public static var INITIAL_STATE:String = STATE_PLAY;
      // default auto rewind
      public static var AUTO_REWIND:Boolean = true;
      // circular button dimensions
      public static var BUTTON_RADIUS:int = 23;
      public static var BUTTON_BORDER_THICK:int = 2;
      public static var BUTTON_BORDER_CLR:Number = 0xffffff;
      public static var BUTTON_FILL_CLR:Number = 0x333333;
      public static var BUTTON_FILL_ALPHA:Number = .6;
      public static var BUTTON_SYMBOL_RADIUS:int = 24;
      // delay before the pause button fades
      public static var PAUSE_BUTTON_FADE_DELAY:int = 1500;
      // loading/playing arc
      public static var PLAY_ARC_OFFSET:Number = 0; //Math.PI / 20;
      public static var PLAY_ARC_START:Number = (Math.PI / 2) - PLAY_ARC_OFFSET;
      public static var PLAY_ARC_SWEEP:Number = -((2 * Math.PI) - (2 * PLAY_ARC_OFFSET));
      public static var LOADED_ARC_RADIUS:Number = 26;
      public static var PLAYED_ARC_RADIUS:Number = 31;
      public static var DISTANCE_ARC_THICK:Number = 3;
      public static var LOADED_ARC_THICK:Number = 5;
      public static var PLAYED_ARC_THICK:Number = 2;
      public static var DISTANCE_ARC_CLR:Number = 0x767676;
      public static var DISTANCE_ARC_CLR_PULSE:Number = 0x565656;
      public static var LOADED_ARC_CLR:Number = 0x999999;
      public static var PLAYED_ARC_CLR:Number = 0xffffff;
      public static var PLAY_ARC_ALPHA:Number = 1;
    }
}