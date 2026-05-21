# Repository Instructions

DO NOT force push unless specifically told to.
DO NOT push unless specifically told to.

## Updating stable image tags

Use `./update_stable.py` from the repository root to update stable Docker image
digests. If the executable bit is not available, use `python3 update_stable.py`.

The script updates every image listed in `DOCKER_FILES_TO_IMAGES` at the top of
`update_stable.py`.

If only one specific image needs to be bumped, temporarily comment out the other
entries in that Python list before running the script. Restore the list before
committing unless the reduced list is intentional.

After running the script, review the generated Dockerfile changes before
committing. Pushing changes to `main` or `stable` triggers
`.woodpecker/docker-stable.yaml`, which rebuilds and publishes the configured
stable tags.
