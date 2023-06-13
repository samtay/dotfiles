" perl plugins


" node plugins


" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/sam/.local/share/nvim/plugged/coquille/rplugin/python3/pycoqtop', [
      \ {'sync': v:false, 'name': 'CoqBuild', 'type': 'function', 'opts': {}},
      \ {'sync': v:false, 'name': 'CoqCancel', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqCheck', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqDebug', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqPrint', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqLaunch', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqLocate', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqModify', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqNext', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqQuery', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqRedraw', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqSearch', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqSearchAbout', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqErrorAt', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqRedrawGoal', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqRedrawInfo', 'type': 'function', 'opts': {}},
      \ {'sync': v:false, 'name': 'CoqToCursor', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqStop', 'type': 'function', 'opts': {}},
      \ {'sync': v:false, 'name': 'CoqUndo', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'CoqVersion', 'type': 'function', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', '/home/sam/.local/share/nvim/plugged/deoplete.nvim/rplugin/python3/deoplete', [
      \ {'sync': v:false, 'name': '_deoplete_init', 'type': 'function', 'opts': {}},
     \ ])


" ruby plugins


" python plugins


