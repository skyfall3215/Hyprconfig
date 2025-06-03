" ========== GENEL AYARLAR ==========
set number              " Satır numaralarını göster
set relativenumber      " Nispi satır numaraları (navigasyon için iyi)
set cursorline          " İmleç satırını vurgula

set tabstop=4           " Tab genişliği
set shiftwidth=4        " Otomatik girinti genişliği
set expandtab           " Tab yerine boşluk
set smartindent         " Akıllı girinti

set nowrap              " Uzun satırlar taşmasın
set hidden              " Kaydetmeden buffer değiştir
set scrolloff=8         " Kenarlarda boşluk kalsın
set clipboard=unnamedplus " Sistem panosunu kullan

" ========== ARAMA ==========
set ignorecase          " Küçük-büyük fark etme
set smartcase           " Ama aramada büyük harf varsa dikkat et
set incsearch           " Ararken eşleşmeleri anlık göster
set hlsearch            " Eşleşmeleri vurgula

" leader tuşu
let mapleader = " "

" <leader><space> ile vurguları temizle
nnoremap <leader><space> :nohlsearch<CR>

" ========== DOSYA AYARLARI ==========
set undofile
set undodir=~/.local/share/nvim/undo
silent! call mkdir(&undodir, "p")

syntax on
filetype plugin indent on

" ========== KISAYOLLAR ==========
nnoremap <leader>w :w<CR>   " <leader>w ile kaydet
nnoremap <leader>q :q<CR>   " <leader>q ile çık

" ========== PLUGİN YÖNETİCİSİ ==========
call plug#begin('~/.local/share/nvim/plugged')

" Hafif, verimli eklentiler
Plug 'tpope/vim-surround'         " cs, ds, ys ile çevreleme
Plug 'tpope/vim-commentary'       " gc ile yorum satırı
Plug 'jiangmiao/auto-pairs'       " Parantezleri otomatik kapatır
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

call plug#end()

" For Catppuccin Mocha 
colorscheme catppuccin-mocha

lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
END



" Tabs
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
