package org.smallpower.player {
  import fl.video.MetadataEvent;
  import fl.video.VideoEvent;
  import fl.video.VideoProgressEvent;
  import fl.video.VideoState;
  import flash.display.*;
  import flash.events.*;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import gs.TweenLite;
  import flash.utils.Timer;
  
  public class SmallPlayer extends MovieClip {
    // depths
    private static var BACKGROUND_DEPTH:int = 0;
    private static var VIDEO_DEPTH:int = 1;
    private static var HOLDER_DEPTH:int = 2;
    private static var BUTTONS_DEPTH:int = 3;
    
    private var _videoURL:String;
    private var _shower:Shower;
    private var _playButton:PlayButton;
    private var _bg:Sprite;
    private var _holder:Sprite;
    private var _holderLoader:Loader;
    private var _duration:Number;
    private var _timer:Timer;
    
    private var _output:TextField;
    
    public function SmallPlayer() {
      // :TODO: tmp set up the output field
      //_output = new TextField();
      //_output.autoSize = TextFieldAutoSize.LEFT;
      //addChild(_output);

      // set the stage defaults
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;

      // get things started
      initPlayer();
    }
    
    private function initPlayer():void {
      // if the player dimensions are available...
      if (dimensionsAvailable()) {
        // remember the video URL
        _videoURL = root.loaderInfo.parameters.videoURL;

        // default total time
        _duration = 1;

        // draw the background
        showBackground();

        // start loading the video
        startLoadingVideo();

        // if there's a placeholder graphic, load it now
        if (root.loaderInfo.parameters.holderURL != undefined) {
          // create the sprite and the loader
          _holder = new Sprite();
          _holderLoader = new Loader();
          _holderLoader.load(new URLRequest(root.loaderInfo.parameters.holderURL));
          // listen to loader events
          _holderLoader.contentLoaderInfo.addEventListener(Event.INIT, holderInitListener);
          _holderLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, holderErrorListener);
        } else {
          // show the play/pause button
          showPlayButton();
        }
      } else {
        // try again in a few ms
        _timer = new Timer(100, 1);
        _timer.addEventListener(TimerEvent.TIMER, timerListener);
        _timer.start();
      }
    }

    private function timerListener(eventObj:TimerEvent):void {
      // try to init again
      initPlayer();
    }

    private function holderInitListener(eventObj:Event):void {
      // add the holder image just above the background
      _holder.addChild(_holderLoader.content);
      addChildAt(_holder, HOLDER_DEPTH);
      // show the play/pause button
      showPlayButton();
    }
    
    private function holderErrorListener(eventObj:Event):void {
      // show the play/pause button
      showPlayButton();
    }
    
    private function showBackground():void {
      // create the bg sprite
      _bg = new Sprite();
      // get the color
      var bgColor:Number = (root.loaderInfo.parameters.bgColor == undefined) ? Prefs.BACKGROUND_COLOR : Number(root.loaderInfo.parameters.bgColor);
      // draw the background
      _bg.graphics.beginFill(bgColor);
      _bg.graphics.lineStyle();
      _bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
      _bg.graphics.endFill();
      addChildAt(_bg, BACKGROUND_DEPTH);
    }
    
    private function showPlayButton():void {
      // create the button
      _playButton = new PlayButton(Prefs.INITIAL_STATE, stage.stageWidth, stage.stageHeight);
      // position the button
      _playButton.x = stage.stageWidth / 2;
      _playButton.y = stage.stageHeight / 2;
      // subscribe to the button click event
      _playButton.addEventListener(PlayButtonEvent.PLAY_CLICK, playClickListener);
      _playButton.addEventListener(PlayButtonEvent.PLAY_CLICK, firstPlayClickListener);
      // display the button
      addChildAt(_playButton, BUTTONS_DEPTH);
    }

    private function dimensionsAvailable():Boolean {
      return (stage.stageWidth > 0 && stage.stageHeight > 0);
    }
    
    private function firstPlayClickListener(eventObj:PlayButtonEvent):void {
      // start pulsing the distance arc to indicate loading
      _playButton.pulseDistanceArc(true);
      // never do so again
      _playButton.removeEventListener(PlayButtonEvent.PLAY_CLICK, firstPlayClickListener);
    }
    
    private function playClickListener(eventObj:PlayButtonEvent):void {
      if (eventObj.state == Prefs.STATE_PLAY) {
        // switch the button
        _playButton.setState(Prefs.STATE_PAUSE);
        // tell the video to play
        _shower.playVideo();
      } else if (eventObj.state == Prefs.STATE_PAUSE) {
        // switch the button
        _playButton.setState(Prefs.STATE_PLAY);
        // tell the video to pause
        _shower.pauseVideo();
      }
    }
    
    private function startLoadingVideo():void {
      // init the video shower with the URL passed via HTML
      _shower = new Shower(_videoURL);
      // subscribe to the shower state change event
      _shower.addEventListener(VideoEvent.STATE_CHANGE, stateChangeListener);
      _shower.addEventListener(VideoProgressEvent.PROGRESS, progressListener);
      _shower.addEventListener(VideoEvent.PLAYHEAD_UPDATE, updateListener);
      _shower.addEventListener(MetadataEvent.METADATA_RECEIVED, metaDataListener);
      // display the video
      addChildAt(_shower, VIDEO_DEPTH);
    }

    private function metaDataListener(eventObj:MetadataEvent):void {
      // save the movie duration
      _duration = eventObj.info.duration;
    }

    private function progressListener(eventObj:VideoProgressEvent):void {
      _playButton.showLoaded(eventObj.bytesLoaded / eventObj.bytesTotal);
    }

    private function updateListener(eventObj:VideoEvent):void {
      _playButton.showPlayed(eventObj.playheadTime / _duration);
    }

    private function stateChangeListener(eventObj:VideoEvent):void {
      if (eventObj.state == VideoState.PLAYING) {
        // hide the holder image if it exists
        if (_holder is Sprite) { TweenLite.to(_holder, .5, {alpha: 0}); }
        // make sure the play button's fadeable
        _playButton.beFadeable();
        // make sure the distance arc's not pulsing
        _playButton.pulseDistanceArc(false);
      } else if (eventObj.state == VideoState.REWINDING) {
        // show the holder image again if it exists
        if (_holder is Sprite) { TweenLite.to(_holder, .5, {alpha: 1}); }
        // hide the played arc on the play button
        _playButton.showPlayed(0);
        // set the play button to play
        _playButton.setState(Prefs.STATE_PLAY);
      }
    }
  }
}