-- MIT License
-- 
-- Copyright (c) 2022 Stephen Seo
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

if vim.g.loaded_quickcomment then
    return
end
vim.g.loaded_quickcomment = true

vim.g.quickcomment_escapepercent = function(string_to_escape)
    local escaped_string = ''

    string_to_escape:gsub(".", function(c)
        if c:find('%%') == nil then
            escaped_string = escaped_string .. c
        else
            escaped_string = escaped_string .. '%' .. c
        end
    end)

    return escaped_string
end

vim.g.quickcomment_escapestring = function(string_to_escape)
    local escaped_string = ''

    string_to_escape:gsub(".", function(c)
        if c:find('[-?+*%]%[.%%()$^]') == nil then
            escaped_string = escaped_string .. c
        else
            escaped_string = escaped_string .. '%' .. c
        end
    end)

    return escaped_string
end

vim.g.quickcomment_togglecommentlines = function (line_start, line_end)
    -- get comment_string
    local comment_string = vim.b.quickcomment_commentstring_override
    if comment_string == nil then
        comment_string = vim.g.quickcomment_commentstring_override
        if comment_string == nil then
            comment_string = vim.api.nvim_buf_get_option(0, 'commentstring')
            if comment_string == nil then
                print('QuickComment: ERROR: Unable to get comment string')
                return
            end
        end
    end

    -- validate comment_string
    local sub_find, sub_end = comment_string:find('%%s')
    if sub_find == nil then
        print('QuickComment: ERROR: comment_string doesn\'t have "%s"!')
        return
    end

    -- get escaped_string and percent-escaped comment string
    local escaped_string = ''
    local pe_comment_string = ''
    if sub_find ~= nil and sub_find > 1 then
        escaped_string = vim.g.quickcomment_escapestring(comment_string:sub(1, sub_find - 1))
        pe_comment_string = vim.g.quickcomment_escapepercent(comment_string:sub(1, sub_find - 1))
    end
    escaped_string = escaped_string .. '(.*)'
    pe_comment_string = pe_comment_string .. '%s'
    if sub_end < comment_string:len() then
        escaped_string = escaped_string .. vim.g.quickcomment_escapestring(comment_string:sub(sub_end + 1))
        pe_comment_string = pe_comment_string .. vim.g.quickcomment_escapepercent(comment_string:sub(sub_end + 1))
    end

    local escaped_string_prefix = ''
    if vim.b.quickcomment_whitespaceprefix ~= nil then
        if vim.b.quickcomment_whitespaceprefix ~= 0
                or vim.b.quickcomment_whitespaceprefix == true then
            escaped_string_prefix = '%s*'
        end
    elseif vim.g.quickcomment_whitespaceprefix ~= nil
            and vim.g.quickcomment_whitespaceprefix ~= 0
            or vim.g.quickcomment_whitespaceprefix == true then
        escaped_string_prefix = '%s*'
    end

    -- get lines to comment/uncomment
    local lines = vim.api.nvim_buf_get_lines(0, line_start, line_end, false)
    for i, line in ipairs(lines) do
        if line:find('^' .. escaped_string_prefix .. escaped_string) == nil then
            -- not commented, comment line
            lines[i] = pe_comment_string:format(line)
        else
            -- commented, uncomment line
            local match_cap = line:gmatch(escaped_string_prefix .. escaped_string)
            local captured = match_cap()
            if captured ~= nil then
                lines[i] = captured
            else
                print('QuickComment: ERROR: Failed to uncomment line ' .. (i + line_start - 1) .. '!')
            end
        end
    end
    vim.api.nvim_buf_set_lines(0, line_start, line_end, false, lines)
end

vim.g.quickcomment_togglecommentline = function (linen)
    if linen == nil then
        linen = vim.api.nvim_win_get_cursor(0)[1]
    end
    vim.g.quickcomment_togglecommentlines(linen - 1, linen)
end
