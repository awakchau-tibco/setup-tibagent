# setup-tibagent

Simple script to configure and start tibagent. You can learn more about tibagent from the official docs here: <https://integration.cloud.tibco.com/docs/index.html#tci/using/hybrid-agent/hybrid-proxy/using-tunneling.html>

The script will autogenerate an agent name and random port for tibagent so you can run multiple agents using this script.

## How to use

All arguments are optional except the spec to start the agent.

First download the script from [here](https://raw.githubusercontent.com/awakchau-tibco/setup-tibagent/master/setup-tibagent.sh "Download setup-tibagent.sh") and make it executable by running

```bash
chmod +x setup-tibagent.sh
```

You can provide your `access key` and `secret` using following command:

```bash
./setup-tibagent.sh --spec 5432:10.99.123.123:5432 -a my-key -s 5LxkEL7I5c7oRu1b/fPxzdRwA6j+Judlbp0ymV3j2Xc
```

If you want to use the `system access key`, use the command:

```bash
./setup-tibagent.sh --spec 5432:10.99.123.123:5432 -a system
```

To use the secret key that you copied onto your clipboard, you can just run the following command (here I assumed you named your access key as `key` if not you can specify it using `-a` flag):

```bash
$ ./setup-tibagent.sh --spec 5432:10.99.123.123:5432      

Step 0/4: Making tibagent binary executable...

Step 1/4: Logging out and logging in with username [awakchau@tibco.com]...
User logged out successfully. 

     Your account has access to multiple organizations. Which one do you want to sign in to?
 
     1. 30NOV2022 us-west-2
     2. Wakanda us-west-2

Enter your selection: 2
You've successfully logged into organization: " Wakanda us-west-2 "

Step 2/4: Generating a random port for tibagent [agent_2023_02_16_T_19_22_22] and configuring...
Generated new random port for tibagent [agent_2023_02_16_T_19_22_22]: 7816
Configuring agent [DONE]                 
Agent 'agent_2023_02_16_T_19_22_22' was configured

Step 3/4: Configuring connect for tibagent [agent_2023_02_16_T_19_22_22] with access key [key] and secret key [5432]...
Configuring connect [DONE]                 
Connect 'agent_2023_02_16_T_19_22_22' was configured

Step 4/4: Starting tibagent [agent_2023_02_16_T_19_22_22] with spec [5434:127.0.0.1:5434]...
Feb 16 19:22:45 10.98.170.162 [a:tibagent:a][1000]: {"timestamp":1676555565,"time":"2023-02-16T19:22:45.851Z","level":"INFO","app":"tibagent","message":"Connecting to access key 'key' on specs: [5434:127.0.0.1:5434]"}
Feb 16 19:22:45 10.98.170.162 [a:tibagent:a][1914615]: {"timestamp":1676555565,"time":"2023-02-16T19:22:45.852Z","level":"INFO","app":"tibagent","message":"Server port: 7816"}
Feb 16 19:22:46 10.98.170.162 [a:tibagent:a][1000]: {"timestamp":1676555566,"time":"2023-02-16T19:22:46.853Z","level":"INFO","app":"tibagent","message":"Agent version=1.7.0 build=1360 tibtunnel version=2.44.0"}
Feb 16 19:22:46 10.98.170.162 [a:tibagent:a][1000]: {"timestamp":1676555566,"time":"2023-02-16T19:22:46.853Z","level":"DEBUG","app":"tibagent","message":"Agent started with data-ack-mode=true"}
Feb 16 19:22:46 10.98.170.162 [a:tibagent:a][1000]: {"timestamp":1676555566,"time":"2023-02-16T19:22:46.853Z","level":"DEBUG","app":"tibagent","message":"Agent started with data-chunk-size=32KB"}
Feb 16 19:22:46 10.98.170.162 [a:tibagent:a][1000]: {"timestamp":1676555566,"time":"2023-02-16T19:22:46.854Z","level":"INFO","app":"tibagent","message":"Agent 'agent_2023_02_16_T_19_22_22' started on port '7816' successfully."}
```

## Command Line Flags

| Flag (Short) | Flag (long) | Required | Description |
|--|--|--|--|
| -a | --access-key | No | default is 'key', pass 'system' if you want to use system access key |
| -s | --secret-key | No | by default secret key is taken from clipboard |
| -p | --spec | Yes | spec for the tibagent |
