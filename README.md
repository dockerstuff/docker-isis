# USGS ISIS3 Dockerfile

USGS Integrated Software for Imagers and Spectrometers v3 (ISIS3) Docker container.

ISIS3 documentation/resources:
- https://isis.astrogeology.usgs.gov/
- https://github.com/USGS-Astrogeology/ISIS3
- https://astrodiscuss.usgs.gov/

## Run it

* Bind ISIS3 ancillary data
```
% docker run -it --name isis3 \
    -v /path/to/data/isis3data:/isis/data
    -v /path/to/data/data:/mnt/data
    chbrandt/isis3
```

* If you want to customize (e.g, for testing) ISIS3 variables:
```
% docker run -it --name isis3 \
    -v $PWD/dockerfile/etc/isis.sh:/etc/profile.d/isis.sh
    chbrandt/isis3
```
