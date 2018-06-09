# Docker Run -d

This is a very simple container that will run a container that you specify. This may seem completely ridiculous, but it *does* have a very specific use case: running a privileged container as a Swarm service. Docker Swarm does not allow running privileged containers as services. This container is a workaround. Create a swarm service that runs this container and mounts the Docker socket into it ( something that *is* allowed on swarm ), and pass in whatever parameters you want ( including the possibility of the `--privilged` flag ) to a `docker run -d` command that will be run as a standalone container on the host.

When this container receives a SIGTERM or SIGINT signal it will `docker stop` and `docker rm` the container that you tell it to run. This makes it behave as much like a Swarm service as possible. Don't forget that the container that you run *is* a **standalone container**. If you want the container to run on the same network as your swarm stack you must specify that in the run command. For example: `--net stackname_networkname`. Another thing to be aware of is that killing the `docker-run-d` container without allowing it to gracefully shutdown, such as when you run `docker kill`, will cause the container that the `docker-run-d` container starts to be left running. One way to make this more controllable is to set the `CONTAINER_NAME` environment variable ( see below ).

There are many possible scenarios for other potentially unexpected behaviors when using this container. This is not a perfect workaround for the Swarm privileges issues and will likely not work for many different use cases. You should be aware of possible problems that may depend on the particular docker run command that you pass to this container.

## Environment Variables

### CONTAINER_NAME

Setting the `CONTAINER_NAME` environment variable allows the `docker-run-d` container to keep track of the container that it is supposed to be running and allows it to gracefully recover from being unexpectedly terminated by a `docker kill` or by an unexpected system shutdown. When the `CONTAINER_NAME` is set it will add a `--name` flag to the docker run command; you should **not** add one to the command manually. In addition to setting the `--name` of the container the `docker-run-d` container will stop, remove, and re-create the container of the given name if a container with that name is found at startup. In other words it will force updating the container run command to make sure that it is up-to-date. You can override this behavior by setting the `FORCE_UPDATE` environment variable.

**Default:** null string

### FORCE_UPDATE

When `FORCE_UPDATE` is `true` the `docker-run-d` container will remove and re-create the container with the given `CONTAINER_NAME` when it starts up. This setting only applies when `CONTAINER_NAME` is set. Setting `FORCE_UPDATE` to anything other than `true` will prevent a container of the given name from being removed and updated when the `docker-run-d` container starts.

**Default:** `true`
