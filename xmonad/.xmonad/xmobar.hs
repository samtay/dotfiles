-- docs: http://projects.haskell.org/xmobar/
Config {
    font = "xft:Fixed-9",
    bgColor = "#2d2d2d",
    fgColor = "#cccccc",
    position = Top,
    lowerOnStart = True,
    commands = [
            Run Weather "KCHS" ["--template", "<tempF>F <skyCondition>",
                                      "--Low",      "64",
                                      "--High",     "77",
                                      "--high",     "#f2777a",
                                      "--normal",   "#99cc99",
                                      "--low",      "#6699cc"
                                      ] 36000,
            Run Memory ["--template", "Mem: <usedratio>%",
                        "--High",     "8192",
                        "--Low",      "4096",
                        "--high",     "#f2777a",
                        "--normal",   "#6699cc",
                        "--low",      "#99cc99"
                        ] 10,
            Run Swap ["--template", "Swap: <usedratio>%",
                      "--High",     "1024",
                      "--Low",      "512",
                      "--high",     "#f2777a",
                      "--normal",   "#6699cc",
                      "--low",      "#99cc99"
                      ] 10,
            Run Network "wlp3s0" ["--template", "Wifi: <rx> KB/s",
                                  "--High",     "200",
                                  "--Low",      "10",
                                  "--high",     "#99cc99",
                                  "--normal",   "#6699cc",
                                  "--low",      "#f2777a"
                                  ] 10,
            Run Battery [ "--template" , ("<fc=#cc99cc>Batt: <acstatus></fc>")
                        , "--Low"      , "10"
                        , "--High"     , "80"
                        , "--high"     , "#99cc99"
                        , "--normal"   , "#6699cc"
                        , "--low"      , "#f2777a"
                        , "--" -- battery specific options
                            -- discharging status
                            , "-o"	, "<left>% (<timeleft>)"
                            -- AC "on" status
                            , "-O"	, "Charging (<left>%)"
                            -- charged status
                            , "-i"	, "Charged"
                            , "-l"      , "#f2777a" 
                            , "-m"      , "#6699cc" 
                            , "-h"      , "#99cc99"
                        ] 100,
            Run Date "<fc=#66cccc>%F (%a) %T</fc>" "date" 10, --"%a %b %_d %l:%M" "date" 10,
            Run StdinReader
            ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %battery%    %memory%    %swap%    %wlp3s0%    %KCHS%    %date%"
}
