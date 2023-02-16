# setup-tibagent

Simple script to configure and start tibagent. You can learn more about tibagent from the official docs here: <https://integration.cloud.tibco.com/docs/index.html#tci/using/hybrid-agent/hybrid-proxy/using-tunneling.html>

The script will autogenerate an agent name and random port for tibagent so you can run multiple agents using this script.

## How to use

All arguments are optional except the spec to start the agent.

First download the script from [here](https://raw.githubusercontent.com/awakchau-tibco/setup-tibagent/master/setup-tibagent.sh "Download setup-tibagent.sh") and make it executable by running

```bash
chmod +x setup-tibagent.sh
```

```bash
./setup-tibagent.sh --spec 5435:10.99.123.123:5432
```

## Other flags

| Flag (Short) | Flag (long) | Required | Description |
|--|--|--|--|
| -a | --access-key | No | default is 'key', pass 'system' if you want to use system access key |
| -s | --secret-key | No | by default secret key is taken from clipboard |
| -p | --spec | Yes | spec for the tibagent |
