# how to use

```
services:
  backend:
    command:
    - product=manhattan
    - 4000
    - 5000:4000
    image: robsonpeixoto/kubectl-port-forward:1.7.6
    volumes:
      - $HOME/.kube:/root/.kube
    ports:
      - "4000:4000"
      - "5000:5000"
```

# TODO

[] Validate all inputs
[] Better documentation
