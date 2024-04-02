# alice(172.28.0.3) <-> (172.28.0.2)moon(172.30.0.2) -> (172.30.0.1)internet-gateway(172.30.0.1) <- (172.30.0.4)sun(172.29.0.4) <-> (172.29.0.5)bob

alice-hop:
	${EXEC} alice traceroute example.com
# traceroute to example.com (<ip-addr>), 30 hops max, 60 byte packets
#  1  moon.stackoverflow_moon-internal (172.28.0.2)  5.344 ms  3.365 ms  3.317 ms
#  2  172.30.0.1 (172.30.0.1)  0.763 ms  0.063 ms  0.044 ms

moon-exit:
	${EXEC} moon traceroute example.com
# traceroute to example.com (<ip-addr>), 30 hops max, 60 byte packets
#  1  172.30.0.1 (172.30.0.1)  0.046 ms  0.017 ms  0.004 ms

sun-exit:
	${EXEC} sun traceroute example.com
# traceroute to example.com (<ip-addr>), 30 hops max, 60 byte packets
#  1  172.30.0.1 (172.30.0.1)  0.715 ms  0.011 ms  0.018 ms

bob-hop:
	${EXEC} bob traceroute example.com
# traceroute to example.com (<ip-addr>), 30 hops max, 60 byte packets
#  1  sun.stackoverflow_sun-internal (172.29.0.4)  1.045 ms  0.032 ms  0.008 ms
#  2  172.30.0.1 (172.30.0.1)  0.086 ms  0.010 ms  0.038 ms

trace: bob-hop sun-exit moon-exit alice-hop

# Docker and compose

COMPOSE=docker compose
EXEC=docker exec

up:
	${COMPOSE} up -d
down:
	${COMPOSE} down
start:
	${COMPOSE} start
stop:
	${COMPOSE} stop
restart:
	${COMPOSE} restart
recreate:
	${COMPOSE} up -d --force-recreate
ps:
	${COMPOSE} ps
logs:
	${COMPOSE} logs -f
build:	
	${COMPOSE} build
build-no-cache:
	${COMPOSE} build --no-cache
