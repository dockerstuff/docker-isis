# Docker recipes

Here we define the container images:

- [gispy](gispy.dockerfile)
- [isis](isis.dockerfile)
- [isis-asp](isisasp.dockerfile)

Each Dockerfile is accompanied by a `.txt` or `.yml` file, those are
(pip) "requirements" and (conda) "environment" files, they are used
to keep the list of Python packages to be installed separated from the
Docker recipe.

If you want to build images with different (Python) packages, or
different version, for example, you just have to change the `txt/yml`
files.

You'll notice that `isis` and `stereo-pipeline` have no version defined in
`isis.yml` and `isisasp.yml` environment files, this is because their
versions will be taken from the [`.env`](/.env).
*There* is where you should change/fix the versions of ISIS and ASP you
want to use.
