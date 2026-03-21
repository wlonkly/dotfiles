#!/usr/bin/env bash

# Maps app bundle IDs to sketchybar-app-font glyphs
# Font: https://github.com/kvndrsslr/sketchybar-app-font
# Usage: icon_map "com.apple.Safari" -> sets $icon variable

function icon_map() {
  case "$1" in
    "com.apple.AppStore")                   icon=":app_store:";;
    "com.apple.Automator")                  icon=":automator:";;
    "com.apple.ActivityMonitor")            icon=":activity_monitor:";;
    "com.apple.Calculator")                 icon=":calculator:";;
    "com.apple.Calendar")                   icon=":calendar:";;
    "com.apple.Chess")                      icon=":chess:";;
    "com.apple.Contacts")                   icon=":contacts:";;
    "com.apple.Dictionary")                 icon=":dictionary:";;
    "com.apple.FaceTime")                   icon=":facetime:";;
    "com.apple.finder")                     icon=":finder:";;
    "com.apple.FontBook")                   icon=":font_book:";;
    "com.apple.Home")                       icon=":home:";;
    "com.apple.iCal")                       icon=":calendar:";;
    "com.apple.iChat")                      icon=":messages:";;
    "com.apple.Image_Capture")              icon=":image_capture:";;
    "com.apple.iWork.Keynote")              icon=":keynote:";;
    "com.apple.iWork.Numbers")              icon=":numbers:";;
    "com.apple.iWork.Pages")                icon=":pages:";;
    "com.apple.mail")                       icon=":mail:";;
    "com.apple.Maps")                       icon=":maps:";;
    "com.apple.MobileSMS")                  icon=":messages:";;
    "com.apple.Music")                      icon=":music:";;
    "com.apple.news")                       icon=":news:";;
    "com.apple.Notes")                      icon=":notes:";;
    "com.apple.Photos")                     icon=":photos:";;
    "com.apple.podcasts")                   icon=":podcasts:";;
    "com.apple.Preview")                    icon=":preview:";;
    "com.apple.QuickTimePlayerX")           icon=":quicktime_player:";;
    "com.apple.Reminders")                  icon=":reminders:";;
    "com.apple.Safari")                     icon=":safari:";;
    "com.apple.ScreenSaver.Engine")         icon=":preferences:";;
    "com.apple.ScreenSharing")              icon=":screen_sharing:";;
    "com.apple.Stickies")                   icon=":stickies:";;
    "com.apple.stocks")                     icon=":stocks:";;
    "com.apple.systempreferences")          icon=":system_preferences:";;
    "com.apple.SystemProfiler")             icon=":system_information:";;
    "com.apple.Terminal")                   icon=":terminal:";;
    "com.apple.TextEdit")                   icon=":text_edit:";;
    "com.apple.TV")                         icon=":apple_tv:";;
    "com.apple.voicememos")                 icon=":voice_memos:";;
    "com.apple.weather")                    icon=":weather:";;
    "com.apple.dt.Xcode")                   icon=":xcode:";;
    "com.apple.Safari.WebApp"*)             icon=":safari:";;
    "com.anthropic.claudefordesktop")       icon=":claude:";;
    "com.brave.Browser")                    icon=":brave_browser:";;
    "com.brave.Browser.nightly")            icon=":brave_browser:";;
    "com.google.Chrome")                    icon=":google_chrome:";;
    "com.google.Chrome.beta")               icon=":google_chrome:";;
    "com.microsoft.VSCode")                 icon=":vscode:";;
    "com.microsoft.VSCodeInsiders")         icon=":vscode:";;
    "com.microsoft.Word")                   icon=":microsoft_word:";;
    "com.microsoft.Excel")                  icon=":microsoft_excel:";;
    "com.microsoft.Powerpoint")             icon=":microsoft_powerpoint:";;
    "com.microsoft.Outlook")               icon=":microsoft_outlook:";;
    "com.microsoft.teams2")                 icon=":microsoft_teams:";;
    "com.openai.chat")                      icon=":chatgpt:";;
    "com.readdle.PDFExpert-Mac")            icon=":pdf_expert:";;
    "com.spotify.client")                   icon=":spotify:";;
    "com.tinyspeck.slackmacgap")            icon=":slack:";;
    "com.todoist.mac.Todoist")              icon=":todoist:";;
    "com.twitter.twitter-mac")              icon=":twitter:";;
    "com.valvesoftware.steam")              icon=":steam:";;
    "company.thebrowser.Browser")           icon=":arc:";;
    "cx.c3.theunarchiver")                  icon=":the_unarchiver:";;
    "de.ixeau.Klokki-Slim")                 icon=":klokki:";;
    "io.alacritty")                         icon=":alacritty:";;
    "io.mpv.mpv")                           icon=":mpv:";;
    "md.obsidian")                          icon=":obsidian:";;
    "net.codeux.istatmenus6")               icon=":istat_menus:";;
    "net.whatsapp.WhatsApp")                icon=":whatsapp:";;
    "notion.id")                            icon=":notion:";;
    "org.mozilla.firefox")                  icon=":firefox:";;
    "org.mozilla.firefoxdeveloperedition")  icon=":firefox_developer_edition:";;
    "org.telegram.desktop")                 icon=":telegram:";;
    "org.videolan.vlc")                     icon=":vlc:";;
    "com.github.wez.wezterm")              icon=":wezterm:";;
    "com.mitchellh.ghostty")               icon=":ghostty:";;
    "com.mimestream.Mimestream")           icon=":mimestream:";;
    "com.linear.app")                      icon=":linear:";;
    "com.figma.Desktop")                   icon=":figma:";;
    "com.1password.1password")             icon=":1password_7_password_manager:";;
    "com.agilebits.onepassword7")          icon=":1password_7_password_manager:";;
    "com.apple.SafariTechnologyPreview")   icon=":safari_technology_preview:";;
    "com.bluesky-social.app")             icon=":bluesky:";;
    *)                                     icon=":default:";;
  esac
}
