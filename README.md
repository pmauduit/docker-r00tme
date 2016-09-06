# docker-r00tme

title says it all ...

# howto

2 volumes are needed (at least one, actually, depending if your docker host environment is up to date or if you need to use the host's docker version):

```
/var/run/docker.sock:/var/run/docker.sock
/usr/bin:/root/host-usrbin
```

Since docker is written in go, you will end up with a huge statically-linked binary which should be launched in docker containers with no harm. YMMV. YOLO.

