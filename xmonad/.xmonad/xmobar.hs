-- docs: http://projects.haskell.org/xmobar/
Config {
    font = "xft:Terminus-9",
    bgColor = "#2d2d2d",
    fgColor = "#cccccc",
    position = Top,
    lowerOnStart = True,
    commands =
      [ Run Weather "KCHS"
          [ "--template", "<tempF>F <skyCondition>"
          , "--Low",      "64"
          , "--High",     "77"
          , "--high",     "#f2777a"
          , "--normal",   "#99cc99"
          , "--low",      "#6699cc"
          ] 36000
      , Run Memory
          [ "--template", "Mem: <usedratio>%"
          , "--High",     "8192"
          , "--Low",      "4096"
          , "--high",     "#f2777a"
          , "--normal",   "#6699cc"
          , "--low",      "#99cc99"
          ] 20
      , Run Swap
          [ "--template", "Swap: <usedratio>%"
          , "--High",     "1024"
          , "--Low",      "512"
          , "--high",     "#f2777a"
          , "--normal",   "#6699cc"
          , "--low",      "#99cc99"
          ] 20
      , Run CoreTemp
          [ "--High", "60"
          , "--Low",  "40"
          , "--high",     "#f2777a"
          , "--normal",   "#6699cc"
          , "--low",      "#99cc99"
          ] 60
      , Run Network "wlp3s0"
          [ "--template", "Wifi: <rx> KB/s"
          , "--High",     "200"
          , "--Low",      "10"
          , "--high",     "#99cc99"
          , "--normal",   "#6699cc"
          , "--low",      "#f2777a"
          ] 40
      , Run Battery
          [ "--template" , ("<fc=#cc99cc>Batt: <acstatus></fc>")
          , "--Low"      , "10"
          , "--High"     , "80"
          , "--high"     , "#99cc99"
          , "--normal"   , "#6699cc"
          , "--low"      , "#f2777a"
          , "--" -- battery specific options
          , "-o"	, "<left>% (<timeleft>)" -- discharging status
          , "-O"	, "Charging (<left>%)" -- AC "on" status
          , "-i"	, "Charged" -- charged status
          , "-l"      , "#f2777a"
          , "-m"      , "#6699cc"
          , "-h"      , "#99cc99"
          ] 100
      , Run Brightness
          [ "--template" , "<fc=#66cccc>Light: <percent>%</fc>"
          , "--High"     , "70"
          , "--Low"      , "40"
          , "--high"     , "#f2777a"
          , "--normal"   , "#6699cc"
          , "--low"      , "#99cc99"
          , "--" -- brightness specific options
          , "-D"         , "intel_backlight"
          ] 40
      , Run Date "<fc=#66cccc>%F (%a) %T</fc>" "date" 10
      , Run StdinReader
      ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{%bright%    %battery%    %memory%    %coretemp%    %KCHS%    %date%"
}
