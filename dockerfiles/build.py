#!/usr/bin/env python
"""
Builds ISIS/ASP/Jupyter Docker containers.
"""

# Information about versions of ISIS/ASP can be found in the following links:
# - https://ti.arc.nasa.gov/tech/asr/groups/intelligent-robotics/ngt/stereo
# -- asp home page
# - https://github.com/NeoGeographyToolkit/StereoPipeline/releases/download/3.0.0/asp_book.pdf
# -- asp install instructions (page ~9)
# - https://anaconda.org/usgs-astrogeology/isis/files
# -- list of isis versions in conda/usgs-astrogeology repository
# - https://anaconda.org/nasa-ames-stereo-pipeline/stereo-pipeline/files
# -- list of asp versions in conda/usgs-astrogeology repository

_ISIS_ASP = {
    # '6': dict(isis='6.0.0', asp='3.0.0'),
    '5': dict(isis='5.0.1', asp='3.0.0'),
    '4': dict(isis='4.4.0', asp='2.7.0'),
    '3': dict(isis='3.6.0', asp='2.6.2')
}
_ISIS_VERSIONS = tuple(_ISIS_ASP.keys())
_ISIS_VERSION = max(_ISIS_VERSIONS)


def map_versions(args: dict) -> dict:
    """Coerce ISIS/ASP versions specified by the command-line (3,4,5)"""
    assert 'isis' in args
    if args.add_asp:
        # If yes install-asp, use one of the pre-compiled versions
        return _ISIS_ASP[args.isis]
    else:
        # If not install-asp, just return the big number (3,4,5) given (the install should handle)
        return {'isis': args.isis, 'asp': None}


def build(args: dict) -> bool:
    """Build Docker images"""
    assert all( attr in args for attr in ['set_jupyter', 'name', 'add_asp'] )

    context = '.'
    dockerfile = 'dockerfile'
    image_out = args.name or "my_isis:latest"
    base_image = "jupyter:gdal" if args.set_jupyter else "ubuntu:gdal"

    build_args = [
        ('-t', image_out),
        ('-f', dockerfile),
        ('--build-arg', f'BASE_IMAGE={base_image}'),
    ]

    versions = map_versions(args)
    isis_v = versions['isis']
    asp_v = versions['asp']

    build_args.append(('--build-arg', f'ISIS_VERSION={isis_v}'))
    if versions['asp']:
        build_args.append(('--build-arg', f'ASP_VERSION={asp_v}'))

    # docker build -t isis:jupyter \
    #   --build-arg BASE_IMAGE=jupyter:gdal \
    #   --build-arg ISIS_VERSION='5.0.1' \
    #   --build-arg ASP_VERSION='3.0.0' \
    #   -f dockerfile .
    _join = lambda L: " ".join(L)

    build_args = _join([ f"{k} {v}" for k,v in build_args ])
    build_cmd = _join([ "docker build", build_args, context ])

    print(build_cmd)


def parse_args(args: list) -> dict:
    """Return dict with values command-line arguments parsed"""
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("-n","--name", type=str,
                        default="isis:latest",
                        help="Output image name")

    parser.add_argument("--isis", type=str, choices=_ISIS_VERSIONS, default=_ISIS_VERSION,
                        help=f"ISIS version to install. Default is {_ISIS_VERSION}")

    parser.add_argument("--set-jupyter", dest="set_jupyter",
                        action="store_true",
                        default=False,
                        help="Set Jupyter as default user interface (http://)")

    parser.add_argument("--add-asp", dest="add_asp",
                        action="store_true",
                        default=False,
                        help="Add ASP package according to ISIS/ASP versions available:\n{}".
                                format(" -- ".join(f'{k}:{v}' for k,v in _ISIS_ASP.items()))
                        )

    parsed_args = parser.parse_args(args)
    return parsed_args


if __name__ == '__main__':
    import sys
    args = parse_args(sys.argv[1:])
    status = build(args)
