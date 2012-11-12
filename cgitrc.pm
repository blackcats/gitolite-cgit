package Gitolite::Triggers::cgitrc;

use Gitolite::Rc;
use Gitolite::Easy;
use Gitolite::Common;
use Gitolite::Conf::Load;

use strict;
use warnings;

# aliasing a repo to another
# ----------------------------------------------------------------------

=for usage

Why:

    * Cree dynamiquement le fichier contenant la liste de repos a afficher
      via cgit a chaque mise a jour de gitolite-admin.
    * Toutes les options repo.* de cgit sont disponible. il suffit juste 
      de mettre cgit a la place de repo dans le configuration du repository
      de gitolite.

How:

    * add a new variable CGIT_REPO_FILE to the rc file, with entries like:
      CGIT_REPO_FILE            => '/path/to/cgit/repo/conf/file',

    * add the following line to the POST_CREATE and POST_COMPILE section 
      in the rc file:
      'cgit::update',

Notes:

    * Il n'est pas necessaire de definit cgit.path et cgit.url. Leurs
      equivalent cgit (repo.path et repo.url) sont crees dynamiquement avec
      le nom du repository.

=cut

#my $GL_ADMIN_BASE   = "/home/merlin/config/gitolite-admin";
#my $GL_REPO_BASE    = "/un/chemin/a/la/con";
#my $CGIT_REPOS_CONF = "/usr/local/etc/cgit.d/repos.conf";

my $header = "#\n# File managed by gitolite.\nPlease do not EDIT!\n#\n\n";

sub update {
    my $cgit_rep_def = "";

    _chdir($rc{GL_REPO_BASE});
    my $r = list_phy_repos(1);
    my @repos = @$r;

    foreach my $r (@repos) {
        my %ref = config($r, "cgit\\.");
        if (keys(%ref) != 0) {
            $cgit_rep_def .= "repo.url=" . $r . "\n";
            $cgit_rep_def .= "repo.path=" . $rc{GL_REPO_BASE}
                                . "/" . $r . ".git\n";

            foreach (keys %ref) {
                next if ($_ =~ m/^cgit\.url$/ || $_ =~ m/^cgit.path$/);
                my $k = $_;
                $k =~ s/^cgit\./repo\./;
                $cgit_rep_def .= $k . "=" . $ref{$_} . "\n";
            }
            $cgit_rep_def .= "\n";
        }
    }
        
    open(my $fd, ">", $rc{CGIT_REPO_FILE}) 
                or die "Can't open $rc{CGIT_REPO_FILE} : $!\n";
    print $fd $header . $cgit_rep_def;
    close($fd);
}

1;
