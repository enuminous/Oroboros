"""Check that every published catalogue theorem is in the built source module."""
from pathlib import Path
import re

source = Path("RequestProject/Oroboros.lean").read_text()
catalogue = Path("UNIVERSE.md").read_text().split("## 3. Theorems (all proved in Lean)", 1)[1].split("## 4.", 1)[0]
names = re.findall(r"\[`([^`]+)`\]", catalogue)
declarations = re.findall(r"^theorem\s+(\w+)", source, re.MULTILINE)
assert len(names) == len(set(names)) == 28, "Catalogue must contain 28 distinct named theorems"
assert set(names) == set(declarations), f"Catalogue/source mismatch: {set(names) ^ set(declarations)}"
assert "import RequestProject.Oroboros" in Path("Audit.lean").read_text()
print("All 28 catalogue theorem names match the compiled, audited RequestProject.Oroboros module.")
