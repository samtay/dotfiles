{-# LANGUAGE OverloadedStrings #-}
module Main where

import System.Taffybar (startTaffybar)
import System.Taffybar.Context (TaffybarConfig(..))
import System.Taffybar.Hooks
import System.Taffybar.Information.CPU
import System.Taffybar.Information.Memory
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.Generic.PollingGraph

-- See https://hackage.haskell.org/package/taffybar-3.3.0 for docs

type RGBA = (Double, Double, Double, Double)
toRGBA :: Double -> Double -> Double -> Double -> RGBA
toRGBA r g b a = let m = 256 in (r / m, g / m, b / m, a)

data Theme = Theme
  { background :: RGBA
  , yellow1  :: RGBA
  , yellow2 :: RGBA
  , green1 :: RGBA
  , green2 :: RGBA
  , blue :: RGBA
  }

gruvboxLight = Theme
  { background = toRGBA 251 241 199 0
  , yellow1 = toRGBA 215 153 33 1
  , yellow2 = toRGBA 181 118 20 0.5
  , green1 = toRGBA 152 151 26 1
  , green2 = toRGBA 121 116 14 0.5
  , blue = toRGBA 69 133 136 1
  }

gruvboxDark = Theme
  { background = toRGBA 40 40 40 0
  , yellow1 = toRGBA 215 153 33 1
  , yellow2 = toRGBA 250 189 47 0.5
  , green1 = toRGBA 152 151 26 1
  , green2 = toRGBA 184 187 38 0.5
  , blue = toRGBA 69 133 136 1
  }

myTheme = gruvboxLight

myGraphConfig, netCfg, memCfg, cpuCfg :: GraphConfig
myGraphConfig =
  defaultGraphConfig
  { graphPadding = 0
  , graphBorderWidth = 0
  , graphWidth = 75
  , graphBackgroundColor = background myTheme
  }

netCfg = myGraphConfig
  { graphDataColors = [yellow1 myTheme, yellow2 myTheme]
  , graphLabel = Just "&#988859; "
  }

memCfg = myGraphConfig
  { graphDataColors = [blue myTheme]
  , graphLabel = Just "&#58957; "
  }

cpuCfg = myGraphConfig
  { graphDataColors = [green1 myTheme, green2 myTheme]
  , graphLabel = Just "&#62652; "
  }

memCallback :: IO [Double]
memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback :: IO [Double]
cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

myTaffybarConfig :: TaffybarConfig
myTaffybarConfig =
  let myWorkspacesConfig =
        defaultWorkspacesConfig
        { minIcons = 1
        , widgetGap = 0
        , showWorkspaceFn = hideEmpty
        }
      workspaces = workspacesNew myWorkspacesConfig
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      mem = pollingGraphNew memCfg 1 memCallback
      net = networkGraphNew netCfg Nothing
      clock = textClockNewWith defaultClockConfig
      layout = layoutNew defaultLayoutConfig
      windowsW = windowsNew defaultWindowsConfig
      -- See https://github.com/taffybar/gtk-sni-tray#statusnotifierwatcher
      -- for a better way to set up the sni tray
      tray = sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt
      myConfig = defaultSimpleTaffyConfig
        { startWidgets =
            workspaces : map (>>= buildContentsBox) [ layout, windowsW ]
        , endWidgets = map (>>= buildContentsBox)
          [ batteryIconNew
          , clock
          , tray
          , cpu
          , mem
          , net
          , mpris2New
          ]
        , barPosition = Top
        , barPadding = 10
        , barHeight = 50
        , widgetSpacing = 0
        }
  in withBatteryRefresh $ withLogServer $
     withToggleServer $ toTaffyConfig myConfig

main = startTaffybar myTaffybarConfig
