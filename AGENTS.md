# Repository Instructions

DO NOT force push unless specifically told to.
DO NOT push unless specifically told to.

## Updating stable image tags

Use `python3 update_stable.py` from the repository root to update stable Docker
image digests.

The script updates every image listed in `DOCKER_FILES_TO_IMAGES` at the top of
`update_stable.py`.

If only one specific `:stable` image needs to be bumped separately, edit
`DOCKER_FILES_TO_IMAGES` at the top of `update_stable.py` and temporarily
comment out every image except the one that should be bumped. Then run
`python3 update_stable.py`. For example, to bump only
`docker.gosh.sh/rust:stable`, leave only the `docker/rust-stable.dockerfile`
entry uncommented:

```python
DOCKER_FILES_TO_IMAGES: list[tuple[str, str]] = [
    ("docker/rust-stable.dockerfile", "docker.gosh.sh/rust"),
    # ("docker/debian-stable.dockerfile", "docker.gosh.sh/debian"),
    # ("docker/debian-stable-slim.dockerfile", "docker.gosh.sh/debian:slim"),
    # ("docker/plugin-docker-buildx-cond-stable.dockerfile", "docker.gosh.sh/plugin-docker-buildx-cond"),
]
```

Restore the full list before committing unless the reduced list is intentional.

After running the script, review the generated Dockerfile changes before
committing. Pushing changes to `main` or `stable` triggers
`.woodpecker/docker-stable.yaml`, which rebuilds and publishes the configured
stable tags.
