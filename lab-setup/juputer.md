
```bash
jupyter notebook notebooks/ --ip $(hostname -I | cut -d" " -f 1)  --no-browser
```