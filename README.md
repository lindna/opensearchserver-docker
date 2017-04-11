# Docker image for OpenSearchServer

Hacked variation of OpenSearchServer v1.5.13 that allows for the UID/GID of the opensearchserver user to be replaced with a suitable user from the host.

Documentation can be found at the [OpenSearchServer documentation center](http://www.opensearchserver.com/documentation/installation/docker.md).

Synology DSM 6.1
----------------

Setup Docker/Accounts on Synology NAS:

On your synology create a new opensearchserver user. Give it read-only access to the shares that you wish OSS to index.
Find the UID/GID of the new user (ssh as admin, cat /etc/passwd, and look for the user)
Install the Synology Docker package and you should find a /volume1/docker directory
On the command line: cd /volume1/docker && mkdir -p opensearch/opensearchserver/data/logs

Build custom image:

Clone this github repo onto your dev box
Edit Dockerfile and update the gid (100) and uid (1032) to the values of your synology opensearchserver user.
docker build -t jonesd/opensearchserver .
docker images
 - confirm that the image was built
docker save jonesd/opensearchserver > jonesd-opensearchserver.tar
scp jonesd-opensearchserver.tar ADMIN-USER@NAS:

Load custom image:

In the NAS browser desktop
Open Docker package
Select Image from left hand menu
Choose Add - Add from File, and find the jonesd-opensearchserver.tar file
Select the jonesd/opensearchserver:latest once added and click Launch
- Make it restart
- Port Settings: 9090 (or whatever) for local port
- Volumes: /docker/opensearch /src rw
- Volumes: add directory for each shared folder you want to be crawled
- Environment: MEMORY 4g

Run and configure container:

Browse OSS admin screen at: http://NAS:9090
Index
- Enter new index name, choose Template: file crawler, and Create
- Select Crawler tab, and Files tab
- Create new location
 - Path should be the first shared folder you have connected to the container
 - With sub directories - check
 - Exclussion patterns: One line for each pattern
  - /*/@eaDir
  - /*/#recycle
  - **/node_modules
 - Enabled - check
 - Click Check - should see the first files in the shared folder that will be crawled. If this is empty check permissions/user id and if your Exclusion patterns are excluding everything
 - Click Create
- Select the Crawl process tab
 - Click Running button - should see the count and committed numbers > 0

Time to Search:

From the OSS admin screen select Renderer tab
Click View button associated with default-file and you should see a search page.


