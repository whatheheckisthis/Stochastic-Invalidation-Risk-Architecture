#!/usr/bin/env python3
"""Build a schema-driven T-graph table and bidirectional control graph from COMPLIANCE_CROSSWALK.csv."""

from __future__ import annotations

import csv
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "docs" / "COMPLIANCE_CROSSWALK.csv"
OUTPUT_TABLE = ROOT / "docs" / "COMPLIANCE_CROSSWALK_TGRAPH.md"
OUTPUT_GRAPH = ROOT / "docs" / "COMPLIANCE_CONTROL_GRAPH.json"
OUTPUT_GAPS = ROOT / "docs" / "COMPLIANCE_COVERAGE_GAPS.json"

NODE_TYPE_BY_FIELD = {
    "SIRA_Component": "Control",
    "Control_Framework": "Framework",
    "Control_Reference": "Mapping",
    "Control_Description": "Mapping",
    "Evidence_Type": "Evidence",
    "Coverage_Assessment": "Mapping",
    "Gap_Flag": "Mapping",
    "Notes": "Evidence",
}

REL_BY_FIELD = {
    "SIRA_Component": "references",
    "Control_Framework": "references",
    "Control_Reference": "maps_to",
    "Control_Description": "maps_to",
    "Evidence_Type": "evidences",
    "Coverage_Assessment": "supports",
    "Gap_Flag": "supports",
    "Notes": "supports",
}


def normalize_control_tag(value: str) -> str:
    value = re.sub(r"[^A-Za-z0-9]+", "_", value.strip())
    value = re.sub(r"_+", "_", value).strip("_")
    return value[:64] if value else "UNSPECIFIED"


def md_escape(value: str) -> str:
    return value.replace("|", "\\|")


def build_rows() -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    tgraph_rows: list[dict[str, str]] = []
    raw_rows: list[dict[str, str]] = []
    node_counter = 1

    with INPUT.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        field_order = reader.fieldnames or []

        for record in reader:
            raw_rows.append(record)
            control_tag = normalize_control_tag(record.get("Control_Reference", ""))

            parent_id = f"N{node_counter}"
            node_counter += 1
            parent_row = {
                "Node_ID": parent_id,
                "Node_Type": NODE_TYPE_BY_FIELD["SIRA_Component"],
                "Source_Field": "SIRA_Component",
                "Field_Value": record.get("SIRA_Component", ""),
                "Control_Tag": control_tag,
                "Linked_To": "-",
                "Relationship_Type": REL_BY_FIELD["SIRA_Component"],
            }
            tgraph_rows.append(parent_row)

            for field in field_order:
                if field == "SIRA_Component":
                    continue
                child_id = f"N{node_counter}"
                node_counter += 1
                child_row = {
                    "Node_ID": child_id,
                    "Node_Type": NODE_TYPE_BY_FIELD[field],
                    "Source_Field": field,
                    "Field_Value": record.get(field, ""),
                    "Control_Tag": control_tag,
                    "Linked_To": parent_id,
                    "Relationship_Type": REL_BY_FIELD[field],
                }
                tgraph_rows.append(child_row)

    return tgraph_rows, raw_rows


def write_markdown_table(rows: list[dict[str, str]]) -> None:
    headers = [
        "Node_ID",
        "Node_Type",
        "Source_Field",
        "Field_Value",
        "Control_Tag",
        "Linked_To",
        "Relationship_Type",
    ]
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]

    for row in rows:
        lines.append(
            "| "
            + " | ".join(md_escape(str(row[h])) for h in headers)
            + " |"
        )

    OUTPUT_TABLE.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_bidirectional_graph(rows: list[dict[str, str]]) -> None:
    nodes = {
        row["Node_ID"]: {
            "node_type": row["Node_Type"],
            "source_field": row["Source_Field"],
            "field_value": row["Field_Value"],
            "control_tag": row["Control_Tag"],
        }
        for row in rows
    }

    outgoing: dict[str, list[dict[str, str]]] = {node_id: [] for node_id in nodes}
    incoming: dict[str, list[dict[str, str]]] = {node_id: [] for node_id in nodes}

    for row in rows:
        src = row["Node_ID"]
        dst = row["Linked_To"]
        rel = row["Relationship_Type"]
        if dst == "-":
            continue
        edge = {"to": dst, "relationship_type": rel}
        outgoing[src].append(edge)
        incoming[dst].append({"from": src, "relationship_type": rel})

    OUTPUT_GRAPH.write_text(
        json.dumps(
            {
                "nodes": nodes,
                "adjacency": {"outgoing": outgoing, "incoming": incoming},
            },
            indent=2,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
    )


def write_gap_query_output(raw_rows: list[dict[str, str]]) -> None:
    gap_rows = [
        row
        for row in raw_rows
        if row.get("Gap_Flag", "") != "NO"
        or row.get("Coverage_Assessment", "") not in {"FULL", "DECLARED_LIMITATION"}
    ]

    OUTPUT_GAPS.write_text(
        json.dumps(
            {
                "query": "Gap_Flag != 'NO' OR Coverage_Assessment NOT IN ['FULL', 'DECLARED_LIMITATION']",
                "count": len(gap_rows),
                "rows": gap_rows,
            },
            indent=2,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
    )


def main() -> None:
    rows, raw_rows = build_rows()
    write_markdown_table(rows)
    write_bidirectional_graph(rows)
    write_gap_query_output(raw_rows)


if __name__ == "__main__":
    main()
