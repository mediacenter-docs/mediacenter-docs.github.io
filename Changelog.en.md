# "Mediacenter" - Changelog

## Версия: 0.3.6

- IPTV Player: teleguide integrated to channels list, added updating about current program, fixed show channel title while switching on up/down key, fixed rewind while watching telecast in record, added close channels list on select, fixed playing HLS with HTTP headers
- TV program: database is reconstructed, fixed loading XMLTV format program (containing synonyms of channels)
- Added hyperlinks to detailed page
- Added thumbnails database size limitation (default is 300MB)
- Added possibility to disable splash screen
- Limited functions of voice-activated control are added (experimental, listens to teams at the pressed play button). In the main menu opens the section of global search. When watching IPTV changes channels. When watching video operates playing, teams: play, pause, stop, next, previous, forward, back, up, down.
- The error of loading of addition at an application launch which can lead to emergency completion of operation of application is corrected
- For developers: CPython upgrade 3.8.5 to 3.11.2, fixed ffi library in Lua
- Other changes

## Version: 0.3.5

- UI updated: background choice, icons, grouped, grid increase
- Added "Search" to fast find
- VLC library updated and fixed seeking WEBM (YouTube)
- Fixed torrent file opening
- Added a new feature as "Extensions"
- Added a new dialog with multi select
- Favorites: fixed open favorite playlist, manual adding and editing links for playlist, use "Add" in application menu to add favorite playlist
- Record scheduler: data and program name was exchange in filename, fixed job state after restart application
- Added http catalogues opening
- Added clear timepoints after exit (settings)
- Added remove catalogues from local disk
- For developers: CPython upgrade 3.7.4 to 3.8.5, Add-On and Extensions extractions to local path always, new formal strings localization (old is deprecated), to Lua added ffi and cURL libraries
- Other changes

## Version: 0.3.4

- Added new video player (use as default) based on VLC library, which additions: playing  DVD / Blu-ray disk images; internal and external subtitles; external audio tracks; more settings
- Previous video player is named as "lite"
- Added "Favorites" to creating own playlists
- Fixed HLS recording via https protocol
- Fixed consecutive playing of audio from http(s) streams
- Fixed TV program loader
- Fixed FTP client
- Added internal picture viewer and GIF animations
- Added internal text viewer for plain text
- Added process subdirectories at consecutive video playing
- Added new view with detailed of selected element
- Other changes

## Version: 0.3.3

- Fixed watching huge playlist
- Fixed the resumption of viewing the program in the archive of the channel after a pause
- Added shortcut keys (left, right - 1 min.; up, down - 3 min.) while watching tv archive
- Enhanced list of supported content sources, including youtube playlists and live streams
- Added automatic transition to the next video when it is not possible to play the current and user inactivity for 5 seconds
- Added highlighting of elements depending on the percentage of watched (from 90% - in green, from 10% - in yellow)
- Added support for the parameters `tvg-id`, `#EXTVLCOPT:http-*`, `catchup` = `default` or `append`, `catchup-source` and `catchup-days` in M3U playlists
- Added support for add-ons (plugins) in Python (experimental)
- Updated FFMPEG 3.4 to FFMPEG 4.2.2 for audio playback
- Improved security storage of passwords and other sensitive information
- Added caching of earlier open add-ons and helper modules
- Added transition to the last line of the list by right button
- Added Search into current list
- Added Apps section
- Other changes

## Version: 0.3.2

- Fixed XMLTV parsing
- Impove channel detection
- Fixed selectable of TV channels group
- Fixed M3U icons
- After playback, the cursor is placed on the last item to be played
- Fixed off screensaver when start playback
- Web interface: added looping file playback, added playback controls, added multifiles uploader, added preview on click name, added link playback from video hosting, added get screenshot
- Added remove old tv programms
- Added tv archives (if implements in service)
- Improved HTTP protocol
- Other fixes

## Version: 0.3.1

- Fixed image loader. When opening the list the image could not correspond to a list element
- Fixed scrolling the top menu
- Added tv program formats: MediaPortal and JTV (RAR/7-Zip archives)
- Added playlist formats: B4S, WPL, URL, RAM, PXML
- Added web interface (turn on in settings, defaults: port 8081, login/password - admin) for demo playback management
- Added minimum duration preference for resume playback
- Updated application interface
- Added select audio track for playback
- Fixed consecutive video playback
- Added authorization dialog for smb/ftp protocols
- Added NetBios scanner (Experimentally)
- Added Bluray remux and ISO image playback from local disk (Experimentally)
- Updated FFMPEG 2.8.1 to FFMPEG 3.4 for audio playback
- Fixed blocked plugins when some plugin is broken
- Plugin development: deprecated functions are removed, added cryptography
- Other fixes

## Version: 0.3.0

- Fixed HLS recording over `http://host/channel.m3u?[args]`
- Fixed udp protocol
- Added TV source list (default)
- Added XMLTV support
- Added caching TV Programme on the disk
- Added extended scaling (crop)
- Service management changed (menu\Management)
- Optimize image caching
- Added shuffle DEMO playback
- Added icon link while add shortcut
- In playback(internal), left/right time skip improve to 15 seconds
- Upgrade FFMPEG library from 2.6 to 2.8.1 version (audio player), added tracker music support (MOD,XM,IT,S3M)
- Other fixes

## Version: 0.2.9

