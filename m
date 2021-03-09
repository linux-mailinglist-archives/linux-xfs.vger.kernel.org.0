Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61B7331DF6
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Mar 2021 05:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCIEkK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 23:40:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhCIEjm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0916528A;
        Tue,  9 Mar 2021 04:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264781;
        bh=6tTKzlwpYMuR40EJ4nJdGbXDQpWfXv6u20IyCTCwiWE=;
        h=Subject:From:To:Cc:Date:From;
        b=S+kxHCdX/VRhVS1hh5yOriY8LcFfF/CBAgLPAqss+DZeK7rK2/3kJqs2wlbPS7csx
         ILlO2JcHiwNV7CcxoPI4O20rBqUIvVMl61Mc2mXVBSQI5p3/f7zEI0W80X59ayr3Vh
         gdY0yr6dWuPVnl7gO0IkERxDen8Sknp/HF5vsQW/f++fUHPPGOXqCamznlKyA6gqTt
         xL5PJziy+bPss8fUGx9SMMpojqyJJZZ1wn4h+TpSi1Qh/o7Z8hulEM1nvs/lT+d5Cv
         AMTV4vq2HyzEe2EWNovuAsVreOUL97YpMq6P08pUZ0bNiDap5dBHLf+gP0ZOM5ajAa
         8INyUUqsMBTPg==
Subject: [PATCHSET 0/2] fstests: remove obsolete DMAPI tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:41 -0800
Message-ID: <161526478158.1213071.11274238322406050241.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

