Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBA5EDCF5
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 11:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfKDKyj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 05:54:39 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728557AbfKDKyj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:54:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BfAAC6AsBd/xK90HYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFsBAEBCwGBc4EYgTGEKY9YAQEBAQEBBoERgSSIZYUxiiqBZwk?=
 =?us-ascii?q?BAQEBAQEBAQEnEAEBhDsDAoQyNwYOAg4BAQEEAQEBAQEFAwGFWEyFYCcEUig?=
 =?us-ascii?q?NAiYCSRYKgyyCUrBidX8zGoQfAQsBhgeBDigBgWSKRniBB4ERM4Iqc4JiAQO?=
 =?us-ascii?q?BRAODKIJeBIxwJIIvN4VfYUOWdYIuhxGFHokiDIIwi3gDiy6QAoZukzmBe00?=
 =?us-ascii?q?uCoMnCRYxgzcXgQQBAociO4VMZ4wvASuCEgEB?=
X-IPAS-Result: =?us-ascii?q?A2BfAAC6AsBd/xK90HYNWRwBAQEBAQcBAREBBAQBAYFsB?=
 =?us-ascii?q?AEBCwGBc4EYgTGEKY9YAQEBAQEBBoERgSSIZYUxiiqBZwkBAQEBAQEBAQEnE?=
 =?us-ascii?q?AEBhDsDAoQyNwYOAg4BAQEEAQEBAQEFAwGFWEyFYCcEUigNAiYCSRYKgyyCU?=
 =?us-ascii?q?rBidX8zGoQfAQsBhgeBDigBgWSKRniBB4ERM4Iqc4JiAQOBRAODKIJeBIxwJ?=
 =?us-ascii?q?IIvN4VfYUOWdYIuhxGFHokiDIIwi3gDiy6QAoZukzmBe00uCoMnCRYxgzcXg?=
 =?us-ascii?q?QQBAociO4VMZ4wvASuCEgEB?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138614"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:54:35 +0800
Subject: [PATCH v9 00/17] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:54:35 +0800
Message-ID: <157286480109.18393.6285224459642752559.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch series add support to xfs for the new kernel mount API as
described in the LWN article at https://lwn.net/Articles/780267/.

In the article there's a lengthy description of the reasons for adopting
the API and problems expected to be resolved by using it.

The series has been applied to the repository located at
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next branch, and
built and some simple tests run on it along with the default xfstests.

Other things that continue to cause me concern:

- Message logging.
  There is error logging done in the VFS by the mount-api code, some is
  VFS specific while some is file system specific. This can lead to
  duplicated and sometimes inconsistent logging.

  The mount-api feature of saving error message text to the mount
  context for later retrieval by fsopen()/fsconfig()/fsmount() users is
  the reason the mount-api log macros are present. But, at the moment
  (last time I looked), these macros will either log the error message
  or save it to the mount context. There's not yet a way to modify this
  behaviour so it which can lead to messages, possibly needed for debug
  purposes, not being sent to the kernel log. There's also the pr_xxx()
  log functions (not a problem for xfs AFAICS) that aren't aware of the
  mount context at all.

  In the xfs patches I've used the same method that is used in gfs2 and
  was suggested by Al Viro (essentially return the error if fs_parse()
  returns one) except that I've also not used the mount api log macros
  to minimise the possibility of lost log messages.

  This isn't the best so follow up patches for RFC (with a slightly
  wider audience) will be needed to try and improve this aspect of the
  mount api. 

Changes for v9:
- fix coding style in the patch to switch to new mount-api.
- fix sync_filesystem() call order.
- fold xfs_mount-alloc() into xfs_init_fs_context().

Changes for v8:
- update to for-next 21f55993eb7a.
- accomodate Christoph's options handling changes (thanks Christoph).
- remove redundant check in __xfs_printk().
- add missing sync_filesystem() in .reconfigure (fixes assertion fail
  reported by Darrick).
- fix IS_ENABLED() macro usage.
- move the xfs_fc_*() functions and related functions above the struct
  fs_context_operations to bring the parameter parsing and mount
  handling code together.

Changes for v7:
- fix s/mount info/struct xfs_mount/g in the patches that remove the
  m_fsname_len and m_fsname struct xfs_mount fields.
- also use IS_ENABLED() macro for the quota config check.
- don't use typedef'ed struct definitions in new or chencged code.
- extend comment lines to use full 80 characters and to 72 characters
  for commit log entries.
- fix function parameter and variable declaration style inconsistencies.
- use "return 0" instead of "break" in xfs_parse_param() as recommended.
- avoid redundant option checks for the case where no options are given.
- merge freeing of mp names and mp.
- change name field of struct fs_parameter_description to lower case.
- group mount related code together as much as possible to enhance
  readability.
