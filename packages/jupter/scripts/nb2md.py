# -*- coding: utf-8 -*-
"""将 Jupyter notebook 转为与内容完全一致的 Markdown。"""
import json
import sys
from pathlib import Path


def _join_source(lines):
    return "".join(lines) if isinstance(lines, list) else lines


def _extract_stdout(outputs):
    parts = []
    for o in outputs or []:
        if o.get("output_type") == "stream" and o.get("name") == "stdout":
            text = o.get("text")
            if text:
                parts.append(_join_source(text))
        if o.get("output_type") == "stream" and o.get("name") == "stderr":
            text = o.get("text")
            if text:
                parts.append(_join_source(text))
    return "".join(parts).rstrip()


def nb2md(nb_path, out_path=None, include_output=True):
    nb_path = Path(nb_path)
    if out_path is None:
        out_path = nb_path.with_suffix(".md")
    else:
        out_path = Path(out_path)
    nb = json.loads(nb_path.read_text(encoding="utf-8"))
    lines = []
    for cell in nb.get("cells", []):
        ctype = cell.get("cell_type", "")
        src = _join_source(cell.get("source", []))
        if not src.strip() and ctype == "code":
            lines.append("```python\n\n```\n\n")
            continue
        if ctype == "markdown":
            lines.append(src.rstrip())
            lines.append("\n\n")
        elif ctype == "code":
            lines.append("```python\n")
            lines.append(src.rstrip())
            lines.append("\n```")
            if include_output:
                out_text = _extract_stdout(cell.get("outputs", []))
                if out_text:
                    lines.append("\n\n```\n")
                    lines.append(out_text)
                    lines.append("\n```")
            lines.append("\n\n")
    out_path.write_text("".join(lines).rstrip() + "\n", encoding="utf-8")
    return str(out_path)


if __name__ == "__main__":
    p = "arima-demand inv.ipynb"
    if len(sys.argv) > 1:
        p = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else None
    nb2md(p, out)
    print("Done")
