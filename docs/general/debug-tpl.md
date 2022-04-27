# Debug template

If you want to do some debug you can modify the [debug-file](../../cluster/templates/debug-tpl.yml) to try some of your functions. To generate the debug file, the command below should work like a charm :

```sh
helm template <repository-git-dir>/cluster --set debug=true
```
