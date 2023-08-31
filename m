Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387EC78F218
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Aug 2023 19:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjHaRnY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Aug 2023 13:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241788AbjHaRnX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 13:43:23 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E41DCE63
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 10:43:17 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 003BA5196E5;
        Thu, 31 Aug 2023 12:43:16 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 003BA5196E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1693503797;
        bh=js3k09dLhTEzlOnwoyi7xktUZGcJc12xBRXPusEg+Gs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bEpd5p0YBQldi6+EESWPMwKoOAKqy+f6Qj0dWG0Bl5vgLn9sS7c4QNbPKPRchiLNS
         WCFO398/e2QvBC4RhjJm6Z5sjSlQL0NN8zf+f0HLJhcbb8PWzdCRyjoA1BzOlkac37
         +YuKv2PqzIaiFOO2X59RpL90AY2FRNOYH5q194bjIZWROJOwhIITmGcOTO54jlZgsf
         yDNjyuQ6KV5f/7m6AQAmVMXGeGZAQJ1hGKoXYPhggl8CJftmTV3G7OBICQmjo+Zi+o
         5Q9l3tOBm7xO+EsYtDtPOTmv1cw9Xs2FObxwKWTYv8QN8d/iSia68Qsuc2pcxUzH3h
         mVKLIXfq2AcGg==
Message-ID: <68fe1fdb-8136-92a6-3b73-1d42772fcf22@sandeen.net>
Date:   Thu, 31 Aug 2023 12:43:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2] xfs: load uncached unlinked inodes into memory on
 demand
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
References: <20230830152659.GJ28186@frogsfrogsfrogs>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20230830152659.GJ28186@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/30/23 10:26 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> shrikanth hegde reports that filesystems fail shortly after mount with
> the following failure:
> 
> 	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
> 
> This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:
> 
> 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> 	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }
> 
> From diagnostic data collected by the bug reporters, it would appear
> that we cleanly mounted a filesystem that contained unlinked inodes.
> Unlinked inodes are only processed as a final step of log recovery,
> which means that clean mounts do not process the unlinked list at all.

Thank you for working on this Darrick!

I'll point out that at least one way to end up in this situation is to
have at one point run a very old kernel which did not contain this
commit, merged in kernel v4.14:

commit 6f4a1eefdd0ad4561543270a7fceadabcca075dd
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Aug 8 18:21:49 2017 -0700

    xfs: toggle readonly state around xfs_log_mount_finish

    When we do log recovery on a readonly mount, unlinked inode
    processing does not happen due to the readonly checks in
    xfs_inactive(), which are trying to prevent any I/O on a
    readonly mount.

    This is misguided - we do I/O on readonly mounts all the time,
    for consistency; for example, log recovery.  So do the same
    RDONLY flag twiddling around xfs_log_mount_finish() as we
    do around xfs_log_mount(), for the same reason.

    This all cries out for a big rework but for now this is a
    simple fix to an obvious problem.

    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

so if you:

1) Crash with unlinked inodes
2) mount -o ro <recovers log but skips unlinked inode recovery>
3) mount -o remount,rw
4) umount <writes clean log record>

you now have a filesystem with on-disk unlinked inodes and a clean log,
and those inodes won't get cleaned up until log recovery runs again or
xfs_repair is run.

And in testing an old OS (RHEL7) it does seem that the root filesystem
goes through a mount -o ro, mount -o remount,rw transition at boot time.
So this situation may be somewhat common.

-Eric



