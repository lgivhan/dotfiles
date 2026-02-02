vim.api.nvim_create_user_command('H', function(table)
  vim.cmd('help ' .. table.args .. ' | only')
end, { desc = 'Open [H]elp in new tab', nargs = 1 })

-- Custom Git Sync (gs) command
-- Usage: :Gs "your commit message"
vim.api.nvim_create_user_command('Gs', function(opts)
    local msg = opts.args
    if msg == "" then
        print("Error: Commit message required!")
        return
    end

    -- The '!' runs it in your system shell
    -- '&&' ensures each step succeeds before moving to the next
    vim.cmd('!git add . && git commit -m "' .. msg .. '" && git push')
end, { nargs = 1 })

-- STAR Method Template for Interview Prep
vim.api.nvim_create_user_command('Star', function()
    local lines = {
        "### [Company] - [Question/Scenario]",
        "",
        "**Situation:**",
        "- ",
        "",
        "**Task:**",
        "- ",
        "",
        "**Action:**",
        "- ",
        "",
        "**Result:**",
        "- ",
        ""
    }
    -- Inserts the template at the current cursor line
    vim.api.nvim_buf_set_lines(0, vim.fn.line('.') - 1, vim.fn.line('.'), false, lines)
end, {})

-- Specialized Test Automation STAR Template
vim.api.nvim_create_user_command('StarTest', function()
    local lines = {
        "### [Project/Feature] - Test Automation Scenario",
        "",
        "**Situation:** (e.g., Flaky CI/CD pipeline, high manual regression time)",
        "- ",
        "",
        "**Task:** (Your specific goal as an Automation Analyst)",
        "- ",
        "",
        "**Action:**",
        "  - **Tools:** (e.g., Selenium, Playwright, Java/Python, JUnit) ",
        "  - **Implementation:** (How you architected the test suite)",
        "  - ",
        "",
        "**Result:**",
        "  - **Efficiency:** (e.g., Reduced test execution time by X%)",
        "  - **Coverage:** (e.g., Increased automation coverage to Y%)",
        "  - **Bug Prevention:** (How many critical bugs were caught pre-production)",
        ""
    }
    vim.api.nvim_buf_set_lines(0, vim.fn.line('.') - 1, vim.fn.line('.'), false, lines)
end, {})
