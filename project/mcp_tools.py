from mcp.server.fastmcp import FastMCP
import subprocess
import yaml
from pydantic import Field

mcp = FastMCP("script_tools")

with open("tools.yaml", "r") as f:
    config = yaml.safe_load(f)

def register_tool(name: str, executable: str, description: str):
    
    @mcp.tool(name=f"run_{name}", description=f"Run {name}: {description}")
    def run_func(
        params: list[str] = Field(default=None, description="A list of command-line arguments to pass to the script."),
        input_text: str = Field(default=None, description="Optional text to be passed to the script via standard input (stdin).")
    ) -> str:
        """
        Args:
            params: A list of command-line arguments to pass to the script.
            input_text: Optional text to be passed to the script via standard input (stdin).
        """
        cmd = [executable] + (params or [])
        result = subprocess.run(cmd, input=input_text, capture_output=True, text=True)
        return result.stdout or result.stderr

    @mcp.tool(name=f"help_{name}", description=f"Get help for {name}")
    def help_func(params: list[str] = None) -> str:
        cmd = [executable] + (params or []) + ["--help"]
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.stdout or result.stderr

for tool_name, tool_info in config.get("tools", {}).items():
    register_tool(tool_name, tool_info["executable"], tool_info["description"])

if __name__ == "__main__":
    mcp.run()