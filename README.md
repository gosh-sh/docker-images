# GOSH docker images

## Updating stable image tags

The `docker/*-stable.dockerfile` files are generated from the current image
digests by `update_stable.py`.

To refresh all stable images:

```sh
./update_stable.py
```

If the executable bit is not available in your checkout, run:

```sh
python3 update_stable.py
```

The script pulls each image listed in `DOCKER_FILES_TO_IMAGES` at the top of
`update_stable.py`, reads the current `amd64` and `arm64` digests, and rewrites
the matching stable Dockerfiles.

To update only one specific image, temporarily comment out the other entries in
the `DOCKER_FILES_TO_IMAGES` list at the top of `update_stable.py`, then run the
script. Restore the list before committing unless the reduced list is intentional.

Review the generated Dockerfile diff before committing. Pushing changes to
`main` or `stable` triggers `.woodpecker/docker-stable.yaml`, which rebuilds and
publishes the configured stable tags.

Automation agents should also follow [AGENTS.md](AGENTS.md).
