This is a trigger for gitolite for update cgit configuration of repository.

It update the cgit configuration at every push of the gitolite configuration.


Installation
============
* Copy it into the __$GL_LIBDIR/Gitolite/Triggers__ directory
* In your .gitolite.rc,
    * add the __CGIT_REPO_FILE__ variable with the path of the cgit 
      configuration file for the repository
        `CGIT_REPO_FILE              => '/etc/cgit.d/repos.conf',`
      This file must be writable by the gitolite user
    * add 'cgit\..\*' in the __GIT_CONFIG_KEYS__
        `GIT_CONFIG_KEYS             =>  'cgit\..*',`
    * add the trigger 'cgitrc::update' in __POST_CREATE__ and __POST_COMPILE__

        `POST_CREATE                 =>`
        `    [
        `        'post-compile/update-git-configs',`
        `        # 'post-compile/update-gitweb-access-list',`
        `        # 'post-compile/update-git-daemon-access-list',`
        `        cgitrc::update,
        `    ],`

* Configure cgit with the global option without insert any repo.\* options.
* In this configuration file, insert the following line:
        `include=/etc/cgit.d/repos.conf`

Usage
=====

* In the gitolite.conf file, add the cgit repo configuration options. Use the
  same option as cgit but replace the _repo_ with _cgit_. Exemple:

        `repo workflow
            RW                    = @photo
            config cgit.section   = Dev
            config cgit.owner     = Wouam
            config cgit.name      = photo workflow
            config cgit.desc      = Personnal scripts for my photography workflow`

* The value for the cgit parameters __repo.url__ and __repo.path__ are not
  needed. Just add one __cgit.*__ in _gitolite.conf_ and they will be
  automatically added.


