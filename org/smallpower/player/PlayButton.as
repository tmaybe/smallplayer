package org.smallpower.player {
  import flash.display.*;
  import flash.events.*;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.utils.Timer;
  import gs.TweenLite;
  
  public class PlayButton extends Sprite {
    // state can be Prefs.STATE_PAUSE or Prefs.STATE_PLAY
    private var _state:String;
    private var _catcher:Sprite;
    private var _bg:Sprite;
    private var _symbol:Sprite;
    private var _arcDistance:Sprite;
    private var _arcLoaded:Sprite;
    private var _arcPlayed:Sprite;
    private var _timer:Timer;
    private var _fadeTargets:Object;
    private var _showing:Boolean;
    
    private var _output:TextField;
    
    public function PlayButton(initialState:String, wide:int, high:int) {
      // verify & save the initial play state
      _state = (initialState == Prefs.STATE_PAUSE || initialState == Prefs.STATE_PLAY) ? initialState : Prefs.INITIAL_STATE;
      // initiate the fade targets
      _fadeTargets = new Object();
      _fadeTargets.show = 1;
      _fadeTargets.hide = 1; 
      _showing = false;
      // create the timer object
      _timer = new Timer(Prefs.PAUSE_BUTTON_FADE_DELAY, 1);
      // subscribe to its event
      _timer.addEventListener(TimerEvent.TIMER, timerListener);
      // add a stage-sized transparent square to catch mouse-move events
      _catcher = new Sprite();
      _catcher.graphics.beginFill(0x000000);
      _catcher.graphics.lineStyle();
      _catcher.graphics.drawRect(-wide / 2, -high / 2, wide, high);
      _catcher.graphics.endFill();
      hitArea = _catcher;
      _catcher.visible = false;
      addChild(_catcher);
      // draw the button
      _bg = new Sprite();
      _symbol = new Sprite();
      drawBackground();
      drawSymbol();
      addChild(_bg);
      addChild(_symbol);
      // create the sprites for showing load/play progress
      _arcDistance = new Sprite();
      _arcLoaded = new Sprite();
      _arcPlayed = new Sprite();
      addChild(_arcDistance);
      addChild(_arcPlayed);
      addChild(_arcLoaded);
      // draw the distance arc
      bandAt(
        _arcDistance, 0, 0, Prefs.PLAY_ARC_START, Prefs.PLAY_ARC_SWEEP, Prefs.LOADED_ARC_RADIUS,
        Prefs.DISTANCE_ARC_THICK, Prefs.DISTANCE_ARC_CLR, Prefs.PLAY_ARC_ALPHA
      );
      // register for mouse events
      addEventListener(MouseEvent.CLICK, clickListener);
      buttonMode = true;
      mouseChildren = false;
      
      // :TODO: tmp set up the output field
      //_output = new TextField();
      //_output.autoSize = TextFieldAutoSize.LEFT;
      //addChild(_output);
    }
    
    public function setState(newState:String):void {
      // verify & save the new play state
      _state = (newState == Prefs.STATE_PAUSE || newState == Prefs.STATE_PLAY) ? newState : _state;
      // redraw the button
      drawSymbol();
      // start or stop watching the mouse for cues to behavior
      payAttentionAfterStateChange();
    }
    
    private function payAttentionAfterStateChange():void {
      if (_state == Prefs.STATE_PAUSE) {
        // start paying attention
        restartFadeTimer();
        startWatchingMouse();
      } else if (_state == Prefs.STATE_PLAY) {
        // stop paying attention
        _timer.reset();
        stopWatchingMouse();
        // make sure the button's visible
        showButton();
      }
    }
    
    private function startWatchingMouse():void {
      addEventListener(MouseEvent.MOUSE_MOVE, moveListener);
    }
    
    private function stopWatchingMouse():void {
      removeEventListener(MouseEvent.MOUSE_MOVE, moveListener);
    }
    
    private function restartFadeTimer():void {
      // reset the old timer
      _timer.reset();
      // start it over
      _timer.start();
    }
        
    private function timerListener(eventObj:TimerEvent):void {
      // hide the button
      hideButton();
    }
    
    public function beFadeable():void {
      // set the alpha target for hiding the button to 0
      _fadeTargets.hide = 0;
      // restart the timer
      restartFadeTimer();
    }
    
    public function pulseDistanceArc(doPulse:Boolean):void {
      if (doPulse == false) {
        TweenLite.to(_arcDistance, .25, {tint: Prefs.DISTANCE_ARC_CLR});
      } else {
        pulseDistanceArcDown();
      }
    }
    
    private function pulseDistanceArcUp():void {
      TweenLite.to(_arcDistance, .25, {tint: Prefs.DISTANCE_ARC_CLR, onComplete: pulseDistanceArcDown});
    }

    private function pulseDistanceArcDown():void {
      TweenLite.to(_arcDistance, .25, {tint: Prefs.DISTANCE_ARC_CLR_PULSE, onComplete: pulseDistanceArcUp});
    }

    public function showButton():void {
      if (!_showing) {
        TweenLite.to(this, .5, {alpha: _fadeTargets.show});
        _showing = true;
      }
    }
    
    public function hideButton():void {
      TweenLite.to(this, .5, {alpha: _fadeTargets.hide});
      _showing = false;
    }
    
    private function drawBackground():void {
      _bg.graphics.lineStyle(Prefs.BUTTON_BORDER_THICK, Prefs.BUTTON_BORDER_CLR);
      _bg.graphics.beginFill(Prefs.BUTTON_FILL_CLR, Prefs.BUTTON_FILL_ALPHA);
      _bg.graphics.drawCircle(0, 0, Prefs.BUTTON_RADIUS);
      _bg.graphics.endFill();
    }
    
    private function drawSymbol():void {
      // dimensions
      var l:int = -Prefs.BUTTON_SYMBOL_RADIUS / 2;
      var t:int = l;
      var r:int = Prefs.BUTTON_SYMBOL_RADIUS / 2;
      var b:int = r;
      // start drawing
      _symbol.graphics.clear();
      _symbol.graphics.lineStyle();
      _symbol.graphics.beginFill(Prefs.BUTTON_BORDER_CLR);
      if (_state == Prefs.STATE_PAUSE) {
        // draw the pause symbol
        var bar:int = ((r - l) / 3) + 1;
        _symbol.graphics.moveTo(l, t);
        _symbol.graphics.lineTo(l, b);
        _symbol.graphics.lineTo(l + bar, b);
        _symbol.graphics.lineTo(l + bar, t);
        _symbol.graphics.lineTo(l, t);
        _symbol.graphics.endFill();
        _symbol.graphics.beginFill(Prefs.BUTTON_BORDER_CLR);
        _symbol.graphics.moveTo(r, t);
        _symbol.graphics.lineTo(r, b);
        _symbol.graphics.lineTo(r - bar, b);
        _symbol.graphics.lineTo(r - bar, t);
        _symbol.graphics.lineTo(r, t);
      } else {
        // draw the play symbol
        var offset:int = Prefs.BUTTON_SYMBOL_RADIUS / 8;
        _symbol.graphics.moveTo(l + offset, t);
        _symbol.graphics.lineTo(r + offset, 0);
        _symbol.graphics.lineTo(l + offset, b);
        _symbol.graphics.lineTo(l + offset, t);
      }
      _symbol.graphics.endFill();
    }
    
    private function clickListener(eventObj:MouseEvent):void {
      // let listeners know I've been clicked
      dispatchEvent(new PlayButtonEvent(PlayButtonEvent.PLAY_CLICK, true, false, _state));
    }
    
    private function moveListener(eventObj:MouseEvent):void {
      // make sure the button's visible
      showButton();
      // restart the fade timer
      restartFadeTimer();
    }
    
    public function showLoaded(loadedTo:Number):void {
      // loadedTo is a number between 0-1
      // clear the loaded arc
      _arcLoaded.graphics.clear();
      // draw the band
      bandAt(
        _arcLoaded, 0, 0, Prefs.PLAY_ARC_START, Prefs.PLAY_ARC_SWEEP * loadedTo, Prefs.LOADED_ARC_RADIUS,
        Prefs.LOADED_ARC_THICK, Prefs.LOADED_ARC_CLR, Prefs.PLAY_ARC_ALPHA
      );
    }
    
    public function showPlayed(playedTo:Number):void {
      // playedTo is a number between 0-1
      // clear the played arc
      _arcPlayed.graphics.clear();
      // draw the band
      bandAt(
        _arcPlayed, 0, 0, Prefs.PLAY_ARC_START, Prefs.PLAY_ARC_SWEEP * playedTo, Prefs.PLAYED_ARC_RADIUS,
        Prefs.PLAYED_ARC_THICK, Prefs.PLAYED_ARC_CLR, Prefs.PLAY_ARC_ALPHA
      );
    }
    
    /**
     * @method bandAt
     * @param clip Sprite the clip to draw the band on
     * @param cX Number the x location of the center of the circle
     * @param cY Number the y location of the center of the circle
     * @param begin Number the starting angle of the band (in radians)
     * @param sweep Number the sweep of the band (in radians)
     * @param radius Number the radius of the circle
     * @param thick Number the thickness of the band
     * @param fillcolor Number the color of the fill
     * @param fillalpha Number the alpha of the fill
     * @description draw an arc to the passed specs
     */
     private function bandAt(
         clip:Sprite, cX:Number, cY:Number, begin:Number, sweep:Number,
         radius:Number, thick:Number, fillcolor:Number, fillalpha:Number
     ):void {

       // save the value of begin
       var originalBegin:Number = begin;

       // draw the bottom segment
       // calculate the number of segments needed for the arc
       // segments can be no greater than PI/4 radians
       var numSegs:Number = Math.ceil(Math.abs(sweep) / (Math.PI / 4));

       // Now calculate the sweep of each segment.
       var segSweep:Number = -1 * (sweep / numSegs);
       begin = -begin;

       // move to the start of the curve
       var ax:Number = cX + Math.cos(-begin) * radius;
       var ay:Number = cY + Math.sin(begin) * radius;
       // remember the start point
       var bandStart:Object = { x: ax, y: ay };

       // move and start filling
       clip.graphics.moveTo(ax, ay);
       clip.graphics.lineStyle();
       clip.graphics.beginFill(fillcolor, fillalpha);

       // draw the curve segments
       var middle:Number, bx:Number, by:Number, cx:Number, cy:Number;
       for (var inseg:Number = 0; inseg < numSegs; inseg++) {
         begin += segSweep;
         middle = begin - (segSweep / 2);
         bx = cX + Math.cos(begin) * radius;
         by = cY + Math.sin(begin) * radius;
         cx = cX + Math.cos(middle) * (radius / Math.cos(segSweep / 2));
         cy = cY + Math.sin(middle) * (radius / Math.cos(segSweep / 2));
         clip.graphics.curveTo(cx, cy, bx, by);
       }

       // draw the top segment
       radius += thick;
       begin = -(originalBegin + sweep);
       sweep = -sweep;

       // Now calculate the sweep of each segment.
       segSweep = -1 * (sweep / numSegs);
       // line to the start of the curve
       ax = cX + Math.cos(-begin) * radius;
       ay = cY + Math.sin(begin) * radius;
       clip.graphics.lineTo(ax, ay);

       // draw the curve segments
       for (var outseg:Number = 0; outseg < numSegs; outseg++) {
         begin += segSweep;
         middle = begin - (segSweep / 2);
         bx = cX + Math.cos(begin) * radius;
         by = cY + Math.sin(begin) * radius;
         cx = cX + Math.cos(middle) * (radius / Math.cos(segSweep / 2));
         cy = cY + Math.sin(middle) * (radius / Math.cos(segSweep / 2));
         clip.graphics.curveTo(cx, cy, bx, by);
       }

       // close the band
       clip.graphics.lineTo(bandStart.x, bandStart.y);
       clip.graphics.endFill();
     }
  }
}