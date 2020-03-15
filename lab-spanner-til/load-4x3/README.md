# tmux 1

```bash
cat /dev/null > load-4x3.log
tail -f load-4x3.log | bash emit.sh
```

# tmux 2

```bash
bash load-4x3.sh generate 
bash load-4x3.sh create
bash load-4x3.sh load > load-4x3.log 2>&1
```
