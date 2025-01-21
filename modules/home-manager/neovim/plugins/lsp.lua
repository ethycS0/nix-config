local custom_on_attach = function(client, bufnr)
	local bufmap = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr })
	end

	bufmap("<leader>r", vim.lsp.buf.rename)
	bufmap("<leader>a", vim.lsp.buf.code_action)

	bufmap("gd", vim.lsp.buf.definition)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gI", vim.lsp.buf.implementation)
	bufmap("<leader>D", vim.lsp.buf.type_definition)

	bufmap("gr", require("telescope.builtin").lsp_references)
	bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
	bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)

	bufmap("K", vim.lsp.buf.hover)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

-- Lua
require("lazydev").setup()
require("lspconfig").lua_ls.setup({
	on_attach = custom_on_attach,
	capabilities = capabilities,
	root_dir = function()
		return vim.loop.cwd()
	end,
	cmd = { "lua-language-server" },
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})

-- C/C++
require("lspconfig").clangd.setup({
	on_attach = function(client, bufnr)
		custom_on_attach(client, bufnr)
		client.server_capabilities.documentFormattingProvider = true
		client.server_capabilities.documentRangeFormattingProvider = true
		client.server_capabilities.signatureHelpProvider = false
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		vim.bo[bufnr].tabstop = 8
		vim.bo[bufnr].shiftwidth = 8
		vim.bo[bufnr].expandtab = true
	end,
	capabilities = capabilities,
	filetypes = { "c", "ino", "cpp", "objc", "objcpp", "cuda", "proto" },
	cmd = { "clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	root_dir = require("lspconfig").util.root_pattern(
		'.clangd',
		'.clang-tidy',
		'.clang-format',
		'compile_commands.json',
		'compile_flags.txt',
		'configure.ac',
		'.git'
	),
	init_options = {
		fallbackFlags = { "-nostdinc++" } -- Add minimal fallback options if needed
	}
})

-- Rust
require 'lspconfig'.rust_analyzer.setup({
	cmd = { "/run/current-system/sw/bin/rust-analyzer" },
})

-- Nix
require 'lspconfig'.nil_ls.setup({

})
