-- xmonad config
-- Author: Sam Tay
-- http://github.com/samtay/dotfiles

import Data.Semigroup ((<>))
import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Actions.CycleWS
import XMonad.Actions.Submap
import XMonad.Actions.SpawnOn
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Fullscreen
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.ResizableThreeColumns
import XMonad.Layout.TwoPane
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SessionStart
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.TaffybarPagerHints
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- TODO
-- 3. port alt+d displays script (or find rofi script that does the same)
-- 4. Use JumpToLayout to full screen on alt+f
-- 5. Fix reloading xmonad
-- 6. Taffybar ?

------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "kitty"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
--myLauncher = "$(yeganesh -x)"
myLauncher = "rofi -show combi -combi-modes drun,run -modes combi"

------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = withScreens 2 $ map show ([1..9] ++ [0])

------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "obsidian"  --> doShift "3"
    , className =? "1Password"  --> doShift "9"
    ]
    -- , resource  =? "desktop_window" --> doIgnore
    -- , className =? "stalonetray"    --> doIgnore
    -- , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
-- myManageHook = def

------------------------------------------------------------------------

------------------------------------------------------------------------
-- Layouts
myLayoutHook = avoidStruts $
  toggleLayouts
    (noBorders $ fullscreenFull Full) $
      ResizableTall 1 (3/100) (1/2) [] ||| ResizableThreeColMid 1 (3/100) (1/3) []

------------------------------------------------------------------------
-- Colors and borders
-- Based on gruvbox.
--
myNormalBorderColor  = gray myTheme
myFocusedBorderColor = red myTheme
myBorderWidth = 3

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = def {
    fontName = "xft:FiraCode Nerd Font-9",
    -- fontName = "xft:Source Code Pro:size=9",
    activeBorderColor   = aqua myTheme,
    activeTextColor     = foreground myTheme,
    activeColor         = red myTheme,
    inactiveBorderColor = gray myTheme,
    inactiveTextColor   = gray myTheme,
    inactiveColor       = background myTheme
}

data GruvboxTheme = GruvboxTheme {
  background :: String,
  foreground :: String,
  red :: String,
  green :: String,
  brightGreen :: String,
  yellow :: String,
  blue :: String,
  purple :: String,
  aqua :: String,
  gray :: String,
  orange :: String
}

myTheme = gruvboxLight

gruvboxDark = GruvboxTheme {
  background = "#282828",
  foreground = "#ebdbb2",
  red = "#cc241d",
  green = "#98971a",
  brightGreen = "#b8bb26",
  yellow = "#d79921",
  blue = "#458588",
  purple = "#b16286",
  aqua = "#689d6a",
  gray = "#a89984",
  orange = "#d65d0e"
}

gruvboxLight = GruvboxTheme {
  background = "#fbf1c7",
  foreground = "#3c3836",
  red = "#cc241d",
  green = "#98971a",
  brightGreen = "#b8bb26",
  yellow = "#d79921",
  blue = "#458588",
  purple = "#b16286",
  aqua = "#689d6a",
  gray = "#7c6f64",
  orange = "#d65d0e"
}

