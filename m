Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22F419707
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Sep 2021 17:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhI0PCt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Sep 2021 11:02:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235043AbhI0PCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 11:02:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632754865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yO1F5xV/w3jVVx3CqCKE+zM6zxRBKmBmGEUCcB0x0Q0=;
        b=VHFyOVlaOlKS/KfM08wAWgkd2RPnjzJ0c4LA3gkarXetYExVH+OhFCZYhTb3WJH6Uy9G2e
        XwnByMvlzyZFL3+GXvhgH3mFDPF3LWIWdTOr9qlCoOJm+x9IDb93CZJLBU3iN9pGcaglrg
        qU/m+a2xCoDQY8UQCNyFu1TOcSsoe0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-0ys8d1JIMfGFeSmBfLZOPA-1; Mon, 27 Sep 2021 11:01:01 -0400
X-MC-Unique: 0ys8d1JIMfGFeSmBfLZOPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D5BE802921;
        Mon, 27 Sep 2021 15:01:00 +0000 (UTC)
Received: from redhat.com (unknown [10.22.17.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC66F6C8FC;
        Mon, 27 Sep 2021 15:00:48 +0000 (UTC)
Date:   Mon, 27 Sep 2021 10:00:47 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Donald Douwsma <ddouwsma@redhat.com>
Subject: Re: [RFC PATCH v2] xfsrestore: fix rootdir due to xfsdump bulkstat
 misuse
Message-ID: <20210927150047.h6czo5ege2ogcql5@redhat.com>
References: <20201113125127.966243-1-hsiangkao@redhat.com>
 <20201116080723.1486270-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116080723.1486270-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 16, 2020 at 04:07:23PM +0800, Gao Xiang wrote:
> If rootino is wrong and misspecified to a subdir inode #,
> the following assertion could be triggered:
>   assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> 
> This patch adds a '-x' option (another awkward thing is that
> the codebase doesn't support long options) to address
> problamatic images by searching for the real dir, the reason
> that I don't enable it by default is that I'm not very confident
> with the xfsrestore codebase and xfsdump bulkstat issue will
> also be fixed immediately as well, so this function might be
> optional and only useful for pre-exist corrupted dumps.
> 
> In details, my understanding of the original logic is
>  1) xfsrestore will create a rootdir node_t (p_rooth);
>  2) it will build the tree hierarchy from inomap and adopt
>     the parent if needed (so inodes whose parent ino hasn't
>     detected will be in the orphan dir, p_orphh);
>  3) during this period, if ino == rootino and
>     hardh != persp->p_rooth (IOWs, another node_t with
>     the same ino # is created), that'd be definitely wrong.
> 
> So the proposal fix is that
>  - considering the xfsdump root ino # is a subdir inode, it'll
>    trigger ino == rootino && hardh != persp->p_rooth condition;
>  - so we log this node_t as persp->p_rooth rather than the
>    initial rootdir node_t created in 1);
>  - we also know that this node is actually a subdir, and after
>    the whole inomap is scanned (IOWs, the tree is built),
>    the real root dir will have the orphan dir parent p_orphh;
>  - therefore, we walk up by the parent until some node_t has
>    the p_orphh, so that's it.
> 
> Cc: Donald Douwsma <ddouwsma@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

