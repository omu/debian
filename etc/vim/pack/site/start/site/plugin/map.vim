" Turkish-Q keyboard spesific.

if &enc != 'utf-8'
  finish
endif

" ------------------------------------------------------------------------------
" Map Turkish keys
" ------------------------------------------------------------------------------

" ı → Dotless i
" 'q' kaydedicisindeki içeriği çalıştır (makro kayıtlarında yararlı)
if mapcheck("<Char-305>") == "" | noremap <Char-305> @q | endif

" ü → udiaeresis
" Kursördeki anahtar kelimeye atla
if mapcheck("<Char-252>") == "" | noremap <Char-252> <c-]> | endif

" Ü → Udiaeresis
" TODO: Rezerve
if mapcheck("<Char-220>") == "" | noremap <Char-220> :echo "Reserved"<cr> | endif

" ö → odiaeresis
" `
if mapcheck("<Char-246>") == "" | noremap <Char-246> ` | endif

" Ö → Odiaeresis
" '
if mapcheck("<Char-214>") == "" | noremap <Char-214> ' | endif

" ç → ccedilla
" ``  Son atlamadan önceki konuma dön
if mapcheck("<Char-231>") == "" | noremap <Char-231> `` | endif

" Ç → Ccedilla
" '' Son atlamadan önceki satıra dön
if mapcheck("<Char-199>") == "" | noremap <Char-199> '' | endif

" ğ → gbreve
" }
if mapcheck("<Char-287>") == "" | noremap <Char-287> } | vnoremap <Char-287> } | endif

" Ğ → Gbreve
" }
if mapcheck("<Char-286>") == "" | noremap <Char-286> { | vnoremap <Char-286> { | endif

" ş → scedilla
" Kursörün altındaki kelimeyi bul/değiştir
if mapcheck("<Char-351>") == ""
  noremap <Char-351> :%s/<c-r>=expand("<cword>")<cr>//gc<left><left><left>
  vnoremap <Char-351> :s/<c-r>=expand("<cword>")<cr>//gc<left><left><left>
endif

" Ş → Scedilla
" Bul/değiştir istemine geç
if mapcheck("<Char-350>") == ""
  noremap <Char-350> :%s///gc<left><left><left><left>
  vnoremap <Char-350> :s///gc<left><left><left><left>
endif

" é → Eacute
" Paste kipini değiştir
if mapcheck("<Char-233>") == "" | set pastetoggle=<Char-233> | endif

" vim:set ft=vim et sw=2:

