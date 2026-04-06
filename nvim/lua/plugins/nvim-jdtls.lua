return {
  'mfussenegger/nvim-jdtls',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  ft = { 'java' },
  opts = function()
    -- Use the direct path for lombok since we know where it is
    local lombok_jar = '/Users/lee/.local/share/nvim/mason/share/jdtls/lombok.jar'
    if vim.fn.filereadable(lombok_jar) == 0 then
      lombok_jar = nil
    end

    return {
      root_dir = require('lspconfig').util.root_pattern('.git', 'mvnw', 'gradlew'),
      project_name = function(root_dir)
        return root_dir and vim.fs.basename(root_dir)
      end,
      -- Use Homebrew's jdtls path directly
      cmd = {
        '/opt/homebrew/bin/jdtls',
        lombok_jar and string.format('--jvm-arg=-javaagent:%s', lombok_jar) or nil,
      },
      full_cmd = function(opts)
        local fname = vim.api.nvim_buf_get_name(0)
        local root_dir = opts.root_dir(fname)
        local project_name = opts.project_name(root_dir)
        local cmd = {}
        for _, v in ipairs(opts.cmd) do if v then table.insert(cmd, v) end end
        if project_name then
          vim.list_extend(cmd, {
            '-configuration', vim.fn.stdpath('cache') .. '/jdtls/' .. project_name .. '/config',
            '-data', vim.fn.stdpath('cache') .. '/jdtls/' .. project_name .. '/workspace',
          })
        end
        return cmd
      end,
    }
  end,
  config = function(_, opts)
    local function attach_jdtls()
      local fname = vim.api.nvim_buf_get_name(0)
      require('jdtls').start_or_attach({
        cmd = opts.full_cmd(opts),
        root_dir = opts.root_dir(fname),
        settings = { java = { signatureHelp = { enabled = true } } },
      })
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = attach_jdtls,
    })
    
    attach_jdtls()
  end,
}
