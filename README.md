# Workaround for docker container network gateway restrictions

Based on [this stackoverflow](https://stackoverflow.com/questions/52595272/use-docker-container-as-network-gateway) comment by [dshepherd](https://stackoverflow.com/users/874671/dshepherd).

## Requirements

- Windows 10 + WSL2 + Rancher Desktop 1.9.1 + Git Bash
  or
- Ubuntu 22.04
  and
- Docker CE (for containers)
- docker compose plugin (for orchestration)
- make (command shortcuts)

## Action

Build and start: [`make build up`](./Makefile)
Traceroute: [`make trace`](./Makefile)
Down: [`make down`](./Makefile)

## Case

Creating a multi-hop networking flow between Docker containers, such as routing traffic from alice to moon, then moon to sun, and ultimately from sun to bob, isn't straightforward with Docker's default bridge network or its other networking modes. This is primarily because Docker's bridge networks are designed to use the host machine as the default gateway.

The setup in this repository involves creating a virtual interface on the host linked to the bridge network, where the gateway setting simply assigns an IP address to this virtual interface, not facilitating intricate container-to-container routing paths.

![](assets/20240403_010239_docker-gateway-workaround-with-compose.png)

This aspect of Docker networking, including its constraints and the foundational principles behind it, isn't extensively documented or officially detailed, often being regarded as Docker's internal functionality. Insights into overcoming these limitations typically emerge from community discussions and practical solutions shared across various technical forums.

- [Changing the default docker gateway to a container](https://forums.docker.com/t/setting-default-gateway-to-a-container/17420/2)
- [Set the default gateway of a container to a non host machine in lan](https://forums.docker.com/t/new-user-set-default-gateway-of-container-to-other-machine-in-lan/35066)

To realize the complex routing scheme among containers (alice to moon, followed by moon to sun, and sun to bob), a tailored configuration in the docker-compose.yml is necessary. This involves separate private networks, each configured with its own gateway. The essence of this setup is encapsulated in the command section for each container in the [docker-compose.yml](./docker-compose.yml).

```
    command: >-
      sh -c "ip route del default &&
      ip route add default via <container-ip-to-hop-through>
```

Precise ip and iptables commands are issued for each service to set up the required network routes and translation protocols. The use of `tail -f /dev/null` in the command section serves as a mechanism to keep the containers operational by executing a command that never completes (bash would also work), thus ensuring the containers stay up until they are intentionally terminated.

**Note:** you can start a container shell via `docker exec -it <container_name> bash`
