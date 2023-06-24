{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (void)
import Control.Monad.IO.Class (MonadIO (liftIO))
import Control.Monad.Trans.Reader (ReaderT (runReaderT), ask)
import Data.List (elemIndex)
import qualified Data.Text as Text
import GI.Gtk (
  Widget,
  labelNew,
  labelSetMarkup,
  onWidgetRealize,
  toWidget,
 )
import System.Taffybar (startTaffybar)
import System.Taffybar.Context (TaffyIO, TaffybarConfig (..))
import System.Taffybar.Hooks (
  withBatteryRefresh,
  withLogServer,
  withToggleServer,
 )
import System.Taffybar.Information.Battery (
  BatteryInfo (batteryPercentage, batteryState),
  BatteryState (BatteryStateDischarging),
  getDisplayBatteryChan,
  getDisplayBatteryInfo,
 )
import System.Taffybar.Information.CPU (cpuLoad)
import System.Taffybar.Information.Memory (
  MemoryInfo (memoryUsedRatio),
  parseMeminfo,
 )
import System.Taffybar.SimpleConfig (
  Position (Top),
  SimpleTaffyConfig (
    barHeight,
    barPadding,
    barPosition,
    endWidgets,
    startWidgets,
    widgetSpacing
  ),
  defaultSimpleTaffyConfig,
  toTaffyConfig,
 )
import System.Taffybar.Util (postGUIASync)
import System.Taffybar.Widget (
  LayoutConfig (..),
  Workspace (..),
  WorkspacesConfig (labelSetter, minIcons, showWorkspaceFn, widgetGap),
  batteryIconNew,
  buildContentsBox,
  defaultClockConfig,
  defaultLayoutConfig,
  defaultWindowsConfig,
  defaultWorkspacesConfig,
  hideEmpty,
  layoutNew,
  mpris2New,
  networkGraphNew,
  sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt,
  textBatteryNew,
  textClockNewWith,
  windowsNew,
  workspacesNew,
 )
import System.Taffybar.Widget.Generic.ChannelWidget (
  channelWidgetNew,
 )
import System.Taffybar.Widget.Generic.PollingGraph (
  GraphConfig (
    graphBackgroundColor,
    graphBorderWidth,
    graphDataColors,
    graphLabel,
    graphPadding,
    graphWidth
  ),
  defaultGraphConfig,
  pollingGraphNew,
 )
import System.Taffybar.Widget.Layout (LayoutConfig)

-- See https://hackage.haskell.org/package/taffybar-3.3.0 for docs

type RGBA = (Double, Double, Double, Double)
toRGBA :: Double -> Double -> Double -> Double -> RGBA
toRGBA r g b a = let m = 256 in (r / m, g / m, b / m, a)

data Theme = Theme
  { background :: RGBA
  , yellow1 :: RGBA
  , yellow2 :: RGBA
  , green1 :: RGBA
  , green2 :: RGBA
  , blue :: RGBA
  }

gruvboxLight =
  Theme
    { background = toRGBA 251 241 199 0
    , yellow1 = toRGBA 215 153 33 1
    , yellow2 = toRGBA 181 118 20 0.5
    , green1 = toRGBA 152 151 26 1
    , green2 = toRGBA 121 116 14 0.5
    , blue = toRGBA 69 133 136 1
    }

gruvboxDark =
  Theme
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
netCfg =
  myGraphConfig
    { graphDataColors = [yellow1 myTheme, yellow2 myTheme]
    , graphLabel = Just "&#988859; "
    }
memCfg =
  myGraphConfig
    { graphDataColors = [blue myTheme]
    , graphLabel = Just "&#58957; "
    }
cpuCfg =
  myGraphConfig
    { graphDataColors = [green1 myTheme, green2 myTheme]
    , graphLabel = Just "&#62652; "
    }

myLayoutConfig :: LayoutConfig
myLayoutConfig = LayoutConfig{formatLayout = pure . fmt}
 where
  fmt l
    | "ResizableTall" `Text.isInfixOf` l = " &#61659; " -- 
    | "ResizableThreeCol" `Text.isInfixOf` l = " &#988295; " -- 󱒇
    | "Full" `Text.isInfixOf` l = " &#983699; " -- 󰊓
    | otherwise = l

myWorkspacesConfig :: WorkspacesConfig
myWorkspacesConfig =
  defaultWorkspacesConfig
    { minIcons = 1
    , widgetGap = 2
    , showWorkspaceFn = hideEmpty
    , labelSetter = pure . trimScreen . workspaceName
    }
 where
  trimScreen s = case elemIndex '_' s of
    Just i -> drop (i + 1) s
    Nothing -> s

-- {-
battery :: TaffyIO Widget
battery = do
  chan <- getDisplayBatteryChan
  ctx <- ask
  let getBatteryStatusIO = getBatteryStatus <$> runReaderT getDisplayBatteryInfo ctx
  liftIO $ do
    -- Logic for initial label creation (actually this whole func) taken from Taffy `textBatteryNew` but this does not look right at all.
    label <- getBatteryStatusIO >>= labelNew . Just
    let setMarkup nextStatus = postGUIASync $ labelSetMarkup label nextStatus
        updateWidget = setMarkup . getBatteryStatus
    void $ onWidgetRealize label $ getBatteryStatusIO >>= setMarkup
    toWidget =<< channelWidgetNew label chan updateWidget
 where
  getBatteryStatus info =
    let percent = floor (batteryPercentage info)
        charging = batteryState info /= BatteryStateDischarging
        icon
          | percent <= 15 = if charging then "&#985244;" else "&#983162;" -- "󰢜 󰁺"
          | percent <= 25 = if charging then "&#983174;" else "&#983163;" -- "󰂆 󰁻"
          | percent <= 35 = if charging then "&#983175;" else "&#983164;" -- "󰂇 󰁼"
          | percent <= 45 = if charging then "&#983176;" else "&#983165;" -- "󰂇 󰁽"
          | percent <= 55 = if charging then "&#985245;" else "&#983166;" -- "󰢝 󰁾"
          | percent <= 65 = if charging then "&#983177;" else "&#983167;" -- "󰂉 󰁿"
          | percent <= 75 = if charging then "&#985246;" else "&#983168;" -- "󰢞 󰂀"
          | percent <= 85 = if charging then "&#983178;" else "&#983169;" -- "󰂊 󰂁"
          | percent <= 95 = if charging then "&#983179;" else "&#983170;" -- "󰂋 󰂂"
          | otherwise = if charging then "&#983173;" else "&#983161;" -- "󰂅 󰁹"
     in icon <> " " <> Text.pack (show percent) <> "%"

-- -}

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
  let workspaces = workspacesNew myWorkspacesConfig
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      mem = pollingGraphNew memCfg 1 memCallback
      net = networkGraphNew netCfg Nothing
      clock = textClockNewWith defaultClockConfig
      layout = layoutNew myLayoutConfig
      windowsW = windowsNew defaultWindowsConfig
      -- See https://github.com/taffybar/gtk-sni-tray#statusnotifierwatcher
      -- for a better way to set up the sni tray
      tray = sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt
      myConfig =
        defaultSimpleTaffyConfig
          { startWidgets =
              workspaces : map (>>= buildContentsBox) [layout, windowsW]
          , endWidgets =
              map
                (>>= buildContentsBox)
                [ battery
                , clock
                , tray
                , cpu
                , mem
                , net
                , mpris2New
                ]
          , barPosition = Top
          , barPadding = 8
          , barHeight = 50
          , widgetSpacing = 10
          }
   in withBatteryRefresh $
        withLogServer $
          withToggleServer $ toTaffyConfig myConfig

main = startTaffybar myTaffybarConfig
