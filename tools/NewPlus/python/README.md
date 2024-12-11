# mylib

Package description

## Environment setting

Create and activate virtual environment.

For Windows:

```powershell
# 1. Install from https://pythonlinks.python.jp/en/index.html

# 2. Install additional and specific version
winget install Python.Python.3.11

# 3. Allow to run Powershell script
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 4. Create and activate virtual environment
py -3.11 -m venv .venv
.\.venv\Scripts\setup.ps1
```

For Ubuntu:

```bash
# 1. Install mise
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

# 2. Install Python for specific version
mise use python@3.10

# 3. Create and activate virtual environment
python -m venv .venv
source ./.venv/bin/activate

# or do 2 & 3 by one line
mise trust
```

Install this library and run:

```shell
# Install this library and its dependencies
pip install -e .

# Help message for this CLI
python -m mylib --help
```
