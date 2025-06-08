{
  enable = true;
  defaultEditor = true;
  colorschemes = {
    tokyonight = {
      enable = true;
      settings = {
        style = "storm";
      };
    };
  };
  keymaps = [
    {
      key = "1";
      action = "^";
    }
    {
      key = "<D-a>";
      action = "<esc>ggVG<CR>";
    }
    {
      key = "<Enter>";
      action = "o<ESC>";
    }
    {
      key = "<S-Enter>";
      action = "O<ESC>";
    }
    {
      key = "<C-b>";
      action = "K";
    }
    {
      key = "K";
      action = "i<CR><Esc>";
    }
    {
      key = "U";
      action = "<Cmd-r>";
    }
    {
      mode = "x";
      key = "p";
      action = "P";
    }
    {
      mode = "x";
      key = "P";
      action = "p";
    }
  ];
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
  clipboard = {
    register = "unnamedplus";
  };
  opts = {
    breakindent = true;
    bs = [ "indent" "eol" "start" ]; # Allow backspacing over everything in insert mode
    confirm = true; # Show a dialog when :q, :w, or :wq fails
    cursorline = true; # Highlight curosor line number
    encoding = "Utf-8"; # Use Utf-8 encoding
    expandtab = true; # Expand tabs to spaces
    fileformat = "unix"; # File mode is unix
    hidden = true; # Remember undo after quitting
    history = 50; # Keep 50 lines of command history
    hlsearch = true; # Highlight search results
    ignorecase = true; # Case insensitive searching
    inccommand = "split";
    incsearch = true; # Search while typing
    lazyredraw = true; # No redraw in macros
    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }"; # Show whitespaces
    magic = true; # Change the way backslashes are used in search patterns
    # mouse = "v"; # Use mouse in visual mode (not normal,insert,command,help mode
    # nobackup = true; # No backup~ files
    # nowrap = true; # Do not wrap lines
    number = true; # Show line numbers
    ruler = true; # Show cursor position in status bar
    scrolloff = 10; # Show 10 lines before and after cursor
    shiftwidth = 2; # Spaces for autoindents
    showcmd = true; # Show command in status bar
    showmode = true; # Show vim mode in status bar
    signcolumn = "yes";
    smartcase = true; # Become case sensitive in search if uppercase characters included
    smartindent = true; # Smart tab handling for indentation
    smarttab = true; # Use spaces for tabs 
    splitbelow = true;
    splitright = true;
    tabstop = 2; # Number of spaces a tab counts for
    timeoutlen = 300;
    title = true;
    undofile = true;
    updatetime = 250;
    wildmenu = true; # Completion with menu

    # matchpairs+=<:> # Match pairs for for html/xml
    # statusline=%=%m\ %c\ %f # modified, charchount, filepath
    # viminfo='20,\"500 # remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
    # wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn

    
    # filetype plugin indent on # Use of the filetype plugins, auto completion and indentation support
  };
}
