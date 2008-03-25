package org.smallpower.player {
  import fl.video.MetadataEvent;
  import fl.video.NCManager;
  import fl.video.VideoAlign;
  import fl.video.VideoEvent;
  import fl.video.VideoPlayer;
  import fl.video.VideoProgressEvent;
  import fl.video.VideoScaleMode;
  import fl.video.VideoState;
  import flash.display.Sprite;
  
  public class Shower extends Sprite {
    private var _player:VideoPlayer;
    private var _videoURL:String;
    /*
      If you use the VideoPlayer class by itself, you must include
      the following statement to make sure the NCManager class is included:
    */
    private var _forceNCManager:NCManager;
    
    public function Shower(videoURL) {
      _videoURL = videoURL;
      _player = new VideoPlayer();
      // set properties
      _player.autoRewind = Prefs.AUTO_REWIND;
      _player.scaleMode = VideoScaleMode.NO_SCALE;
      _player.align = VideoAlign.TOP_LEFT;
      // subscribe to the video events
      _player.addEventListener(MetadataEvent.METADATA_RECEIVED, metaDataListener);
      _player.addEventListener(VideoEvent.STATE_CHANGE, stateChangeListener);
      _player.addEventListener(VideoProgressEvent.PROGRESS, progressListener);
      _player.addEventListener(VideoEvent.PLAYHEAD_UPDATE, updateListener);
      // display the player
      addChild(_player);
    }
    
    public function playVideo():void {
      if (_player.state == VideoState.DISCONNECTED || _player.state == VideoState.CONNECTION_ERROR) {
        _player.play(_videoURL);
      } else {
        _player.play();
      }
      // :TODO: send an event with the current state
    }
    
    public function pauseVideo():void {
      _player.pause();
    }
    
    private function stateChangeListener(eventObj:VideoEvent):void {
      // send the event along to my subscribers
      dispatchEvent(eventObj);
    }

    private function progressListener(eventObj:VideoProgressEvent):void {
      // send the event along to my subscribers
      dispatchEvent(eventObj);
    }

    private function updateListener(eventObj:VideoEvent):void {
      // send the event along to my subscribers
      dispatchEvent(eventObj);
    }

    private function metaDataListener(eventObj:MetadataEvent):void {
      // send the event along to my subscribers
      dispatchEvent(eventObj);
    }

  }
}