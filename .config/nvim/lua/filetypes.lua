-- This should probably not go into the repo, as it's not universally usefull
vim.filetype.add({
    extension = {
        tf = "terraform",
        tfvars = "terraform",
        yaml = "yaml",
        yml = "yaml",
    },
    filename = {
        ["Dockerfile"] = "dockerfile",
        [".dockerignore"] = "gitignore",
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
    },
    pattern = {
        [".*%.tf"] = "terraform",
        [".*%.tfvars"] = "terraform",
    }
})
