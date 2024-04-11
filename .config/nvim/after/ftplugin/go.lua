
-- Go error abbrevation.
-- TODO: learn how to turn this on only for .go files.
vim.cmd("iab ife if err != nil {<CR>return fmt.Errorf(\"failed to: %w\", err)<CR>}<esc>k^7wi")
