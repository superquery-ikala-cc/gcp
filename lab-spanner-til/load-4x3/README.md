# tmux 1

```bash
bash load-4x3.sh > load-4x3.log 2>&1
```

# tmux 2

```bash
tail -f load-4x3.log | bash emit.sh
```
