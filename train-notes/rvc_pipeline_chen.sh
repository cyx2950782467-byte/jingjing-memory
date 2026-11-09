#!/bin/bash
# 陈的音色 RVC 训练流水线（40k / RMVPE / bs8 / 200 epoch）
# 与 xiaoyi 版差异：全部用 python -m 调用，避开 train 包的循环导入
set -uo pipefail
export PYTHONPATH=/root/autodl-tmp/rvc
export PATH=/root/miniconda3/envs/rvc/bin:$PATH
PY=/root/miniconda3/envs/rvc/bin/python
cd /root/autodl-tmp/rvc || exit 1
EXP=chenvoice
EDIR=/root/autodl-tmp/rvc/logs/$EXP
DATA=/root/autodl-tmp/chenvoice
mkdir -p "$EDIR" assets/weights assets/indices
touch train/__init__.py
step() { echo "=== [$(date +%H:%M:%S)] $*"; }

step preprocess_start
$PY -m train.preprocess "$DATA" 40000 8 "$EDIR" False 3.7 > /root/autodl-tmp/log_preprocess.txt 2>&1
echo "preprocess rc=$?"
ls "$EDIR"

step f0_rmvpe
$PY -m train.dataset.extract_f0 cuda 1 0 0 "$EDIR" true > /root/autodl-tmp/log_f0.txt 2>&1
echo "f0 rc=$?"

step hubert
$PY -m train.dataset.extract_hubert_feature cuda:0 1 0 0 "$EDIR" v2 true > /root/autodl-tmp/log_hubert.txt 2>&1
echo "hubert rc=$?"

step config
$PY - "$EDIR" > /root/autodl-tmp/log_config.txt 2>&1 <<'PYEOF'
import json, os, sys
edir = sys.argv[1]
cfg = json.load(open('/root/autodl-tmp/rvc/configs/v1/40k.json'))
cfg['train']['epochs'] = 200
cfg['train']['batch_size'] = 8
json.dump(cfg, open(os.path.join(edir, 'config.json'), 'w'), ensure_ascii=False, indent=4, sort_keys=True)
print('config written to', edir)
PYEOF
echo "config rc=$?"; cat /root/autodl-tmp/log_config.txt

step filelist
$PY - "$EDIR" > /root/autodl-tmp/log_filelist.txt 2>&1 <<'PYEOF'
import os, sys
edir = sys.argv[1]
feat = [d for d in os.listdir(edir) if d.startswith('3_feature')][0]
gt = os.path.join(edir, '0_gt_wavs'); fd = os.path.join(edir, feat)
f0 = os.path.join(edir, '2a_f0'); fnsf = os.path.join(edir, '2b-f0nsf')
base = lambda d: set(n.split('.')[0] for n in os.listdir(d))
names = sorted(base(gt) & base(fd) & base(f0) & base(fnsf))
lines = ["%s/%s.wav|%s/%s.npy|%s/%s.wav.npy|%s/%s.wav.npy|0" % (gt, n, fd, n, f0, n, fnsf, n) for n in names]
open(os.path.join(edir, 'filelist.txt'), 'w').write("\n".join(lines))
print('feature dir:', feat, 'filelist lines:', len(lines))
PYEOF
echo "filelist rc=$?"; cat /root/autodl-tmp/log_filelist.txt

step train_start
date +%s > /root/autodl-tmp/train_start_ts
$PY -m train.train -e $EXP -sr 40k -f0 1 -bs 8 -g 0 -te 200 -se 20 \
  -pg assets/pretrained_v2/f0G40k.pth -pd assets/pretrained_v2/f0D40k.pth \
  -l 1 -c 0 -sw 1 -v v2 > /root/autodl-tmp/log_train.txt 2>&1
echo "train rc=$?"
date +%s > /root/autodl-tmp/train_end_ts
step done
