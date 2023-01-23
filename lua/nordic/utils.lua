local M = {}

-- Set the highlight groups.
function M.highlight(table)
    for group, config in pairs(table) do
        vim.api.nvim_set_hl(0, group, config)
    end
end

-- Merge two lua tables.
function M.merge(table1, table2)
    if table1 == table2 == nil then return {} end
    if table1 == nil then return table2
    elseif table2 == nil then return table1
    end
    return vim.tbl_deep_extend(
        "force",
        table1,
        table2
    )
end

function M.hex_to_rgb(str)
    str = string.lower(str)
    return {
        r = tonumber(str:sub(2, 3), 16),
        g = tonumber(str:sub(4, 5), 16),
        b = tonumber(str:sub(6, 7), 16)
    }
end

function M.rgb_to_hsv(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)

    local h, s, v
    v = max

    local d = max - min
    if max == 0 then
        s = 0
    else
        s = d / max
    end

    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d
            if g < b then
                h = h + 6
            end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end

    return { h, s, v }
end

function M.hsv_to_rbg(h, s, v)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0     then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255
end

return M
