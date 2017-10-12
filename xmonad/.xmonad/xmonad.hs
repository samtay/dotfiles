-- xmonad config
-- Author: Sam Tay
-- http://github.com/samtay/dotfiles

import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
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
myTerminal = "termite"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
--myLauncher = "$(yeganesh -x)"
myLauncher = "dmenu_run -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -nb '#000000' -nf '#FFFFFF' -sb '#2c2c2c' -sf '#99cc99'"


------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:code", "2:repl", "3:chrome"] ++ map show ([4..9] ++ [0])

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
    [ className =? "Google-chrome"  --> doShift "3:web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]

------------------------------------------------------------------------
-- XMonad Prompt
--
-- TODO explore
myXPConfig = defaultXPConfig

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
myLayoutHook = avoidStruts (threecol ||| tall ||| tabbed') ||| distractionFree
    where tabbed' = tabbed shrinkText tabConfig
          threecol = ThreeColMid 1 (3/100) (1/3)
          tall = Tall 1 (3/100) (2/3)
          grid = GridRatio (5/2)
          distractionFree = noBorders (fullscreenFull Full)

------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the tomorrow night eighties theme.
--
myNormalBorderColor  = currentline
myFocusedBorderColor = brightGreen
myBorderWidth = 2

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    fontName = "xft:Source Code Pro:size=9",
    decoHeight = 34,
    activeBorderColor   = aqua,
    activeTextColor     = foreground,
    activeColor         = selection,
    inactiveBorderColor = selection,
    inactiveTextColor   = comment,
    inactiveColor       = background
}

-- Color of current window title in xmobar.
xmobarTitleColor = green

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = purple

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

  -- Toggle multi monitor display (xrandr wrapper)
  , ((modMask .|. shiftMask, xK_d), submap . M.fromList $
      [ ((0, xK_0), spawn "displays-toggle 0")
      , ((0, xK_1), spawn "displays-toggle 1")
      , ((0, xK_2), spawn "displays-toggle 2")
      ])

  -- Rotate screen
  , ((modMask .|. shiftMask, xK_t), submap . M.fromList $
      [ ((0, xK_l), spawn "xrandr --output eDP-1 --rotate left")
      , ((0, xK_r), spawn "xrandr --output eDP-1 --rotate right")
      , ((0, xK_i), spawn "xrandr --output eDP-1 --rotate inverted")
      , ((0, xK_n), spawn "xrandr --output eDP-1 --rotate normal")
      ])

  -- Spawn the launcher using command specified by myLauncher.
  -- Use this to launch programs without a key binding.
  , ((modMask, xK_p),
     spawn myLauncher)

  -- Spawn washout cam on mod + s
  , ((modMask, xK_s),
     spawn "vlc https://cams.cdn-surfline.com/wsc-east/ec-washoutcam.stream/chunklist.m3u8")

  -- Spawn firefox on mod + f
  , ((modMask, xK_f),
     spawn "firefox")

  -- Spawn chrome
  , ((modMask, xK_g),
     spawn "chromium")

  -- Spawn chrome
  , ((modMask .|. shiftMask, xK_g),
     spawn "chromium --incognito")

  -- Take a selective screenshot.
  , ((modMask, xK_y),
     spawn "sleep 0.2; scrot -s")

  -- Take a full screenshot.
  , ((modMask .|. shiftMask, xK_y),
     spawn "sleep 0.2; scrot")

  -- Toggle status bar
  , ((modMask, xK_b),
     sendMessage ToggleStruts)

  -- Increase brightness.
  , ((0, xF86XK_MonBrightnessUp),
     spawn "xbacklight + 5")

  -- Decrease brightness.
  , ((0, xF86XK_MonBrightnessDown),
     spawn "xbacklight - 5")

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
     io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask, xK_q),
     restart "xmonad" True)
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
    | (key, sc) <- zip [xK_e, xK_r] [1, 0]
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
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
myDefaultPP = xmobarPP
  { ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
  , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
  , ppSep = "   "
  }



------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  xmproc   <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ defaults
    { logHook    = dynamicLogWithPP $ myDefaultPP { ppOutput = hPutStrLn xmproc }
    , manageHook = manageDocks <+> myManageHook
    , handleEventHook = docksEventHook
    }

------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    -- key bindings
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    -- hooks, layouts
    workspaces         = myWorkspaces,
    layoutHook         = smartBorders $ myLayoutHook,
    manageHook         = myManageHook,
    startupHook        = myStartupHook
}
