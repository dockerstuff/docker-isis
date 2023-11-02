## GISPy

Besides the packages already provided by this container's base image,
we added a few more we fill useful for most of GIS work in Python:

$(conda env export --no-builds | grep --file /tmp/gispy.txt --word-regexp)
