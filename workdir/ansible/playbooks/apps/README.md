# Ansible playbook to deploy an environment to NGINX controller 3.x

The playbook looks for a configuration yaml file in your home folder `~/ansible/vars/apps.yaml`
The apps.yaml file should define an environment folder `envs_dir`, and an environment name `env`.
If you make use of OAS3 API specs, then it should also define a `specs_dir` folder in which you store specs in YAML format
If you make use of local JWKS files, then you will need to define `jwks_dir`, and store you JWKS file in JSON format.

An example apps.yaml might look something like this:
```
---
  specs_dir: ~/ansible/specs
  jwks_dir: ~/ansible/jwks
  envs_dir: ~/ansible/envs
  certs_dir: ~/ansible/certs

  env: cheese_api_prod

  controller:
    api_version: "v1"
    hostname: controller.your.org
    admin_email: admin@your.org
    admin_password: you.ORG.pa55w0rD
...
```

## Exmaple configuration

There is a full example in the example folder. Simply copy `example/ansible` to `~/ansible` and you are good to go.