- Fixed audio mute
- Fixed application suspension
- Fixed close video
- Fixed EPG plugins
- Fixed HLS streams
- Impove speed openning video/tv
- Optimize tv channels selected
- Upgrade FFMPEG library from 2.3.1 to 2.6 version (audio player)
- Other fixes

## Version: 0.2.8

- Added audio player with supported many formats and codecs. File formats: WAV [.wav, .pcm] / M4A [.m4a] / OGG [.ogg] / WMA [.wma] / FLAC [.flac] / APE [.ape] / WavPack [.wv] / TTA [.tta] / TAK [.tak] / MPEG [.mp1, .mp2, .mp3] Codecs: MPEG 1/2 Audio Layers I, II, and III (MP3) / PCM / AAC / ALAC (Apple Lossless) / Microsoft WMA / FLAC / True Audio / Tom�s AudioKompressor / Monkey's Audio Impove internet radio openning
- Added "Recenlty viewed"
- Added playlists identification on file content
- Impove automatic charset detection
- Shortcuts inserted to list begin
- Fixed SSL
- Optimizing performance and resource utilization
- Other fixes

## Version: 0.2.7

- Added show tag info while playling
- Fixed pause while playing video (after goto)
- Fixed list "Playlists"
- Optimize HLS (HTTP Live Streaming) record
- Added support mmsh/mmst/srtp/https procotols
- Added support CUE playlists (experimental)
- Optimize meta information (tv program)
- Optimize image downloader
- Fixed shoutcast link
- Optimize memory usage
- Other fixes

## Version: 0.2.6

- Added "Demo" function, auto watching video/photo on system booted. For use, create ICONBIT_PLAY folder on storage and copy video/photo files to
- Added resume play (internal player) when connection breaked
- Added support mirrors cloude services
- Added support HLS (HTTP Live Streaming) streams
- Increase downloading of content list (not for all services)
- Added audio player window in file manager (at right of list)
- Optimize memory usage
- Other fixes

## Version: 0.2.5

- Add link "File manager":  In "NET", add manual edit,  add filter files options,  add playing folder and images (ISO) BD (experimental),  add auto update devices list
- Add preference to launch (IPTV, MediaCenter and File manager) a system booted, IPTV and MediaCenter launching after net initialized
- Add show program label a listen internet radio
- Add preferences domain, username and password for NET Samba/Windows
- Fixed select group channels a watching TV while launching IPTV
- Other fixes

## Version: 0.2.4

- Fixed icons scaling
- Added support PLS/ASX playlists
- Added automatic loading and comparison of TV programs for M3U/XSPF playlists (experimental)
- Added show action information while video playing
- Other fixes

## Version: 0.2.3

- Added showing file size and free/total on devices
- Added NET exporer (Explorer/NET)
- Fixed restoring activity after destroying (low memory)
- Added record size in scheduler
- Added breaking stream loading while suspending
- Added auto select audio language in IPTV (not for all)
- Added select storage for recording (while watching TV)
- Added create link of service on main menu
- Added support multi archives of JTV
- Fixed starting application on Toucan Nano X and new devices NT series
- Reworked application style

## Version: 0.2.2

- Added scheduler service
- Added IPTV link
- Add saving view for main menu and file manager
- Add support Android 2.3 and above
- Refresh style UI
- Other minor fixes

## Version: 0.2.1

- Added services managment
- Remove show preferences: playlists, explorer, 2KOM
- Added open service on start application. See preferences and service popup menu (long press)
- Fixed some errors

## Version: 0.2.0

- Fixed the store selection in home menu
- Added the scaling video preference
- Added the record function. Press the "right" button for start/stop recording when watching TV (the channel list is must to be hidden). The recorded is stored in REC folder, storage device priority: USB HDD, USB flash, external SD card, internal SD card.
- Added the store view in history tree
- Added the start application when boot is completed (see same preference)

## Version: 0.1.9

- Performance is improved when displaying items with images
- Added notification about new version and changes
- Improved application update function
- Fixed bug when you reopen the TV program
- Added switch to the next video by double clicking the menu/f1 button when playing list(YouTube)

## Version: 0.1.8

- Memory usage optimization
- Improved stability of the application
- Enlarge font added scrolling text is not readable

## Version: 0.1.6

- Added support for plugins (internet services), the settings of Internet services in the menu (via long press)
- Added modern style dialog boxes, menus, and settings (Android 3.0+)
- Added caching of images (mainly on the SD card) to clear the cache available to the menu item
- Added the ability to select as the video player / TV system application
- The menu item was added to the "Update" that allows you to check the updated version, and if you want to run the update

## Version: 0.1.5

- Added support for http links with redirects, and not direct http links to playlists
- Optimization of the process play (management and memory usage)
- Added display of the indicator and the name of the channel at loading
- Added the display of the current time by pressing menu/f1 (while watching TV)
- Added support groups in playlists M3U (left / right button - Toggle between the groups in the list of TV shows while watching TV)
- Other minor fixes

## Version: 0.1.4

- Added support for TV shows JTV (zip only), when watching TV through the M3U playlist. Menu/f1 call list button transmission
- Added support for input links to the playlists (and other resources) from the console. To add a link, click menu/f1 and click add. To edit and delete a link, use a long press on the item (links)
- Added support for video files from local resources via SMB and player MX Player (to be included in the settings)
- Fixed application error when opening an inaccessible FTP server
- Optimize memory usage
- Added waiting indicator audio stream/files
