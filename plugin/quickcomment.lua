if vim.g.loaded_quickcomment then
    return
end
vim.g.loaded_quickcomment = true

vim.g.quickcomment_escapecommentstring = function(comment_string)
    local escaped_string = ''

    comment_string:gsub(".", function(c)
        if c:find('[-?+*%]%[.%%()$^]') == nil then
            escaped_string = escaped_string .. c
        else
            escaped_string = escaped_string .. '%' .. c
        end
    end)

    return escaped_string
end

vim.g.quickcomment_getcommentstr = function ()
    local comment_string = vim.api.nvim_buf_get_option(0, 'comments')
    local has_comment = string.find(comment_string, ',')
    if has_comment ~= nil and has_comment > 1 then
        comment_string = string.sub(comment_string, 1, has_comment - 1)
    end

    local colon_idx = string.find(comment_string, ':')
    if colon_idx ~= nil then
        comment_string = string.sub(comment_string, colon_idx + 1)
    end

    if string.len(comment_string) == 0 then
        return nil
    end

    return comment_string
end

vim.g.quickcomment_togglecommentlines = function (line_start, line_end, comment_string)
    if comment_string == nil then
        comment_string = vim.g.quickcomment_getcommentstr()
    end
    local escaped_comment_string = vim.g.quickcomment_escapecommentstring(comment_string)
    local lines = vim.api.nvim_buf_get_lines(0, line_start, line_end, false)
    for i, line in ipairs(lines) do
        local start_col, end_col = string.find(line, '^%s*' .. escaped_comment_string)
        if start_col ~= nil then
            local comment_part = string.sub(line, 1, end_col)
            local pstart_col, pend_col = string.find(comment_part, comment_string)
            lines[i] = string.sub(line, 1, pstart_col - 1) .. string.sub(line, end_col + 1)
        else
            lines[i] = comment_string .. line
        end
    end
    vim.api.nvim_buf_set_lines(0, line_start, line_end, false, lines)
end

vim.g.quickcomment_togglecommentline = function (linen, comment_string)
    if linen == nil then
        linen = vim.api.nvim_win_get_cursor(0)[1]
    end
    vim.g.quickcomment_togglecommentlines(linen - 1, linen, comment_string)
end