------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask
editFile f = spawn $ myTerminal ++ " sh -c \"nvim " ++ f ++ "\""

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Shell prompt
  -- , ((modMask .|. controlMask, xK_Return),
  --    shellPrompt myXPConfig)

  -- Start editing dotfiles
  , ((modMask, xK_period), submap . M.fromList $
      [ ((0, xK_x), editFile "$HOME/.config/xmonad/xmonad.hs")
      , ((0, xK_a), editFile "$HOME/.config/astronvim")
      , ((0, xK_v), editFile "$HOME/.config/astronvim")
      , ((0, xK_z), editFile "$HOME/.zshrc")
      , ((0, xK_t), editFile "$HOME/.config/taffybar/taffybar.hs")
      ])

  -- Hibernate
  , ((modMask .|. controlMask .|. shiftMask , xK_h),
     spawn "systemctl hibernate")

  -- Toggle multi monitor display (xrandr wrapper)
  -- TODO redo tese?
  , ((modMask .|. shiftMask, xK_d), submap . M.fromList $
      [ ((0, xK_0), spawn "displays-toggle 0")
      , ((0, xK_1), spawn "displays-toggle 1")
      , ((0, xK_2), spawn "displays-toggle 2")
      ])
  -- For now just support monitor on top
  , ((modMask, xK_d), submap . M.fromList $
      [ ((0, xK_1), spawn "xrandr --output eDP-1 --auto --output DP-3 --off")
      , ((0, xK_2), spawn "xrandr --output eDP-1 --primary --mode 2256x1504 --pos 152x1440 --rotate normal --output DP-3 --mode 2560x1440 --pos 0x0")
      ])

  -- Toggle theme
  , ((modMask, xK_t), do
      spawn "$HOME/.scripts/toggle-theme"
      spawn "xmonad --recompile"
      restart "xmonad" True
    )
  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_o),
     spawn myLauncher)

  -- Spawn washout cams
  , ((modMask, xK_s),
     spawn "vlc https://cams.cdn-surfline.com/cdn-ec/ec-washout/playlist.m3u8")

  -- Spawn other cams
  , ((modMask .|. shiftMask, xK_s), submap . M.fromList $
      let w = spawn "vlc https://cams.cdn-surfline.com/cdn-ec/ec-washout/playlist.m3u8"
          s = spawn "vlc https://cams.cdn-surfline.com/cdn-ec/ec-washoutsouth/playlist.m3u8"
          n = spawn "vlc https://cams.cdn-surfline.com/wsc-east/ec-follypiernorthcam.stream/playlist.m3u8"
          p = spawn "vlc https://cams.cdn-surfline.com/wsc-east/ec-follypiersouthcam.stream/playlist.m3u8"
      in [ ((0, xK_w), w)
         , ((0, xK_s), s)
         , ((0, xK_n), n)
         , ((0, xK_p), p)
         , ((0, xK_a), w >> s >> n >> p)
         ])

  -- Spawn firefox on mod + f
  , ((modMask, xK_f),
     sendMessage (Toggle "Full"))
  , ((modMask .|. shiftMask, xK_f),
     spawn "firefox --private-window")

  -- Take a selective screenshot.
  , ((modMask, xK_y),
     -- sleep 0.1; 
     spawn "scrot -fs -e 'mv $f ~/screenshots/'")

  -- Take a full screenshot.
  , ((modMask .|. shiftMask, xK_y),
     spawn "scrot -e 'mv $f ~/screenshots/'")
     -- spawn "sleep 0.2; scrot -s -e 'mv $f ~/screenshots/ && dragon-drag-and-drop -x ~/screenshots/$f'")

  -- Toggle status bar
  , ((modMask, xK_b),
     sendMessage ToggleStruts)

  -- Increase brightness.
  , ((0, xF86XK_MonBrightnessUp),
     spawn "light -A 5")

  -- Decrease brightness.
  , ((0, xF86XK_MonBrightnessDown),
     spawn "light -U 5")

  -- Mute volume.
  , ((0, xF86XK_AudioMute),
     spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

  -- Decrease volume.
  , ((0, xF86XK_AudioLowerVolume),
     spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")

  -- Increase volume.
  , ((0, xF86XK_AudioRaiseVolume),
     spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")

  -- Toggle workspace
  , ((modMask, xK_Tab),
      toggleWS)

  -- Toggle screen (well, toggle for 2 screens)
  , ((mod4Mask, xK_Tab),
      nextScreen)

  -- Move window to other screen 
  , ((mod4Mask .|. shiftMask, xK_Tab),
      shiftNextScreen)

  -- Prompt for clipboard history
  , ((modMask, xK_p),
      spawn "CM_LAUNCHER=rofi clipmenu")

  -- Connect bluetooth
  , ((modMask, xK_c),
      spawn "~/.scripts/rofi-bluetooth")

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask, xK_w),
     kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space),
     sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space),
     setLayout $ XMonad.layoutHook conf)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n),
     refresh)

  -- Move focus to the next window.
  , ((modMask, xK_j),
     windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k),
     windows W.focusUp  )

  -- Swap the focused window and the master window.
  , ((modMask .|. shiftMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink >> sendMessage (ExpandTowards L))

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand >> sendMessage (ExpandTowards R))

  -- Shrink/expand secondary panes
  , ((modMask .|. shiftMask, xK_h),
     sendMessage MirrorShrink >> sendMessage (ExpandTowards U))
  , ((modMask .|. shiftMask, xK_l),
     sendMessage MirrorExpand >> sendMessage (ExpandTowards D))

  , ((myModMask .|. shiftMask, xK_a),
     sendMessage Equalize)

  , ((myModMask, xK_a),
     sendMessage Rotate)

  -- Push window back into tiling.
  , ((modMask .|. shiftMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask .|. shiftMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask .|. shiftMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Quit xmonad. 
  , ((modMask .|. shiftMask, xK_q),
     io exitSuccess)

  -- Restart xmonad.
  , ((modMask, xK_r), do
      spawn "xmonad --recompile"
      restart "xmonad" True
    )
  ]

  ++

  -- mod-[1..0], Switch to workspace N
  -- mod-shift-[1..0], Move client to workspace N
  [((m .|. modMask, k), windows $ onCurrentScreen f i)
    | (i, k) <- zip (workspaces' conf) $ [xK_1 .. xK_9] ++ [xK_0]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  ++

  -- use super for focus & moving screens
  -- super-N, Switch to physical/Xinerama screens N
  -- super-shift-N Move client to screen N
  [((m .|. mod4Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_1 .. xK_9] [0 .. 10]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

------------------------------------------------------------------------
-- Custom startup
myStartupHook :: X ()
myStartupHook = do
  doOnce $ do
    spawn "clipmenud"
    spawn "/usr/lib/polkit-kde-authentication-agent-1"
    spawn "/usr/bin/dunst"
    spawnOn "9" "1password"
    spawnOn "3" "obsidian"
    windows $ W.view "1"
  spawn "feh --bg-scale --no-fehbg ~/.config/bg/retro-linux.png"
  spawn "/home/sam/.config/taffybar/run"
  setSessionStarted

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = xmonad $ docks $ ewmh $ pagerHints $ def
  { terminal           = myTerminal
  , focusFollowsMouse  = myFocusFollowsMouse
  , borderWidth        = myBorderWidth
  , modMask            = myModMask
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , keys               = myKeys
  , mouseBindings      = myMouseBindings
  , workspaces         = myWorkspaces
  , layoutHook         = myLayoutHook
  , startupHook        = myStartupHook
  , manageHook         = myManageHook
  }
