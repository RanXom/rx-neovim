-- ============================================================================
-- UTILS
-- Small reusable helper functions
-- ============================================================================

local M = {}

---Expand a GitHub shorthand ("user/repo") into a full URL.
---@param repo string
---@return string
function M.gh(repo) return 'https://github.com/' .. repo end

return M
