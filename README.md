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
    -v $PWD/tmp:/mnt/host \
    chbrandt/isis3
```
