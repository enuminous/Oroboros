# Full-catalogue verification

The `catalogue` job in [.github/workflows/lean.yml](.github/workflows/lean.yml)
builds the root `RequestProject` library with the committed Lean 4.28.0 toolchain
and dependency manifest. This includes all 28 theorem declarations in
[RequestProject/Oroboros.lean](RequestProject/Oroboros.lean).

From the repository root:

```sh
lake exe cache get
lake build
python3 scripts/verify_catalogue.py
lake env lean -DwarningAsError=true Audit.lean
python3 scripts/test_axiom_audit.py
```

The catalogue correspondence check compares all 28 names in `UNIVERSE.md` with
the theorem declarations in the built source. `Audit.lean` checks every safe
declaration belonging to the project modules, including private helper lemmas.
Only `propext`, `Classical.choice`, and `Quot.sound` are allowed. Four negative
controls ensure that public axioms, private axioms, `sorry`, and native proof
evaluation are rejected for the intended reason.

The existing `verify` job separately builds and audits the earlier `formal/`
package and runs numerical regression checks. Its namespace overlaps with the
root package, so the packages are deliberately verified separately.

The Actions run and job summaries identify the exact checked commit. A passing
run establishes the encoded mathematical statements under their hypotheses.
It does not establish physical applicability, topology beyond the stated
orientation theorem, fractality, or metaphysical interpretations.
