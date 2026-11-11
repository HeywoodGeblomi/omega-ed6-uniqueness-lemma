# How to run

From the repository root, one command installs the Python dependencies and runs the short checks:

```bash
bash scripts/smoke.sh
```

`requirements.txt` is installed into `.smoke-deps/` (gitignored). The checks import that install.

## Short checks

The command runs only:

1. `samplers/periodic/run_example.py`
2. `samplers/generic/skeleton.py`
3. `scripts/check_raw_lyapunov_correspondence.py` (Lean lists against `data/kz_along_A.json`; does not write `data/`)

`skeleton.py` is left as the placeholder already in the repository. The command does not write under `data/`. After those two runners it checks that every file under `data/` is unchanged, and that each `promote_ready` field already stored in `data/*.json` is still false.

## Optional runners

These are not part of `bash scripts/smoke.sh`. Each writes under `data/`:

- `python3 samplers/generic/multi_twist_walk.py` writes `data/generic_multi_twist_walk.json`
- `python3 samplers/generic/continuous_monodromy.py` writes `data/continuous_monodromy_ensemble.json`

Run those only when overwriting files under `data/` is intended.

Long flatsurf jobs and long X(2,0) campaigns are not started by `bash scripts/smoke.sh`. This repository does not contain `code/breakthrough_h1plus.py` or `prym-d6-g4`.
