# Documentation:
# - https://oauthenticator.readthedocs.io/en/latest/getting-started.html#gitlab-setup

import os

c = get_config()

# We rely on environment variables to configure JupyterHub so that we
# avoid having to rebuild the JupyterHub container every time we change a
# configuration parameter.

# Spawn single-user servers as Docker containers
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
# Spawn containers from this image
c.DockerSpawner.container_image = os.environ['DOCKER_NOTEBOOK_IMAGE']
# JupyterHub requires a single-user instance of the Notebook server, so we
# default to using the `start-singleuser.sh` script included in the
# jupyter/docker-stacks *-notebook images as the Docker run command when
# spawning containers.  Optionally, you can override the Docker run command
# using the DOCKER_SPAWN_CMD environment variable.
spawn_cmd = os.environ.get('DOCKER_SPAWN_CMD', "start-singleuser.sh")
c.DockerSpawner.extra_create_kwargs.update({ 'command': spawn_cmd })
# Connect containers to this Docker network
network_name = os.environ['DOCKER_NETWORK_NAME']
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.network_name = network_name
# Pass the network name as argument to spawned containers
c.DockerSpawner.extra_host_config = { 'network_mode': network_name }
# Explicitly set notebook directory because we'll be mounting a host volume to
# it.  Most jupyter/docker-stacks *-notebook images run the Notebook server as
# user `jovyan`, and set the notebook directory to `/home/jovyan/work`.
# We follow the same convention.
notebook_dir = os.environ.get('DOCKER_NOTEBOOK_DIR') or '/home/jovyan/work'
c.DockerSpawner.notebook_dir = notebook_dir
# Mount the real user's Docker volume on the host to the notebook user's
# notebook directory in the container
#c.DockerSpawner.volumes = {
#    os.environ['MOUNT_POINT']: '/isis/data'
#}
#c.DockerSpawner.volumes = { 'jupyterhub-user-{username}': notebook_dir }
# volume_driver is no longer a keyword argument to create_container()
# c.DockerSpawner.extra_create_kwargs.update({ 'volume_driver': 'local' })
# Remove containers once they are stopped
isis_data = os.environ.get('ISIS_DATA_VOL')
c.DockerSpawner.volumes = { 'jupyterhub-user-{username}':notebook_dir,
                            isis_data:'/isis/data',
                          }
c.DockerSpawner.remove = True
# For debugging arguments passed to spawned containers
c.DockerSpawner.debug = True

# User containers will access hub by container name on the Docker network
c.JupyterHub.hub_ip = 'jupyterhub'
c.JupyterHub.hub_port =int(os.environ['DOCKER_NOTEBOOK_PORT'])


import csv
import os


users = []
admins = []
userfile = csv.reader(open('/srv/jupyterhub/userlist'))
#next(userfile)
for row in userfile:
    k, v = row
    users.append(k)
    if v =='admin':
        admins.append(k)



if 'GITHUB_CLIENT_ID' in os.environ:
    assert 'GITHUB_CLIENT_SECRET' in os.environ

    # from oauthenticator.github import LocalGitHubOAuthenticator
    from oauthenticator.github import LocalGitHubOAuthenticator
    c.JupyterHub.authenticator_class = LocalGitHubOAuthenticator

    c.LocalGitHubOAuthenticator.create_system_users = True
    c.Authenticator.delete_invalid_users = True
    ## Add the administrator(s) to this list
    c.Authenticator.admin_users = set(admins)
    c.Authenticator.allowed_users = set(users)
    ## Add allowed users to this list if you want to restrict access
    #c.Authenticator.whitelist = {'joao','maria'}

    c.LocalGitHubOAuthenticator.client_id = os.environ['GITHUB_CLIENT_ID']
    c.LocalGitHubOAuthenticator.client_secret = os.environ['GITHUB_CLIENT_SECRET']
    c.LocalGitHubOAuthenticator.oauth_callback_url = os.environ['GITHUB_CALLBACK_URL']

else:
    if 'GITLAB_CLIENT_ID' in os.environ:
        assert 'GITLAB_CLIENT_SECRET' in os.environ

        from oauthenticator.gitlab import LocalGitLabOAuthenticator
        c.JupyterHub.authenticator_class = LocalGitLabOAuthenticator

        c.LocalGitLabOAuthenticator.create_system_users = True
        c.Authenticator.delete_invalid_users = True
        ## Add the administrator(s) to this list

        c.Authenticator.admin_users = set(admins)
        ## Add allowed users to this list if you want to restrict access
        c.Authenticator.allowed_users = set(users)

        c.LocalGitLabOAuthenticator.client_id = os.environ['GITLAB_CLIENT_ID']
        c.LocalGitLabOAuthenticator.client_secret = os.environ['GITLAB_CLIENT_SECRET']
        c.LocalGitLabOAuthenticator.oauth_callback_url = os.environ['GITLAB_CALLBACK_URL']


# Persist hub data on volume mounted inside container
data_dir = os.environ.get('DATA_VOLUME_CONTAINER', '/data')

c.JupyterHub.cookie_secret_file = os.path.join(data_dir,
    'jupyterhub_cookie_secret')

c.JupyterHub.db_url = 'postgresql://postgres:{password}@{host}/{db}'.format(
    host=os.environ['POSTGRES_HOST'],
    password=os.environ['POSTGRES_PASSWORD'],
    db=os.environ['POSTGRES_DB'],
)
