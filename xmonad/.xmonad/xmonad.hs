-- xmonad config
-- Author: Sam Tay
-- http://github.com/samtay/dotfiles

import Data.Semigroup ((<>))
import System.IO
import System.Exit
import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Actions.CycleWS
import XMonad.Actions.Submap
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Grid
import XMonad.Layout.ThreeColumns
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M


------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "kitty"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
--myLauncher = "$(yeganesh -x)"
myLauncher = "rofi -matching fuzzy -show run"

------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = map show ([1..9] ++ [0])

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
{-
myManageHook = composeAll
    [ className =? "Google-chrome"  --> doShift "3:web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
myManageHook = def
-}

------------------------------------------------------------------------
-- XMonad Prompt
--
-- TODO explore
myXPConfig = def

------------------------------------------------------------------------

------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayoutHook = avoidStruts $ (threecol ||| tall ||| tabbed') ||| distractionFree
    where tabbed' = tabbed shrinkText tabConfig
          tall = Tall 1 (3/100) (1/2)
          threecol = ThreeColMid 1 (3/100) (1/3)
          distractionFree = noBorders (fullscreenFull Full)

------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the tomorrow night eighties theme.
--
myNormalBorderColor  = currentline
myFocusedBorderColor = brightGreen
myBorderWidth = 2

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = def {
    fontName = "xft:Source Code Pro:size=9",
    activeBorderColor   = aqua,
    activeTextColor     = foreground,
    activeColor         = selection,
    inactiveBorderColor = selection,
    inactiveTextColor   = comment,
    inactiveColor       = background
}

-- Tomorrow Night Eighties theme
background = "#2d2d2d"
currentline = "#393939"
selection = "#515151"
foreground = "#cccccc"
comment = "#999999"
red = "#f2777a"
orange = "#f99157"
yellow = "#ffcc66"
green = "#99cc99"
brightGreen = "#77ee77"
aqua = "#66cccc"
blue = "#6699cc"
purple = "#cc99cc"

------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod1Mask

editFile f = spawn $ myTerminal ++ " -e \"nvim " ++ f ++ "\""

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask .|. shiftMask, xK_Return),
     spawn $ XMonad.terminal conf)

  -- Shell prompt
  , ((modMask .|. controlMask, xK_Return),
     shellPrompt myXPConfig)

  -- Start editing dotfiles
  , ((modMask, xK_x), submap . M.fromList $
      [ ((0, xK_x), editFile "$HOME/.xmonad/xmonad.hs")
      , ((0, xK_v), editFile "$HOME/.config/nvim/init.vim")
      , ((0, xK_z), editFile "$HOME/.zshrc")
      ])

  -- Ensure panel is up
  , ((modMask .|. shiftMask, xK_r),
     spawn "xfce4-panel --disable-wm-check")
     --spawn "xfce4-panel -r --disable-wm-check")

  -- XFCE settings
  , ((modMask .|. shiftMask, xK_comma),
     spawn "xfce4-settings-manager")

  -- Toggle multi monitor display (xrandr wrapper)
  , ((modMask .|. shiftMask, xK_d), submap . M.fromList $
      [ ((0, xK_0), spawn "displays-toggle 0")
      , ((0, xK_1), spawn "displays-toggle 1")
      , ((0, xK_2), spawn "displays-toggle 2")
      ])

  -- Toggle theme
  , ((modMask .|. shiftMask, xK_t),
      spawn "$HOME/git/dotfiles/toggle-theme"
    )
  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_p),
     spawn myLauncher)

  -- Spawn washout cams
  , ((modMask, xK_s),
     spawn "vlc https://cams.cdn-surfline.com/wsc-east/ec-washoutcam.stream/chunklist.m3u8")

  -- Spawn other cams
  , ((modMask .|. shiftMask, xK_s), submap . M.fromList $
      let w = spawn "https://cams.cdn-surfline.com/cdn-ec/ec-washout/playlist.m3u8"
          s = spawn "vlc https://cams.cdn-surfline.com/wsc-east/ec-washoutsouthcam.stream/chunklist.m3u8"
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
     spawn "firefox")

  -- Take a selective screenshot.
  , ((modMask, xK_y),
     spawn "sleep 0.2; scrot -s")

  -- Take a full screenshot.
  , ((modMask .|. shiftMask, xK_y),
     spawn "sleep 0.2; scrot")

  -- Toggle status bar
  , ((modMask, xK_b),
     sendMessage ToggleStruts)

{-
  -- Increase brightness.
  , ((0, xF86XK_MonBrightnessUp),
     spawn "light -A 5")

  -- Decrease brightness.
  , ((0, xF86XK_MonBrightnessDown),
     spawn "light -U 5")
-}

  -- Mute volume.
  , ((0, xF86XK_AudioMute),
     spawn "amixer -q set Master toggle")

  -- Decrease volume.
  , ((0, xF86XK_AudioLowerVolume),
     spawn "amixer -q set Master 5%-")

  -- Increase volume.
  , ((0, xF86XK_AudioRaiseVolume),
     spawn "amixer -q set Master 5%+")

  -- Decrease volume.
  , ((modMask .|. controlMask, xK_j),
     spawn "amixer -q set Master 10%-")

  -- Increase volume.
  , ((modMask .|. controlMask, xK_k),
     spawn "amixer -q set Master 10%+")

  -- Audio previous.
  , ((0, 0x1008FF16),
     spawn "")

  -- Play/pause.
  , ((0, 0x1008FF14),
     spawn "")

  -- Audio next.
  , ((0, 0x1008FF17),
     spawn "")

  -- Toggle screen TODO UNCOMMENT WITH NEW MONITOR
  --, ((modMask, xK_quoteleft),
  --    nextScreen)

  -- Toggle workspace
  , ((modMask, xK_Tab),
      toggleWS)

  --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c),
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

  -- Move focus to the master window.
  , ((modMask, xK_m),
     windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask, xK_Return),
     windows W.swapMaster)

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_j),
     windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_k),
     windows W.swapUp    )

  -- Shrink the master area.
  , ((modMask, xK_h),
     sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l),
     sendMessage Expand)

  -- Push window back into tiling.
  , ((modMask, xK_t),
     withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma),
     sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period),
     sendMessage (IncMasterN (-1)))

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q),
     spawn "xfce4-session-logout")

  -- Restart xmonad.
  , ((modMask, xK_q),
     spawn "xmonad --recompile" >> restart "xmonad" True)
  ]

  ++

  -- mod-[1..0], Switch to workspace N
  -- mod-shift-[1..0], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_e] [1, 0]
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
--
-- Trying to just get this damn xfce panel to work on start up.
myStartupHook :: X ()
myStartupHook = do
  ewmhDesktopsStartup
  spawn "xfce4-panel --disable-wm-check"
  spawn "displays-toggle 1"
  spawn "ethernet"

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = xmonad $ xfceConfig
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
  }