> Prior to the introduction of the incore unlinked lists, this wasn't a
> problem because the unlink code would (very expensively) traverse the
> entire ondisk metadata iunlink chain to keep things up to date.
> However, the incore unlinked list code complains when it realizes that
> it is out of sync with the ondisk metadata and shuts down the fs, which
> is bad.
> 
> Ritesh proposed to solve this problem by unconditionally parsing the
> unlinked lists at mount time, but this imposes a mount time cost for
> every filesystem to catch something that should be very infrequent.
> Instead, let's target the places where we can encounter a next_unlinked
> pointer that refers to an inode that is not in cache, and load it into
> cache.
> 
> Note: This patch does not address the problem of iget loading an inode
> from the middle of the iunlink list and needing to set i_prev_unlinked
> correctly.
> 
> Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
> Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: log that we're doing runtime recovery, dont mess with DONTCACHE,
>     and actually return ENOLINK
> ---
>  fs/xfs/xfs_inode.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_trace.h |   25 +++++++++++++++++
>  2 files changed, 96 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6ee266be45d4..2942002560b5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1829,12 +1829,17 @@ xfs_iunlink_lookup(
>  
>  	rcu_read_lock();
>  	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +	if (!ip) {
> +		/* Caller can handle inode not being in memory. */
> +		rcu_read_unlock();
> +		return NULL;
> +	}
>  
>  	/*
> -	 * Inode not in memory or in RCU freeing limbo should not happen.
> -	 * Warn about this and let the caller handle the failure.
> +	 * Inode in RCU freeing limbo should not happen.  Warn about this and
> +	 * let the caller handle the failure.
>  	 */
> -	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
> +	if (WARN_ON_ONCE(!ip->i_ino)) {
>  		rcu_read_unlock();
>  		return NULL;
>  	}
> @@ -1858,7 +1863,8 @@ xfs_iunlink_update_backref(
>  
>  	ip = xfs_iunlink_lookup(pag, next_agino);
>  	if (!ip)
> -		return -EFSCORRUPTED;
> +		return -ENOLINK;
> +
>  	ip->i_prev_unlinked = prev_agino;
>  	return 0;
>  }
> @@ -1902,6 +1908,62 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> +/*
> + * Load the inode @next_agino into the cache and set its prev_unlinked pointer
> + * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
> + * to the unlinked list.
> + */
> +STATIC int
> +xfs_iunlink_reload_next(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agibp,
> +	xfs_agino_t		prev_agino,
> +	xfs_agino_t		next_agino)
> +{
> +	struct xfs_perag	*pag = agibp->b_pag;
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*next_ip = NULL;
> +	xfs_ino_t		ino;
> +	int			error;
> +
> +	ASSERT(next_agino != NULLAGINO);
> +
> +#ifdef DEBUG
> +	rcu_read_lock();
> +	next_ip = radix_tree_lookup(&pag->pag_ici_root, next_agino);
> +	ASSERT(next_ip == NULL);
> +	rcu_read_unlock();
> +#endif
> +
> +	xfs_info_ratelimited(mp,
> + "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating recovery.",
> +			next_agino, pag->pag_agno);
> +
> +	/*
> +	 * Use an untrusted lookup to be cautious in case the AGI has been
> +	 * corrupted and now points at a free inode.  That shouldn't happen,
> +	 * but we'd rather shut down now since we're already running in a weird
> +	 * situation.
> +	 */
> +	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
> +	if (error)
> +		return error;
> +
> +	/* If this is not an unlinked inode, something is very wrong. */
> +	if (VFS_I(next_ip)->i_nlink != 0) {
> +		error = -EFSCORRUPTED;
> +		goto rele;
> +	}
> +
> +	next_ip->i_prev_unlinked = prev_agino;
> +	trace_xfs_iunlink_reload_next(next_ip);
> +rele:
> +	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
> +	xfs_irele(next_ip);
> +	return error;
> +}
> +
>  static int
>  xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> @@ -1933,6 +1995,8 @@ xfs_iunlink_insert_inode(
>  	 * inode.
>  	 */
>  	error = xfs_iunlink_update_backref(pag, agino, next_agino);
> +	if (error == -ENOLINK)
> +		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
>  	if (error)
>  		return error;
>  
> @@ -2027,6 +2091,9 @@ xfs_iunlink_remove_inode(
>  	 */
>  	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
>  			ip->i_next_unlinked);
> +	if (error == -ENOLINK)
> +		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
> +				ip->i_next_unlinked);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 36bd42ed9ec8..f4e46bac9b91 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3832,6 +3832,31 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
>  		  __entry->new_ptr)
>  );
>  
> +TRACE_EVENT(xfs_iunlink_reload_next,
> +	TP_PROTO(struct xfs_inode *ip),
> +	TP_ARGS(ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, agino)
> +		__field(xfs_agino_t, prev_agino)
> +		__field(xfs_agino_t, next_agino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = ip->i_mount->m_super->s_dev;
> +		__entry->agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +		__entry->agino = XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino);
> +		__entry->prev_agino = ip->i_prev_unlinked;
> +		__entry->next_agino = ip->i_next_unlinked;
> +	),
> +	TP_printk("dev %d:%d agno 0x%x agino 0x%x prev_unlinked 0x%x next_unlinked 0x%x",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno,
> +		  __entry->agino,
> +		  __entry->prev_agino,
> +		  __entry->next_agino)
> +);
> +
>  DECLARE_EVENT_CLASS(xfs_ag_inode_class,
>  	TP_PROTO(struct xfs_inode *ip),
>  	TP_ARGS(ip),
> 

