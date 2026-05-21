# GOSH docker images

## Updating stable image tags

The `docker/*-stable.dockerfile` files are generated from the current image
digests by `update_stable.py`.

To refresh all stable images:

```sh
python3 update_stable.py
```

The script pulls each image listed in `DOCKER_FILES_TO_IMAGES` at the top of
`update_stable.py`, reads the current `amd64` and `arm64` digests, and rewrites
the matching stable Dockerfiles.

To update only one specific `:stable` image separately, edit
`DOCKER_FILES_TO_IMAGES` at the top of `update_stable.py` and temporarily
comment out every image except the one that should be bumped. Then run:

```sh
python3 update_stable.py
```

For example, to bump only `docker.gosh.sh/rust:stable`, leave only the
`docker/rust-stable.dockerfile` entry uncommented:

```python
DOCKER_FILES_TO_IMAGES: list[tuple[str, str]] = [
    ("docker/rust-stable.dockerfile", "docker.gosh.sh/rust"),
    # ("docker/debian-stable.dockerfile", "docker.gosh.sh/debian"),
    # ("docker/debian-stable-slim.dockerfile", "docker.gosh.sh/debian:slim"),
    # ("docker/plugin-docker-buildx-cond-stable.dockerfile", "docker.gosh.sh/plugin-docker-buildx-cond"),
]
```

After the script rewrites that Dockerfile, restore the full
`DOCKER_FILES_TO_IMAGES` list before committing unless the reduced list is
intentional.

Review the generated Dockerfile diff before committing. Pushing changes to
`main` or `stable` triggers `.woodpecker/docker-stable.yaml`, which rebuilds and
publishes the configured stable tags.

Automation agents should also follow [AGENTS.md](AGENTS.md).