DMAPI (apparently) was some sort of data management API that at some
point in the distant past could be used to implement a hierarchal
storage manager (HSM) using XFS.  This sounds kind of neat because you
can dynamically page in (or evict out) parts of files to even cheaper
storage, but it has never been implemented in the upstream XFS driver or
any other filesystem.  Get rid of these tests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=remove-dmapi
---
 .gitignore                                     |   79 -
 Makefile                                       |    5 
 build/rpm/xfstests.spec.in                     |    2 
 common/dmapi                                   |   31 -
 common/punch                                   |  106 --
 common/rc                                      |    5 
 configure.ac                                   |    1 
 dmapi/Makefile                                 |   16 
 dmapi/README                                   |    6 
 dmapi/src/Makefile                             |   21 
 dmapi/src/common/Makefile                      |   23 
 dmapi/src/common/cmd/Makefile                  |   31 -
 dmapi/src/common/cmd/read_invis.c              |  196 ----
 dmapi/src/common/cmd/set_region.c              |  148 ---
 dmapi/src/common/cmd/set_return_on_destroy.c   |  130 --
 dmapi/src/common/cmd/write_invis.c             |  175 ---
 dmapi/src/common/lib/Makefile                  |   31 -
 dmapi/src/common/lib/dmport.h                  |  859 ----------------
 dmapi/src/common/lib/find_session.c            |  186 ---
 dmapi/src/common/lib/hsm.h                     |  166 ---
 dmapi/src/common/lib/print.c                   |  589 -----------
 dmapi/src/common/lib/stubs.c                   |  491 ---------
 dmapi/src/common/lib/util.c                    |  966 -----------------
 dmapi/src/sample_hsm/Makefile                  |   31 -
 dmapi/src/sample_hsm/README                    |   62 -
 dmapi/src/sample_hsm/migfind.c                 |  280 -----
 dmapi/src/sample_hsm/migin.c                   |  411 -------
 dmapi/src/sample_hsm/migout.c                  |  577 ----------
 dmapi/src/sample_hsm/mls.c                     |  320 ------
 dmapi/src/sample_hsm/mrmean.c                  |  325 ------
 dmapi/src/sample_hsm/wbee.c                    |  599 -----------
 dmapi/src/simple/Makefile                      |   32 -
 dmapi/src/simple/dm_create_session.c           |   47 -
 dmapi/src/simple/dm_destroy_session.c          |   45 -
 dmapi/src/simple/dm_find_eventmsg.c            |   65 -
 dmapi/src/simple/dm_getall_sessions.c          |   70 -
 dmapi/src/simple/dm_getall_tokens.c            |   65 -
 dmapi/src/simple/dm_query_session.c            |   59 -
 dmapi/src/suite1/Makefile                      |   18 
 dmapi/src/suite1/cmd/Makefile                  |   54 -
 dmapi/src/suite1/cmd/create_userevent.c        |   89 --
 dmapi/src/suite1/cmd/dm_handle.c               |  250 -----
 dmapi/src/suite1/cmd/downgrade_right.c         |  127 --
 dmapi/src/suite1/cmd/fd_to_handle.c            |   70 -
 dmapi/src/suite1/cmd/get_allocinfo.c           |  358 ------
 dmapi/src/suite1/cmd/get_config_events.c       |  180 ---
 dmapi/src/suite1/cmd/get_dirattrs.c            |  161 ---
 dmapi/src/suite1/cmd/get_dmattr.c              |  125 --
 dmapi/src/suite1/cmd/get_eventlist.c           |  224 ----
 dmapi/src/suite1/cmd/get_events.c              |  119 --
 dmapi/src/suite1/cmd/get_fileattr.c            |  152 ---
 dmapi/src/suite1/cmd/get_mountinfo.c           |  134 --
 dmapi/src/suite1/cmd/get_region.c              |  121 --
 dmapi/src/suite1/cmd/getall_disp.c             |  122 --
 dmapi/src/suite1/cmd/getall_dmattr.c           |  132 --
 dmapi/src/suite1/cmd/handle_to_fshandle.c      |   76 -
 dmapi/src/suite1/cmd/handle_to_path.c          |  137 --
 dmapi/src/suite1/cmd/init_service.c            |   52 -
 dmapi/src/suite1/cmd/link_test.c               |  146 ---
 dmapi/src/suite1/cmd/make_rt_sparse.c          |  136 --
 dmapi/src/suite1/cmd/make_sparse.c             |   90 --
 dmapi/src/suite1/cmd/obj_ref_hold.c            |  128 --
 dmapi/src/suite1/cmd/obj_ref_query.c           |  134 --
 dmapi/src/suite1/cmd/obj_ref_rele.c            |  128 --
 dmapi/src/suite1/cmd/path_to_fshandle.c        |   69 -
 dmapi/src/suite1/cmd/path_to_handle.c          |   69 -
 dmapi/src/suite1/cmd/pending.c                 |   72 -
 dmapi/src/suite1/cmd/print_event.c             | 1313 ------------------------
 dmapi/src/suite1/cmd/print_fshandle.c          |   67 -
 dmapi/src/suite1/cmd/probe_hole.c              |  113 --
 dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c |  186 ---
 dmapi/src/suite1/cmd/punch_hole.c              |  108 --
 dmapi/src/suite1/cmd/query_right.c             |  131 --
 dmapi/src/suite1/cmd/randomize_file.c          |  132 --
 dmapi/src/suite1/cmd/release_right.c           |  128 --
 dmapi/src/suite1/cmd/remove_dmattr.c           |  105 --
 dmapi/src/suite1/cmd/request_right.c           |  153 ---
 dmapi/src/suite1/cmd/respond_event.c           |   82 -
 dmapi/src/suite1/cmd/rwt.c                     |  172 ---
 dmapi/src/suite1/cmd/security_hole.c           |  105 --
 dmapi/src/suite1/cmd/security_hole2.c          |  104 --
 dmapi/src/suite1/cmd/set_disp.c                |  165 ---
 dmapi/src/suite1/cmd/set_dmattr.c              |  118 --
 dmapi/src/suite1/cmd/set_eventlist.c           |  162 ---
 dmapi/src/suite1/cmd/set_fileattr.c            |  399 -------
 dmapi/src/suite1/cmd/struct_test.c             |  222 ----
 dmapi/src/suite1/cmd/sync_by_handle.c          |   99 --
 dmapi/src/suite1/cmd/test_assumption.c         |  133 --
 dmapi/src/suite1/cmd/upgrade_right.c           |  128 --
 dmapi/src/suite1/function_coverage             |   70 -
 dmapi/src/suite2/DMAPI_aliases                 |  119 --
 dmapi/src/suite2/Makefile                      |   18 
 dmapi/src/suite2/README                        |  605 -----------
 dmapi/src/suite2/README_for_check_dmapi        |   29 -
 dmapi/src/suite2/bindir/crttf                  |   15 
 dmapi/src/suite2/bindir/ctf                    |   16 
 dmapi/src/suite2/bindir/ls_to_copy             |  Bin
 dmapi/src/suite2/bindir/make_holey             |   29 -
 dmapi/src/suite2/bindir/run_test               |  523 ---------
 dmapi/src/suite2/bindir/stf                    |   13 
 dmapi/src/suite2/bindir/test_allocinfo_1       |   70 -
 dmapi/src/suite2/bindir/test_allocinfo_2       |   71 -
 dmapi/src/suite2/create_cpio                   |   10 
 dmapi/src/suite2/data/fail.dat                 |   90 --
 dmapi/src/suite2/data/main.dat                 |  131 --
 dmapi/src/suite2/data/nfs.dat                  |  146 ---
 dmapi/src/suite2/data/pending.dat              |   62 -
 dmapi/src/suite2/data/pending_nfs.dat          |   44 -
 dmapi/src/suite2/data/realtime.dat             |  111 --
 dmapi/src/suite2/data/smallq.dat               |   78 -
 dmapi/src/suite2/data/standard.dat             |  295 -----
 dmapi/src/suite2/data/standard_nfs.dat         |  219 ----
 dmapi/src/suite2/dist/README                   |  435 --------
 dmapi/src/suite2/lib/errtest.h                 |  219 ----
 dmapi/src/suite2/menu_test                     |  329 ------
 dmapi/src/suite2/src/Makefile                  |   37 -
 dmapi/src/suite2/src/check_dmapi.c             |  247 ----
 dmapi/src/suite2/src/dm_test_daemon.c          | 1327 ------------------------
 dmapi/src/suite2/src/invis_test.c              |  232 ----
 dmapi/src/suite2/src/mm_fill.c                 |   64 -
 dmapi/src/suite2/src/mmap.c                    |  307 ------
 dmapi/src/suite2/src/mmap_cp.c                 |   60 -
 dmapi/src/suite2/src/region_test.c             |  139 ---
 dmapi/src/suite2/src/send_msg.c                |  102 --
 dmapi/src/suite2/src/test_bulkall.c            |  310 ------
 dmapi/src/suite2/src/test_bulkattr.c           |  293 -----
 dmapi/src/suite2/src/test_dmattr.c             |  509 ---------
 dmapi/src/suite2/src/test_efault.c             |  232 ----
 dmapi/src/suite2/src/test_eventlist.c          |  458 --------
 dmapi/src/suite2/src/test_fileattr.c           |  698 -------------
 dmapi/src/suite2/src/test_hole.c               |  359 ------
 dmapi/src/suite2/src/test_invis.c              |  448 --------
 dmapi/src/suite2/src/test_region.c             |  251 -----
 dmapi/src/suite2/src/test_rights.c             |  278 -----
 include/builddefs.in                           |    1 
 m4/Makefile                                    |    1 
 m4/package_dmapidev.m4                         |   27 
 tests/xfs/142                                  |   36 -
 tests/xfs/142.out                              |  232 ----
 tests/xfs/143                                  |   36 -
 tests/xfs/143.out                              |   98 --
 tests/xfs/144                                  |   36 -
 tests/xfs/144.out                              |  245 ----
 tests/xfs/145                                  |   36 -
 tests/xfs/145.out                              |   36 -
 tests/xfs/146                                  |   43 -
 tests/xfs/146.out                              |  320 ------
 tests/xfs/147                                  |   36 -
 tests/xfs/147.out                              |   29 -
 tests/xfs/150                                  |   47 -
 tests/xfs/150.out                              |    5 
 tests/xfs/151                                  |   92 --
 tests/xfs/151.out                              |   22 
 tests/xfs/152                                  |   41 -
 tests/xfs/152.out                              |   10 
 tests/xfs/153                                  |   48 -
 tests/xfs/153.out                              |    8 
 tests/xfs/154                                  |   35 -
 tests/xfs/154.out                              |   21 
 tests/xfs/155                                  |   67 -
 tests/xfs/155.out                              |    8 
 tests/xfs/156                                  |   34 -
 tests/xfs/156.out                              |    1 
 tests/xfs/157                                  |   36 -
 tests/xfs/157.out                              |    2 
 tests/xfs/158                                  |   81 -
 tests/xfs/158.out                              |    6 
 tests/xfs/159                                  |   48 -
 tests/xfs/159.out                              |    5 
 tests/xfs/160                                  |   58 -
 tests/xfs/160.out                              |   11 
 tests/xfs/161                                  |   47 -
 tests/xfs/161.out                              |   12 
 tests/xfs/162                                  |   64 -
 tests/xfs/162.out                              |   12 
 tests/xfs/163                                  |   48 -
 tests/xfs/163.out                              |    3 
 tests/xfs/168                                  |   92 --
 tests/xfs/168.out                              |   57 -
 tests/xfs/175                                  |   54 -
 tests/xfs/175.out                              |   63 -
 tests/xfs/176                                  |   60 -
 tests/xfs/176.out                              |  121 --
 tests/xfs/177                                  |   65 -
 tests/xfs/177.out                              |   88 --
 tests/xfs/185                                  |   64 -
 tests/xfs/185.out                              |   71 -
 tests/xfs/group                                |   25 
 tools/auto-qa                                  |    4 
 189 files changed, 6 insertions(+), 28189 deletions(-)
 delete mode 100644 common/dmapi
 delete mode 100644 dmapi/Makefile
 delete mode 100644 dmapi/README
 delete mode 100644 dmapi/src/Makefile
 delete mode 100644 dmapi/src/common/Makefile
 delete mode 100644 dmapi/src/common/cmd/Makefile
 delete mode 100644 dmapi/src/common/cmd/read_invis.c
 delete mode 100644 dmapi/src/common/cmd/set_region.c
 delete mode 100644 dmapi/src/common/cmd/set_return_on_destroy.c
 delete mode 100644 dmapi/src/common/cmd/write_invis.c
 delete mode 100644 dmapi/src/common/lib/Makefile
 delete mode 100644 dmapi/src/common/lib/dmport.h
 delete mode 100644 dmapi/src/common/lib/find_session.c
 delete mode 100644 dmapi/src/common/lib/hsm.h
 delete mode 100644 dmapi/src/common/lib/print.c
 delete mode 100644 dmapi/src/common/lib/stubs.c
 delete mode 100644 dmapi/src/common/lib/util.c
 delete mode 100644 dmapi/src/sample_hsm/Makefile
 delete mode 100644 dmapi/src/sample_hsm/README
 delete mode 100644 dmapi/src/sample_hsm/migfind.c
 delete mode 100644 dmapi/src/sample_hsm/migin.c
 delete mode 100644 dmapi/src/sample_hsm/migout.c
 delete mode 100644 dmapi/src/sample_hsm/mls.c
 delete mode 100644 dmapi/src/sample_hsm/mrmean.c
 delete mode 100644 dmapi/src/sample_hsm/wbee.c
 delete mode 100644 dmapi/src/simple/Makefile
 delete mode 100644 dmapi/src/simple/dm_create_session.c
 delete mode 100644 dmapi/src/simple/dm_destroy_session.c
 delete mode 100644 dmapi/src/simple/dm_find_eventmsg.c
 delete mode 100644 dmapi/src/simple/dm_getall_sessions.c
 delete mode 100644 dmapi/src/simple/dm_getall_tokens.c
 delete mode 100644 dmapi/src/simple/dm_query_session.c
 delete mode 100644 dmapi/src/suite1/Makefile
 delete mode 100644 dmapi/src/suite1/cmd/Makefile
 delete mode 100644 dmapi/src/suite1/cmd/create_userevent.c
 delete mode 100644 dmapi/src/suite1/cmd/dm_handle.c
 delete mode 100644 dmapi/src/suite1/cmd/downgrade_right.c
 delete mode 100644 dmapi/src/suite1/cmd/fd_to_handle.c
 delete mode 100644 dmapi/src/suite1/cmd/get_allocinfo.c
 delete mode 100644 dmapi/src/suite1/cmd/get_config_events.c
 delete mode 100644 dmapi/src/suite1/cmd/get_dirattrs.c
 delete mode 100644 dmapi/src/suite1/cmd/get_dmattr.c
 delete mode 100644 dmapi/src/suite1/cmd/get_eventlist.c
 delete mode 100644 dmapi/src/suite1/cmd/get_events.c
 delete mode 100644 dmapi/src/suite1/cmd/get_fileattr.c
 delete mode 100644 dmapi/src/suite1/cmd/get_mountinfo.c
 delete mode 100644 dmapi/src/suite1/cmd/get_region.c
 delete mode 100644 dmapi/src/suite1/cmd/getall_disp.c
 delete mode 100644 dmapi/src/suite1/cmd/getall_dmattr.c
 delete mode 100644 dmapi/src/suite1/cmd/handle_to_fshandle.c
 delete mode 100644 dmapi/src/suite1/cmd/handle_to_path.c
 delete mode 100644 dmapi/src/suite1/cmd/init_service.c
 delete mode 100644 dmapi/src/suite1/cmd/link_test.c
 delete mode 100644 dmapi/src/suite1/cmd/make_rt_sparse.c
 delete mode 100644 dmapi/src/suite1/cmd/make_sparse.c
 delete mode 100644 dmapi/src/suite1/cmd/obj_ref_hold.c
 delete mode 100644 dmapi/src/suite1/cmd/obj_ref_query.c
 delete mode 100644 dmapi/src/suite1/cmd/obj_ref_rele.c
 delete mode 100644 dmapi/src/suite1/cmd/path_to_fshandle.c
 delete mode 100644 dmapi/src/suite1/cmd/path_to_handle.c
 delete mode 100644 dmapi/src/suite1/cmd/pending.c
 delete mode 100644 dmapi/src/suite1/cmd/print_event.c
 delete mode 100644 dmapi/src/suite1/cmd/print_fshandle.c
 delete mode 100644 dmapi/src/suite1/cmd/probe_hole.c
 delete mode 100644 dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
 delete mode 100644 dmapi/src/suite1/cmd/punch_hole.c
 delete mode 100644 dmapi/src/suite1/cmd/query_right.c
 delete mode 100644 dmapi/src/suite1/cmd/randomize_file.c
 delete mode 100644 dmapi/src/suite1/cmd/release_right.c
 delete mode 100644 dmapi/src/suite1/cmd/remove_dmattr.c
 delete mode 100644 dmapi/src/suite1/cmd/request_right.c
 delete mode 100644 dmapi/src/suite1/cmd/respond_event.c
 delete mode 100644 dmapi/src/suite1/cmd/rwt.c
 delete mode 100644 dmapi/src/suite1/cmd/security_hole.c
 delete mode 100644 dmapi/src/suite1/cmd/security_hole2.c
 delete mode 100644 dmapi/src/suite1/cmd/set_disp.c
 delete mode 100644 dmapi/src/suite1/cmd/set_dmattr.c
 delete mode 100644 dmapi/src/suite1/cmd/set_eventlist.c
 delete mode 100644 dmapi/src/suite1/cmd/set_fileattr.c
 delete mode 100644 dmapi/src/suite1/cmd/struct_test.c
 delete mode 100644 dmapi/src/suite1/cmd/sync_by_handle.c
 delete mode 100644 dmapi/src/suite1/cmd/test_assumption.c
 delete mode 100644 dmapi/src/suite1/cmd/upgrade_right.c
 delete mode 100644 dmapi/src/suite1/function_coverage
 delete mode 100644 dmapi/src/suite2/DMAPI_aliases
 delete mode 100644 dmapi/src/suite2/Makefile
 delete mode 100644 dmapi/src/suite2/README
 delete mode 100644 dmapi/src/suite2/README_for_check_dmapi
 delete mode 100755 dmapi/src/suite2/bindir/crttf
 delete mode 100755 dmapi/src/suite2/bindir/ctf
 delete mode 100644 dmapi/src/suite2/bindir/ls_to_copy
 delete mode 100755 dmapi/src/suite2/bindir/make_holey
 delete mode 100755 dmapi/src/suite2/bindir/run_test
 delete mode 100755 dmapi/src/suite2/bindir/stf
 delete mode 100755 dmapi/src/suite2/bindir/test_allocinfo_1
 delete mode 100755 dmapi/src/suite2/bindir/test_allocinfo_2
 delete mode 100644 dmapi/src/suite2/create_cpio
 delete mode 100644 dmapi/src/suite2/data/fail.dat
 delete mode 100644 dmapi/src/suite2/data/main.dat
 delete mode 100644 dmapi/src/suite2/data/nfs.dat
 delete mode 100644 dmapi/src/suite2/data/pending.dat
 delete mode 100644 dmapi/src/suite2/data/pending_nfs.dat
 delete mode 100644 dmapi/src/suite2/data/realtime.dat
 delete mode 100644 dmapi/src/suite2/data/smallq.dat
 delete mode 100644 dmapi/src/suite2/data/standard.dat
 delete mode 100644 dmapi/src/suite2/data/standard_nfs.dat
 delete mode 100644 dmapi/src/suite2/dist/README
 delete mode 100644 dmapi/src/suite2/lib/errtest.h
 delete mode 100755 dmapi/src/suite2/menu_test
 delete mode 100644 dmapi/src/suite2/src/Makefile
 delete mode 100644 dmapi/src/suite2/src/check_dmapi.c
 delete mode 100644 dmapi/src/suite2/src/dm_test_daemon.c
 delete mode 100644 dmapi/src/suite2/src/invis_test.c
 delete mode 100644 dmapi/src/suite2/src/mm_fill.c
 delete mode 100644 dmapi/src/suite2/src/mmap.c
 delete mode 100644 dmapi/src/suite2/src/mmap_cp.c
 delete mode 100644 dmapi/src/suite2/src/region_test.c
 delete mode 100644 dmapi/src/suite2/src/send_msg.c
 delete mode 100644 dmapi/src/suite2/src/test_bulkall.c
 delete mode 100644 dmapi/src/suite2/src/test_bulkattr.c
 delete mode 100644 dmapi/src/suite2/src/test_dmattr.c
 delete mode 100644 dmapi/src/suite2/src/test_efault.c
 delete mode 100644 dmapi/src/suite2/src/test_eventlist.c
 delete mode 100644 dmapi/src/suite2/src/test_fileattr.c
 delete mode 100644 dmapi/src/suite2/src/test_hole.c
 delete mode 100644 dmapi/src/suite2/src/test_invis.c
 delete mode 100644 dmapi/src/suite2/src/test_region.c
 delete mode 100644 dmapi/src/suite2/src/test_rights.c
 delete mode 100644 m4/package_dmapidev.m4
 delete mode 100755 tests/xfs/142
 delete mode 100644 tests/xfs/142.out
 delete mode 100755 tests/xfs/143
 delete mode 100644 tests/xfs/143.out
 delete mode 100755 tests/xfs/144
 delete mode 100644 tests/xfs/144.out
 delete mode 100755 tests/xfs/145
 delete mode 100644 tests/xfs/145.out
 delete mode 100755 tests/xfs/146
 delete mode 100644 tests/xfs/146.out
 delete mode 100755 tests/xfs/147
 delete mode 100644 tests/xfs/147.out
 delete mode 100755 tests/xfs/150
 delete mode 100644 tests/xfs/150.out
 delete mode 100755 tests/xfs/151
 delete mode 100644 tests/xfs/151.out
 delete mode 100755 tests/xfs/152
 delete mode 100644 tests/xfs/152.out
 delete mode 100755 tests/xfs/153
 delete mode 100644 tests/xfs/153.out
 delete mode 100755 tests/xfs/154
 delete mode 100644 tests/xfs/154.out
 delete mode 100755 tests/xfs/155
 delete mode 100644 tests/xfs/155.out
 delete mode 100755 tests/xfs/156
 delete mode 100644 tests/xfs/156.out
 delete mode 100755 tests/xfs/157
 delete mode 100644 tests/xfs/157.out
 delete mode 100755 tests/xfs/158
 delete mode 100644 tests/xfs/158.out
 delete mode 100755 tests/xfs/159
 delete mode 100644 tests/xfs/159.out
 delete mode 100755 tests/xfs/160
 delete mode 100644 tests/xfs/160.out
 delete mode 100755 tests/xfs/161
 delete mode 100644 tests/xfs/161.out
 delete mode 100755 tests/xfs/162
 delete mode 100644 tests/xfs/162.out
 delete mode 100755 tests/xfs/163
 delete mode 100644 tests/xfs/163.out
 delete mode 100755 tests/xfs/168
 delete mode 100644 tests/xfs/168.out
 delete mode 100755 tests/xfs/175
 delete mode 100644 tests/xfs/175.out
 delete mode 100755 tests/xfs/176
 delete mode 100644 tests/xfs/176.out
 delete mode 100755 tests/xfs/177
 delete mode 100644 tests/xfs/177.out
 delete mode 100755 tests/xfs/185
 delete mode 100644 tests/xfs/185.out

