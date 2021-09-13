Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34F8409CA7
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Sep 2021 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240596AbhIMTFJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Sep 2021 15:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238493AbhIMTFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 15:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CD0F60F4A;
        Mon, 13 Sep 2021 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631559833;
        bh=fJG4AKI86drLMD/IUO6WEyLneZLstqAsdbrfQ2rbtOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nx9v0iqjmNkSrGz8UvdIhz6MfzuSXL9wW9giJUWOfiIU6QeMONwc5SBBSpDnlm0hm
         UrrQ2bN0W35NDpr2y80xkagKjm1PsURZpgdSweXvdSULBADKTwwCM//tv9EtWflZCq
         Pzx4nKTpNJq67SF0iywoq+dxmyZzxqjicCmobgkyGpXHYptn6zpKD1amK/XRc8QhJb
         4P9Ltw8WGQh5Pd07n1oNf4/yrj3eJXNt0cKmrtMa1wW2KtldJq6OvSYzM8gEw7rAjK
         1TafZgzZRLMngPNg/XYTjvJPAf5KbPBViYuOzSXpzTA+fP8VG4U55DRus17/X6e3LO
         mvcGEnI0I0ZXA==
Date:   Mon, 13 Sep 2021 12:03:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v2.1 6/8] tools: make sure that test groups are described
 in the documentation
Message-ID: <20210913190352.GH638503@magnolia>
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
 <163062677608.1579659.1360826362143203767.stgit@magnolia>
 <20210904030600.GB2270902@magnolia>
 <CAOQ4uxgReLEdycbNqYfNUVNaSgPa_30E_gfoppN9M2RwVu9c6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgReLEdycbNqYfNUVNaSgPa_30E_gfoppN9M2RwVu9c6Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 04, 2021 at 11:52:32AM +0300, Amir Goldstein wrote:
> On Sat, Sep 4, 2021 at 6:06 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Create a file to document the purpose of each test group that is
> > currently defined in fstests, and change mkgroupfile to check that every
> > group mentioned in the tests is also mentioned in the documentation.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/preamble     |   21 ++++++++
> >  doc/group-names.txt |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/mkgroupfile   |   15 +++++-
> >  3 files changed, 168 insertions(+), 3 deletions(-)
> >  create mode 100644 doc/group-names.txt
> >
> > diff --git a/common/preamble b/common/preamble
> > index 66b0ed05..64d79385 100644
> > --- a/common/preamble
> > +++ b/common/preamble
> > @@ -23,6 +23,26 @@ _register_cleanup()
> >         trap "${cleanup}exit \$status" EXIT HUP INT QUIT TERM $*
> >  }
> >
> > +# Make sure each group is in the documentation file.
> > +_check_groups() {
> > +       test -n "$GROUPNAME_DOC_FILE" || return 0
> > +
> > +       local testname="$(echo "$0" | sed -e 's/^.*tests\///g')"
> > +       declare -a missing=()
> > +
> > +       for group in "$@"; do
> > +               if ! grep -q "^${group}[[:space:]]" "$GROUPNAME_DOC_FILE"; then
> > +                       missing+=("\"${group}\"")
> > +               fi
> > +       done
> > +       test "${#missing}" -eq 0 && return 0
> > +
> > +       local suffix=
> > +       test "${#missing}" -gt 1 && suffix="s"
> > +       echo "$testname: group$suffix ${missing[@]} not mentioned in documentation." 1>&2
> > +       return 1
> > +}
> > +
> >  # Prepare to run a fstest by initializing the required global variables to
> >  # their defaults, sourcing common functions, registering a cleanup function,
> >  # and removing the $seqres.full file.
> > @@ -42,6 +62,7 @@ _begin_fstest()
> >         # If we're only running the test to generate a group.list file,
> >         # spit out the group data and exit.
> >         if [ -n "$GENERATE_GROUPS" ]; then
> > +               _check_groups "$@" || exit 1
> >                 echo "$seq $@"
> >                 exit 0
> >         fi
> > diff --git a/doc/group-names.txt b/doc/group-names.txt
> > new file mode 100644
> > index 00000000..e8e3477e
> > --- /dev/null
> > +++ b/doc/group-names.txt
> > @@ -0,0 +1,135 @@
> > +======================= =======================================================
> > +Group Name:            Description:
> > +======================= =======================================================
> > +all                    All known tests, automatically generated by ./check at
> > +                       runtime
> > +auto                   Tests that should be run automatically.  These should
> > +                       not require more than ~5 minutes to run.
> > +quick                  Tests that should run in under 30 seconds.
> > +deprecated             Old tests that should not be run.
> > +
> > +acl                    Access Control Lists
> > +admin                  xfs_admin functionality
> > +aio                    general libaio async io tests
> > +atime                  file access time
> > +attr                   extended attributes
> > +attr2                  xfs v2 extended aributes
> > +balance                        btrfs tree rebalance
> > +bigtime                        timestamps beyond the year 2038
> > +blockdev               block device functionality
> > +broken                 broken tests
> > +cap                    Linux capabilities
> > +casefold               directory name casefolding
> > +ci                     ASCII case-insensitive directory name lookups
> > +clone                  FICLONE/FICLONERANGE ioctls
> > +clone_stress           stress testing FICLONE/FICLONERANGE
> > +collapse               fallocate FALLOC_FL_COLLAPSE_RANGE
> > +compress               file compression
> > +convert                        btrfs ext[34] conversion tool
> > +copy                   xfs_copy functionality
> > +copy_range             copy_file_range syscall
> > +copyup                 overlayfs copyup
> > +dangerous              dangerous test that can crash the system
> > +dangerous_bothrepair   fuzzers to evaluate xfs_scrub + xfs_repair repair
> > +dangerous_fuzzers      fuzzers that can crash your computer
> > +dangerous_norepair     fuzzers to evaluate kernel metadata verifiers
> > +dangerous_online_repair        fuzzers to evaluate xfs_scrub online repair
> > +dangerous_repair       fuzzers to evaluate xfs_repair offline repair
> > +dangerous_scrub                fuzzers to evaluate xfs_scrub checking
> > +data                   data loss checkers
> > +dax                    direct access mode for persistent memory files
> > +db                     xfs_db functional tests
> > +dedupe                 FIEDEDUPERANGE ioctl
> > +defrag                 filesystem defragmenters
> > +dir                    directory test functions
> > +dump                   dump and restore utilities
> > +eio                    IO error reporting
> > +encrypt                        encrypted file contents
> > +enospc                 ENOSPC error reporting
> > +exportfs               file handles
> > +filestreams            XFS filestreams allocator
> > +freeze                 filesystem freeze tests
> > +fsck                   general fsck tests
> > +fsmap                  FS_IOC_GETFSMAP ioctl
> > +fsr                    XFS free space reorganizer
> > +fuzzers                        filesystem fuzz tests
> > +growfs                 increasing the size of a filesystem
> > +hardlink               hardlinks
> > +health                 XFS health reporting
> > +idmapped               idmapped mount functionality
> > +inobtcount             XFS inode btree count tests
> > +insert                 fallocate FALLOC_FL_INSERT_RANGE
> > +ioctl                  general ioctl tests
> > +io_uring               general io_uring async io tests
> > +label                  filesystem labelling
> > +limit                  resource limits
> > +locks                  file locking
> > +log                    metadata logging
> > +logprint               xfs_logprint functional tests
> > +long_rw                        long-soak read write IO path exercisers
> > +metacopy               overlayfs metadata-only copy-up
> > +metadata               filesystem metadata update exercisers
> > +metadump               xfs_metadump/xfs_mdrestore functionality
> > +mkfs                   filesystem formatting tools
> > +mount                  mount option and functionality checks
> > +nested                 nested overlayfs instances
> > +nfs4_acl               NFSv4 access control lists
> > +nonsamefs              overlayfs layers on different filesystems
> > +online_repair          online repair functionality tests
> > +other                  dumping ground, do not add more tests to this group
> > +pattern                        specific IO pattern tests
> > +perms                  access control and permission checking
> > +pipe                   pipe functionality
> > +pnfs                   PNFS
> > +posix                  POSIX behavior conformance
> > +prealloc               fallocate for preallocating unwritten space
> > +preallocrw             fallocate, then read and write
> > +punch                  fallocate FALLOC_FL_PUNCH_HOLE
> > +qgroup                 btrfs qgroup feature
> > +quota                  filesystem usage quotas
> > +raid                   btrfs RAID
> > +realtime               XFS realtime volumes
> > +recoveryloop           crash recovery loops
> > +redirect               overlayfs redirect_dir feature
> > +remote                 dump and restore with a remote tape
> > +remount                        remounting filesystems
> > +rename                 rename system call
> > +repair                 xfs_repair functional tests
> > +replace                        btrfs device replace
> > +replay                 dm-logwrites replays
> > +resize                 resize2fs functionality tests
> > +richacl                        rich ACL feature
> > +rmap                   XFS reverse mapping exercisers
> > +rotate                 overlayfs upper layer rotate tests from the unionmount
> > +                       test suite
> > +rw                     read/write IO tests
> > +samefs                 overlayfs when all layers are on the same fs
> > +scrub                  filesystem metadata scrubbers
> > +seed                   btrfs seeded filesystems
> > +seek                   llseek functionality
> > +send                   btrfs send/receive
> > +shrinkfs               decreasing the size of a filesystem
> > +shutdown               FS_IOC_SHUTDOWN ioctl
> > +snapshot               btrfs snapshots
> > +soak                   long running soak tests of any kind
> > +spaceman               xfs_spaceman functional tests
> > +splice                 splice system call
> > +stress                 fsstress filesystem exerciser
> > +subvol                 btrfs subvolumes
> > +swap                   swap files
> > +symlink                        symbolic links
> > +tape                   dump and restore with a tape
> > +thin                   thin provisioning
> > +trim                   FITRIM ioctl
> > +udf                    UDF functionality tests
> > +union                  tests from the unionmount test suite
> > +unlink                 O_TMPFILE unlinked files
> > +unshare                        fallocate FALLOC_FL_UNSHARE_RANGE
> > +v2log                  XFS v2 log format tests
> > +verity                 fsverity
> > +volume                 btrfs volume management
> > +whiteout               overlayfs whiteout functionality
> > +xino                   overlayfs xino feature
> > +zero                   fallocate FALLOC_FL_ZERO_RANGE
> > +zone                   zoned (SMR) device support
> > +======================= =======================================================
> > diff --git a/tools/mkgroupfile b/tools/mkgroupfile
> > index 0681e5d2..767bac90 100755
> > --- a/tools/mkgroupfile
> > +++ b/tools/mkgroupfile
> > @@ -9,6 +9,8 @@ fi
> >
> >  test_dir="$PWD"
> >  groupfile="$1"
> > +GROUPNAME_DOC_FILE="$(readlink -m ../../doc/group-names.txt)"
> > +export GROUPNAME_DOC_FILE
> >
> >  if [ ! -x ../../check ]; then
> >         echo "$0: Run this from tests/XXX/."
> > @@ -24,19 +26,26 @@ ENDL
> >         cd ../../
> >         export GENERATE_GROUPS=yes
> >         grep -R -l "^_begin_fstest" "$test_dir/" 2>/dev/null | while read testfile; do
> > -               test -x "$testfile" && "$testfile"
> > +               test -x "$testfile" && "$testfile" || return 1
> >         done | sort -g
> > +       local ret="${PIPESTATUS[1]}"
> >         cd "$test_dir"
> > +       return $ret
> >  }
> >
> >  if [ -z "$groupfile" ] || [ "$groupfile" = "-" ]; then
> >         # Dump the group file to stdout and exit
> >         generate_groupfile
> > -       exit 0
> 
> Now the comment above is incorrect, but I think you
> did want to exit $ret?

"exit" by itself will cause the script to exit with the last accumulated
return value (which is the 'return $ret' in the last line of
generat_groupfile), but yes, thanks for pointing out that I'd deleted
the whole line by mistake.  Fixed.

> 
> >  fi
> >
> >  # Otherwise, write the group file to disk somewhere.
> >  ngroupfile="${groupfile}.new"
> >  rm -f "$ngroupfile"
> >  generate_groupfile >> "$ngroupfile"
> > -mv "$ngroupfile" "$groupfile"
> > +ret=$?
> > +if [ $ret -eq 0 ]; then
> > +       mv "$ngroupfile" "$groupfile"
> > +else
> > +       rm -f "$ngroupfile"
> > +fi
> > +exit $ret
> 
> I think that a cleanup() trap would have made this script a lot cleaner,
> not having to deal with ${PIPESTATUS[1]} and whatnot, but if there is
> a reason not to use cleanup() trap, I'm fine with this as well.

No real reason.  I'll reimplement the prologue as a cleanup trap so that
we don't leave junk everywhere if someone ^Cs during build.

--D

> 
> Thanks,
> Amir.
