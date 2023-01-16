# How to recover Bitbucket Server repositories when the database is lost
Summary


Bitbucket will store data within an associate database and a filesystem. The database is used to store all metadata whilst the filesystem is used to store the git repository. If the database becomes corrupt and can not be recovered then all metadata will be lost. The metadata includes such things repository/branch permissions, project details and other non git details. Bitbucket will store the git repositories on the filesystem under <Bitbucket-home>/shared/data/repositories/<RepositoryID>. If these are still intact then the repository can be recovered.

Bitbucket Datacenter provides a mechanism to read the existing repository data and check for consistency and correct if something is missing.  Running integrity checks in Bitbucket Datacenter. This document provides the steps required for a non-datacenter instance.

If the database is unrecoverable we lose the metadata but the actual git repository is still available. To recover the repositories from a Bitbucket Server instance you would need to install a fresh Bitbucket instance and then recreate the projects and repositories and import the git repository. 
Environment

.
Linux
Solution

The following script can be used, on Linux, as the basis for the script needed to recover the git repository data and import it into a fresh Bitbucket Server instance. Within each of the git repositories Bitbucket inserts a repository-config file which contains the Project and Repository stubs. Whilst these are not actual project and repository names it does give a unique identifier that Bitbucket can use. To recreate the database you will need to perform a fresh install of Bitbucket Server. Specify a different <Bitbucket-home> directory so that you do not overwrite your existing data.

The following bash  script can be used to recreate the projects and repositories within Bitbucket. Before running the script you would need to move the old <Bitbucket-home>/shared/data/repositories directory to an alternate location.

For each repository:

    Read the repository-config
    Create the Project using REST API.
    Create the Repository using REST API.
    Clone the old repository and push the contents to the newly created repository.