I used your manual fault injection patch to test, and this solution
works for me. Thanks!

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> changes since RFC v1:
>  - fix non-dir fake rootino cases since tree_begindir()
>    won't be triggered for these non-dir, and we could do
>    that in tree_addent() instead (fault injection verified);
> 
>  - fix fake rootino case with gen = 0 as well, for more
>    details, see the inlined comment in link_hardh()
>    (fault injection verified as well).
> 
> Anyway, all of this behaves like a workaround and I have
> no idea how to deal it more gracefully.
> 
>  restore/content.c |  7 +++++
>  restore/getopt.h  |  4 +--
>  restore/tree.c    | 70 ++++++++++++++++++++++++++++++++++++++++++++---
>  restore/tree.h    |  2 ++
>  4 files changed, 77 insertions(+), 6 deletions(-)
> 
> diff --git a/restore/content.c b/restore/content.c
> index 6b22965..e807a83 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -865,6 +865,7 @@ static int quotafilecheck(char *type, char *dstdir, char *quotafile);
>  
>  bool_t content_media_change_needed;
>  bool_t restore_rootdir_permissions;
> +bool_t need_fixrootdir;
>  char *media_change_alert_program = NULL;
>  size_t perssz;
>  
> @@ -964,6 +965,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  	stsz = 0;
>  	interpr = BOOL_FALSE;
>  	restore_rootdir_permissions = BOOL_FALSE;
> +	need_fixrootdir = BOOL_FALSE;
>  	optind = 1;
>  	opterr = 0;
>  	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
> @@ -1189,6 +1191,9 @@ content_init(int argc, char *argv[], size64_t vmsz)
>  		case GETOPT_FMT2COMPAT:
>  			tranp->t_truncategenpr = BOOL_TRUE;
>  			break;
> +		case GETOPT_FIXROOTDIR:
> +			need_fixrootdir = BOOL_TRUE;
> +			break;
>  		}
>  	}
>  
> @@ -3140,6 +3145,8 @@ applydirdump(drive_t *drivep,
>  			return rv;
>  		}
>  
> +		if (need_fixrootdir)
> +			tree_fixroot();
>  		persp->s.dirdonepr = BOOL_TRUE;
>  	}
>  
> diff --git a/restore/getopt.h b/restore/getopt.h
> index b5bc004..b0c0c7d 100644
> --- a/restore/getopt.h
> +++ b/restore/getopt.h
> @@ -26,7 +26,7 @@
>   * purpose is to contain that command string.
>   */
>  
> -#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
> +#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wxABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
>  
>  #define GETOPT_WORKSPACE	'a'	/* workspace dir (content.c) */
>  #define GETOPT_BLOCKSIZE        'b'     /* blocksize for rmt */
> @@ -51,7 +51,7 @@
>  /*				'u' */
>  #define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
>  #define	GETOPT_SMALLWINDOW	'w'	/* use a small window for dir entries */
> -/*				'x' */
> +#define GETOPT_FIXROOTDIR	'x'	/* try to fix rootdir due to bulkstat misuse */
>  /*				'y' */
>  /*				'z' */
>  #define	GETOPT_NOEXTATTR	'A'	/* do not restore ext. file attr. */
> diff --git a/restore/tree.c b/restore/tree.c
> index 0670318..918fa01 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -15,7 +15,6 @@
>   * along with this program; if not, write the Free Software Foundation,
>   * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
> -
>  #include <stdio.h>
>  #include <unistd.h>
>  #include <stdlib.h>
> @@ -265,6 +264,7 @@ extern void usage(void);
>  extern size_t pgsz;
>  extern size_t pgmask;
>  extern bool_t restore_rootdir_permissions;
> +extern bool_t need_fixrootdir;
>  
>  /* forward declarations of locally defined static functions ******************/
>  
> @@ -331,10 +331,45 @@ static tran_t *tranp = 0;
>  static char *persname = PERS_NAME;
>  static char *orphname = ORPH_NAME;
>  static xfs_ino_t orphino = ORPH_INO;
> +static nh_t orig_rooth = NH_NULL;
>  
>  
>  /* definition of locally defined global functions ****************************/
>  
> +void
> +tree_fixroot(void)
> +{
> +	nh_t		rooth = persp->p_rooth;
> +	xfs_ino_t 	rootino;
> +
> +	while (1) {
> +		nh_t	parh;
> +		node_t *rootp = Node_map(rooth);
> +
> +		rootino = rootp->n_ino;
> +		parh = rootp->n_parh;
> +		Node_unmap(rooth, &rootp);
> +
> +		if (parh == rooth ||
> +		/*
> +		 * since all new node (including non-parent)
> +		 * would be adopted into orphh
> +		 */
> +		    parh == persp->p_orphh ||
> +		    parh == NH_NULL)
> +			break;
> +		rooth = parh;
> +	}
> +
> +	if (rooth != persp->p_rooth) {
> +		persp->p_rooth = rooth;
> +		persp->p_rootino = rootino;
> +
> +		mlog(MLOG_NORMAL, _("fix root # to %llu (bind mount?)\n"),
> +		     rootino);
> +	}
> +}
> +
>  /* ARGSUSED */
>  bool_t
>  tree_init(char *hkdir,
> @@ -754,7 +789,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  	/* lookup head of hardlink list
>  	 */
>  	hardh = link_hardh(ino, gen);
> -	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
> +	if (need_fixrootdir == BOOL_FALSE)
> +		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
>  
>  	/* already present
>  	 */
> @@ -823,7 +859,6 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>  		adopt(persp->p_orphh, hardh, NRH_NULL);
>  		*dahp = dah;
>  	}
> -
>  	return hardh;
>  }
>  
> @@ -968,6 +1003,7 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>  				}
>  			} else {
>  				assert(hardp->n_nrh != NRH_NULL);
> +
>  				namebuflen
>  				=
>  				namreg_get(hardp->n_nrh,
> @@ -1118,6 +1154,13 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
>  		      ino,
>  		      gen);
>  	}
> +	/* found the fake rootino from subdir, need fix p_rooth. */
> +	if (need_fixrootdir == BOOL_TRUE &&
> +	    persp->p_rootino == ino && hardh != persp->p_rooth) {
> +		mlog(MLOG_NORMAL,
> +		     _("found fake rootino #%llu, will fix.\n"), ino);
> +		persp->p_rooth = hardh;
> +	}
>  	return RV_OK;
>  }
>  
> @@ -3841,7 +3884,26 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
>  static nh_t
>  link_hardh(xfs_ino_t ino, gen_t gen)
>  {
> -	return hash_find(ino, gen);
> +	nh_t tmp = hash_find(ino, gen);
> +
> +	/*
> +	 * XXX (another workaround): the simply way is that don't reuse node_t
> +	 * with gen = 0 created in tree_init(). Otherwise, it could cause
> +	 * xfsrestore: tree.c:1003: tree_addent: Assertion
> +	 * `hardp->n_nrh != NRH_NULL' failed.
> +	 * and that node_t is a dir node but the fake rootino could be a non-dir
> +	 * plus reusing it could cause potential loop in tree hierarchy.
> +	 */
> +	if (need_fixrootdir == BOOL_TRUE &&
> +	    ino == persp->p_rootino && gen == 0 &&
> +	    orig_rooth == NH_NULL) {
> +		mlog(MLOG_NORMAL,
> +_("link out fake rootino %llu with gen=0 created in tree_init()\n"), ino);
> +		link_out(tmp);
> +		orig_rooth = tmp;
> +		return NH_NULL;
> +	}
> +	return tmp;
>  }
>  
>  /* returns following node in hard link list
> diff --git a/restore/tree.h b/restore/tree.h
> index 4f9ffe8..5d0c346 100644
> --- a/restore/tree.h
> +++ b/restore/tree.h
> @@ -18,6 +18,8 @@
>  #ifndef TREE_H
>  #define TREE_H
>  
> +void tree_fixroot(void);
> +
>  /* tree_init - creates a new tree abstraction.
>   */
>  extern bool_t tree_init(char *hkdir,
> -- 
> 2.18.4
> 

