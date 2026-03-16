#!/bin/bash
# Batch convert all CMU/35 CSV files to NPZ for BeyondMimic deployment
# Run this from the booster_train directory with env_isaaclab conda env active
#
# Usage:
#   cd /home/gan/NOMADZ/booster_train
#   conda activate env_isaaclab
#   bash scripts/batch_csv_to_npz.sh

CSV_DIR="/home/gan/NOMADZ/GMR/CMU_retargeted_k1/35/csv"
OUT_DIR="/home/gan/NOMADZ/booster_assets/motions/K1"
DEPLOY_DIR="/home/gan/NOMADZ/booster_deploy/tasks/beyond_mimic/motions"

for csv_file in "$CSV_DIR"/*.csv; do
    basename=$(basename "$csv_file" .csv)
    npz_name="cmu_${basename}.npz"
    out_path="$OUT_DIR/$npz_name"

    if [ -f "$out_path" ]; then
        echo "Skipping $npz_name (already exists)"
    else
        echo "Converting $basename..."
        python scripts/csv_to_npz.py --headless \
            --input_file="$csv_file" \
            --input_fps=30 \
            --output_name="$out_path"
    fi

    # Also copy to deploy motions folder
    if [ -f "$out_path" ]; then
        cp "$out_path" "$DEPLOY_DIR/$npz_name"
    fi
done

echo "Done! All NPZ files are in $OUT_DIR and $DEPLOY_DIR"
