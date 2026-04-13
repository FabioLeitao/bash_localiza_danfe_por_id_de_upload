# localiza_danfe_por_id_de_upload

Bash script to search backup trees for DANFE PDFs by upload id: reads a list of ids from a text file, checks each year folder, validates PDFs, greps for `DANFE` in extracted text, and copies matches into an evidence folder for SFTP transfer.

**Context:** document automation for logistics-style check-in workflows (generic; paths and service user are environment-specific).

## Requirements

- Bash 5+, `find`, `grep`, `file`, `pdftotext` (poppler)
- Read access to your check-in backup root (see below)
- Optional: `tmux` for long runs so the session survives disconnects

## Clone

```bash
git clone https://github.com/FabioLeitao/bash_localiza_danfe_por_id_de_upload.git
cd bash_localiza_danfe_por_id_de_upload
```

## Configuration

Set the backup root that contains **per-year** directories (e.g. `2025/`, `2024/`):

```bash
export DANFE_BKP_ROOT="/path/to/your/checkin/backup/root"
```

Optional: UID check (default `1000`):

```bash
export DANFE_SERVICE_UID=1000
```

Create a search list (one id per line). Example file is `busca.example.txt`; copy it to `busca.txt` (ignored by git) or use your own path.

## Run

```bash
bash ./localiza_danfe_por_id_de_upload.sh 2025 ./busca.txt
```

Use a year that matches a subdirectory under `DANFE_BKP_ROOT`.

### tmux (recommended for large lists)

```bash
tmux new-session -A -s localiza_danfe
bash ./localiza_danfe_por_id_de_upload.sh 2025 ./busca.txt
# Detach: Ctrl+B then D
tmux attach -t localiza_danfe
```

Logs: `~/log/busca_danfe_por_id_de_upload.log` (example: `lnav ~/log/busca_danfe_por_id_de_upload.log`).

## License

See [LICENSE](LICENSE).
