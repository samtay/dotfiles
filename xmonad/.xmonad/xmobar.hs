-- docs: http://projects.haskell.org/xmobar/
Config {
    font = "xft:Fixed-8",
    bgColor = "#000000",
    fgColor = "#ffffff",
    position = Top,
    lowerOnStart = True,
    commands = [
            Run Weather "KCHS" ["--template", "<tempF>F <skyCondition>",
                                      "--Low",      "64",
                                      "--High",     "77",
                                      "--normal",   "#e67e22",
                                      "--high",     "#f1c40f",
                                      "--low",      "#3498db"
                                      ] 36000,
            Run Memory ["--template", "Mem: <usedratio>%",
                        "--High",     "8192",
                        "--Low",      "4096",
                        "--high",     "#FFB6B0",
                        "--low",      "#CEFFAC",
                        "--normal",   "#FFFFCC"
                        ] 10,
            Run Swap ["--template", "Swap: <usedratio>%",
                      "--High",     "1024",
                      "--Low",      "512",
                      "--high",     "#FFB6B0",
                      "--low",      "#CEFFAC",
                      "--normal",   "#FFFFCC"
                      ] 10,
            Run Network "wlp3s0" ["--template", "Wifi: <rx> KB/s",
                                  "--High",     "200",
                                  "--Low",      "10",
                                  "--high",     "#3498db",
                                  "--low",      "#e74c3c",
                                  "--normal",   "#3498db"
                                  ] 10,
            Run Battery [ "--template" , "<fc=#9b59b6>Batt: <acstatus></fc>"
                        , "--Low"      , "10"
                        , "--High"     , "80"
                        , "--low"      , "#9f3a2c"
                        , "--normal"   , "#e67e22"
                        , "--high"     , "#5eebb8"
                        , "--" -- battery specific options
                            -- discharging status
                            , "-o"	, "<left>% (<timeleft>)"
                            -- AC "on" status
                            , "-O"	, "Charging (<left>%)"
                            -- charged status
                            , "-i"	, "Charged"
                            , "-l"      , "#9f3a2c" 
                            , "-m"      , "#e67e22" 
                            , "-h"      , "#2ecc71"
                        ] 100,
            Run Date "<fc=#e67e22>%F (%a) %T</fc>" "date" 10, --"%a %b %_d %l:%M" "date" 10,
            Run StdinReader
            ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %battery%    %memory%    %swap%    %wlp3s0%    %KCHS%    %date%"
}
