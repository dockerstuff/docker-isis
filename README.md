# USGS ISIS3 Dockerfile

USGS Integrated Software for Imagers and Spectrometers v3 (ISIS3) Docker container.

ISIS3 documentation/resources:
- https://isis.astrogeology.usgs.gov/
- https://github.com/USGS-Astrogeology/ISIS3
- https://astrodiscuss.usgs.gov/

## Run it

* The simplest run:
```
% docker run -it chbrandt/isis3
```

* Mount a share point:
```
% docker run -it --name isis3 \
    -v /tmp/isis3:/mnt/host \
    chbrandt/isis3
```

* Bind ISIS3 ancillary data
```
% docker run -it --name isis3 \
    -v $PWD/data/isis3data:/isis/data
    -v $PWD/data/data:/mnt/data
    chbrandt/isis3
```

* If you want to customize (e.g, for testing) ISIS3 variables:
```
% docker run -it --name isis3 \
    -v $PWD/dockerfile/etc/isis.sh:/etc/profile.d/isis.sh
    chbrandt/isis3
```
