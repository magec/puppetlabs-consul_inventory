# consul_inventory

#### Table of Contents

1. [Description](#description)
2. [Requirements](#requirements)
3. [Usage](#usage)

## Description

This module includes a Bolt plugin to generate Bolt targets from a consul servers.

## Requirements

This module have two requirements [`diplomat`](https://rubygems.org/gems/diplomat) and [`net-ssh-gateway`](https://rubygems.org/gems/net-ssh-gateway). You need to install them
manually using bolt's gem command.

```
/opt/puppetlabs/bolt/bin/gem install diplomat net-ssh-gateway
```

## Usage

The Consul plugin support these config attributes.

- `host`: Consul host
- `port`: Consul port
- `bastion_host`: If consul is behind a firewall (odds are that this would be the case), you can specify a bastion host to connect to, before connecting to consul (proxyjump).
- `bastion_user`: User to use to connect to bastion host.
- `bastion_ssh_options`: Ssh options to use for connecting to bastion host.

### Examples

`inventory.yaml`
```yaml
groups:
  - name: nodes
    targets:
      - _plugin: consul_inventory
        host: localhost
        port: 8500
        bastion_host: gateway.example.com
        bastion_user: user
    config:
      ssh:
        user: user
        proxyjump: user@gateway.example.com
        host-key-check: false
```
