import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/**
 * The Music player tag widget
 */
class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer>
    with TickerProviderStateMixin {

  // Indicate if a song is playing
  var playState;

  // The playing song's uri, used to decide to stop playing a song
  // or start to play another song
  var playingSongUri;

  // music player from third party
  MusicFinder audioPlayer;

  /**
   * Future function called when building the tag
   * Return a list of Song objects representing songs stored locally
   */
  load() async {

    // Ask permission
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    // Check if permission is granted
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);

    // Fetch all songs stored locally
    var songs = await MusicFinder.allSongs();

    // Return the songs
    return songs;
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = MusicFinder();
    playState = PlayerState.STOP;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(

        // The depended asycn function
        future: load(),
        builder: (context, snap) {

          // If the async func is not finished || no data return
          if (snap.connectionState != ConnectionState.done || !snap.hasData) {

            // Tell users we are loading the data
            return Center(
              child: Text("Loading"),
            );
          }

          // The async func is finished and returns data
          var songs = snap.data;

          // Build a listView of songs
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {

              // Given the Song object, build one song/music Item
              return musicItem(context, index, songs[index]);
            },

            // The number of songs
            itemCount: songs.length,
          );
        },
      ),
    );
  }

  /**
   * Build one music/song item
   * Containing song's information, such as artist, name and album icon
   */
  Widget musicItem(BuildContext context, int index, Song music) {
    return InkWell(
      highlightColor: Colors.black12,

      // Function called when the song is tapped
      onTap: () async {

        // If currently no song is playing
        if(playState == PlayerState.STOP) {
          // Play the song
          final result = await audioPlayer.play(music.uri);

          // If song is played successfully
          if(result == 1) {
            // Update that there is a song playing
            playState = PlayerState.PLAYING;

            // Store the played song's uri
            playingSongUri = music.uri;
          }
          return;
        }

        // If currently their is a song playi g
        if(playState == PlayerState.PLAYING) {
          // Stop the currently playing song
          final result = await audioPlayer.stop();

          // If stop successfully
          if(result == 1) {

            // Update the play state
            playState = PlayerState.STOP;

            // If the tapped song was playing and tapped again
            if(playingSongUri == music.uri) {
              // Do not play it again
              return;
            }

            // If this is another song, play it
            final result2 = await audioPlayer.play(music.uri);

            // If play successfully
            if(result2 == 1) {
              // Update the playState
              playState = PlayerState.PLAYING;
            }
          }
        }
      },

      // The song item
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
        height: 80.0,
        child: Row(
          children: <Widget>[
            // Rounded Rect Widget
            ClipRRect(
              borderRadius: BorderRadius.circular(2.0),

              // Check if any information is lost
              child: (music == null ||
                      music.albumArt == null ||
                      music.albumArt == "")
                      // If so, display the default icon
                  ? Icon(
                      Icons.music_note,
                      size: 50,
                      color: Colors.amber,
                    )
                    // Else display the album art
                  : Image.file(
                      File(music.albumArt),
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
            ),

            
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Display the song name
                    Text(
                      music.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // Display the song's artist
                    Text(
                      music.artist + " - " + music.album,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black38,
                          fontSize: 14.0),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum PlayerState{
  PLAYING,
  STOP,
}
