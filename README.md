# how to use

```
services:
  backend:
    command:
      - "label=value,label2=value2"
      - "4000"
      - "5000:4000"
    image: robsonpeixoto/kubectl-port-forward:1.7.6
    volumes:
      - $HOME/.kube:/root/.kube
    ports:
      - "4000:4000"
      - "5000:5000"
```

Some Kubernetes auth providers store a `cmd-path` property in the `~/.kube/config`. Make sure this path is available inside the container, either by creating the appropriate volumes or editing the config.

# TODO

- Validate all inputs
- Better documentation
- Add automatic build solution
- Add multiple kubectl version support