- changed mount api related functions to all use an "xfs_fc" prefix.

Changes for v6:
- drop get_tree_bdev() patch since it's now present in the xfs-linux
  repo.
- eliminate unused mount info. field m_fsname_len.
- eliminate mount info field m_fsname, use super block field s_id
  instead.
- dont use XFS_IS_QUOTA_RUNNING() when checking if quota options have
  been specified.
- combine mount-api specific patches into a single patch to help with
  bi-sectability.

Changes for v5:
- give error exit label in xfs_fill_super() a sensible name.
- use original comment about options handling in xfs_fs_remount() for
  comment above xfs_reconfigure().
- use a much simpler comment in xfs_fc_free(), thanks to Brian Foster.
- move cover letter comment about the first two patches above the
  revision comentary so it isn't missed. 

Changes for v4:
- changed xfs_fill_super() cleanup back to what it was in v2, until I
  can work out what's causing the problem had previously seen (I can't
  reproduce it myself), since it looks like it was right from the start.
- use get_tree_bdev() instead of vfs_get_block_super() in xfs_get_tree()
  as requested by Al Viro.
- removed redundant initialisation in xfs_fs_fill_super().
- fix long line in xfs_validate_params().
- no need to validate if parameter parsing fails, just return the error.
- summarise reconfigure comment about option handling, transfer bulk of
  comment to commit log message.
- use minimal change in xfs_parse_param(), deffer discussion of mount
  api logging improvements until later and with a wider audience.

Changes for v3:
- fix struct xfs_fs_context initialization in xfs_parseargs().
- move call to xfs_validate_params() below label "done".
- if allocation of xfs_mount fails return ENOMEM immediately.
- remove erroneous kfree(mp) in xfs_fill_super().
- move the removal of xfs_fs_remount() and xfs_test_remount_options()
  to the switch to mount api patch.
- retain original usage of distinct <option>, no<option> usage.
- fix line length and a white space problem in xfs_parseargs().
- defer introduction of struct fs_context_operations until mount api
  implementation.
- don't use a new line for the void parameter of xfs_mount_alloc().
- check for -ENOPARAM in xfs_parse_param() to report invalid options
  using the options switch.
- remove obolete mount option biosize.
- try and make comment in xfs_fc_free() more understandable.

Changes for v2:
- changed .name to uppercase in fs_parameter_description to ensure
  consistent error log messages between the vfs parser and the xfs
  parameter parser.
- clearify comment above xfs_parse_param() about when possibly allocated
  mp->m_logname or mp->m_rtname are freed.
- factor out xfs_remount_rw() and xfs_remount_ro() from  xfs_remount().
- changed xfs_mount_alloc() to not set super block in xfs_mount so it
  can be re-used when switching to the mount-api.
- fixed don't check for NULL when calling kfree() in xfs_fc_free().
- refactored xfs_parseargs() in an attempt to highlight the code that
  actually changes in converting to use the new mount api.
- dropped xfs-mount-api-rename-xfs_fill_super.patch, it didn't seem
  necessary.
- move comment about remount difficulties above xfs_reconfigure() and
  increase line length to try and make the comment managable.

---

Ian Kent (17):
      xfs: remove unused struct xfs_mount field m_fsname_len
      xfs: use super s_id instead of struct xfs_mount m_fsname
      xfs: dont use XFS_IS_QUOTA_RUNNING() for option check
      xfs: use kmem functions for struct xfs_mount
      xfs: merge freeing of mp names and mp
      xfs: add xfs_remount_rw() helper
      xfs: add xfs_remount_ro() helper
      xfs: refactor suffix_kstrtoint()
      xfs: avoid redundant checks when options is empty
      xfs: refactor xfs_parseags()
      xfs: move xfs_parseargs() validation to a helper
      xfs: dont set sb in xfs_mount_alloc()
      xfs: switch to use the new mount-api
      xfs: move xfs_fc_reconfigure() above xfs_fc_free()
      xfs: move xfs_fc_get_tree() above xfs_fc_reconfigure()
      xfs: move xfs_fc_parse_param() above xfs_fc_get_tree()
      xfs: fold xfs_mount-alloc() into xfs_init_fs_context()


 fs/xfs/xfs_error.c     |    2 
 fs/xfs/xfs_log.c       |    2 
 fs/xfs/xfs_message.c   |    4 
 fs/xfs/xfs_mount.c     |    5 
 fs/xfs/xfs_mount.h     |    2 
 fs/xfs/xfs_pnfs.c      |    2 
 fs/xfs/xfs_super.c     | 1227 ++++++++++++++++++++++++------------------------
 fs/xfs/xfs_trans_ail.c |    2 
 8 files changed, 611 insertions(+), 635 deletions(-)

--
Ian
