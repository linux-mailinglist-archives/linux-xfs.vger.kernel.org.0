Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF9D286AD6
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Oct 2020 00:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgJGWYV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Oct 2020 18:24:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59024 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbgJGWYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:24:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MOI9g194345;
        Wed, 7 Oct 2020 22:24:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=66SD2lRaSHUSt1IpBkjLLxh6ZbPESBrwm4LqBMg0A88=;
 b=gpoP9iA+m8ydzUQbXEu3SZqyz5rVOc6nn/CZLdCe3ZlAmHY2uEq5nNCsD3PBYLMaPyqS
 oPGMACsT87+Jnx9xj3V1lqeLg7GJuVx0jJOVYgS7TRc9xKp7eDXyBbbtjHbPQag5LszL
 VXKwHJXudtVZCOHA7Fbj5yh9KqdGmFh7lrdNbHWpJyKN/Qeym+rfR/dmj/eTK/7nqUID
 a+invrIw8G3j9I8P3S9OjhAbk2kK955+jyRM8/PdrqsmDZHwMpAY5bdrkfgQ78IcJWDA
 PkwECRc450Xvva9r3naeYBS6zQL4sQf+NvI4zb464tfBgyS4nrxJEFcQfZ8SwVs1/M7g JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetb4uaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:24:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MEsjh159788;
        Wed, 7 Oct 2020 22:24:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3410k06h1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:24:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097MOHP7017587;
        Wed, 7 Oct 2020 22:24:17 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:24:16 -0700
Date:   Wed, 7 Oct 2020 15:24:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rework quotaoff logging to avoid log deadlock
 on active fs
Message-ID: <20201007222416.GG6540@magnolia>
References: <20201001150310.141467-1-bfoster@redhat.com>
 <20201001150310.141467-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001150310.141467-4-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 11:03:10AM -0400, Brian Foster wrote:
> The quotaoff operation logs two log items. The start item is
> committed first, followed by the bulk of the in-core quotaoff
> processing, and then the quotaoff end item is committed to release
> the start item from the log. The problem with this mechanism is that
> quite a bit of processing can be required to release dquots from all
> in-core inodes and subsequently flush/purge all dquots in the
> system. This processing work doesn't generally generate much log
> traffic itself, but the start item pins the tail of the log. If an
> external workload consumes the remaining log space before the
> transaction for the end item is allocated, a log deadlock can occur.
> 
> The purpose of the separate start and end log items is primarily to
> ensure that log recovery does not incorrectly recover dquot data
> after an fs crash where a quotaoff was in progress. If we only
> logged a single quotaoff item, for example, it could fall behind the
> tail of the log before the last dquot modification was made and
> incorrectly replay dquot changes that might have occurred after the
> start item committed but before quotaoff deactivated the quota.
> 
> With that context, we can make some small changes to the quotaoff
> algorithm to provide the same general log ordering guarantee without
> such a large window to create a log deadlock vector. Rather than
> place a start item in the log for the duration of quotaoff
> processing, we can quiesce the transaction subsystem up front to
> guarantee that no further dquots are logged from that point forward.
> IOW, we pause the transaction subsystem, commit the quotaoff start
> and end items, deactivate the associated quota such that subsequent
> transactions no longer modify associated dquots, and resume the
> transaction subsystem. The transaction pause is somewhat of a heavy
> weight operation, but quotaoff is already a rare, slow and
> performance disruptive operation and the quiesce is only required
> for two small transactions.
> 
> Altogether, this means that the dquot rele/purge sequence occurs
> after the quotaoff end item has committed and thus can technically
> fall off the end of the log. This is safe because the remaining
> processing is in-core work that doesn't involve logging dquots and
> we've guaranteed that no further dquots are modified by external
> transactions. This allows quotaoff to complete without risking log
> deadlock regardless of how much dquot processing is required.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c | 133 +++++++++++++++++++--------------------
>  fs/xfs/xfs_trans_dquot.c |   2 +
>  2 files changed, 67 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index ca1b57d291dc..b8e55f4947bd 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -29,7 +29,8 @@ xfs_qm_log_quotaoff(
>  	int			error;
>  	struct xfs_qoff_logitem	*qoffi;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
> +				XFS_TRANS_NO_WRITECOUNT, &tp);
>  	if (error)
>  		goto out;
>  
> @@ -67,7 +68,8 @@ xfs_qm_log_quotaoff_end(
>  	int			error;
>  	struct xfs_qoff_logitem	*qoffi;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0,
> +				XFS_TRANS_NO_WRITECOUNT, &tp);
>  	if (error)
>  		return error;
>  
> @@ -106,8 +108,8 @@ xfs_qm_scall_quotaoff(
>  
>  	/*
>  	 * No file system can have quotas enabled on disk but not in core.
> -	 * Note that quota utilities (like quotaoff) _expect_
> -	 * errno == -EEXIST here.
> +	 * Note that quota utilities (like quotaoff) _expect_ errno == -EEXIST
> +	 * here.
>  	 */
>  	if ((mp->m_qflags & flags) == 0)
>  		return -EEXIST;
> @@ -116,17 +118,14 @@ xfs_qm_scall_quotaoff(
>  	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>  
>  	/*
> -	 * We don't want to deal with two quotaoffs messing up each other,
> -	 * so we're going to serialize it. quotaoff isn't exactly a performance
> +	 * We don't want to deal with two quotaoffs messing up each other, so
> +	 * we're going to serialize it. quotaoff isn't exactly a performance
>  	 * critical thing.
> -	 * If quotaoff, then we must be dealing with the root filesystem.
>  	 */
>  	ASSERT(q);
>  	mutex_lock(&q->qi_quotaofflock);
>  
> -	/*
> -	 * If we're just turning off quota enforcement, change mp and go.
> -	 */
> +	/* if we're just turning off quota enforcement, change mp and go */
>  	if ((flags & XFS_ALL_QUOTA_ACCT) == 0) {
>  		mp->m_qflags &= ~(flags);
>  
> @@ -142,9 +141,9 @@ xfs_qm_scall_quotaoff(
>  	dqtype = 0;
>  	inactivate_flags = 0;
>  	/*
> -	 * If accounting is off, we must turn enforcement off, clear the
> -	 * quota 'CHKD' certificate to make it known that we have to
> -	 * do a quotacheck the next time this quota is turned on.
> +	 * If accounting is off, we must turn enforcement off, clear the quota
> +	 * 'CHKD' certificate to make it known that we have to do a quotacheck
> +	 * the next time this quota is turned on.
>  	 */
>  	if (flags & XFS_UQUOTA_ACCT) {
>  		dqtype |= XFS_QMOPT_UQUOTA;
> @@ -163,89 +162,87 @@ xfs_qm_scall_quotaoff(
>  	}
>  
>  	/*
> -	 * Nothing to do?  Don't complain. This happens when we're just
> -	 * turning off quota enforcement.
> +	 * Nothing to do? Don't complain. This happens when we're just turning
> +	 * off quota enforcement.
>  	 */
>  	if ((mp->m_qflags & flags) == 0)
>  		goto out_unlock;
>  
>  	/*
> -	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
> -	 * and synchronously. If we fail to write, we should abort the
> -	 * operation as it cannot be recovered safely if we crash.
> +	 * Quotaoff must deactivate the associated quota mode(s), release dquots
> +	 * from inodes and purge them from the system all while the filesystem
> +	 * remains active. We have two quotaoff log records that traditionally
> +	 * bound the start and end of this sequence. This guarantees that no
> +	 * dquots are modified after the end item hits the log, but quotaoff can
> +	 * be time consuming and thus prone to deadlock because the start item
> +	 * pins the tail the of log in the meantime (and we can't hold the end
> +	 * transaction open across the dqrele scan).
> +	 *
> +	 * The critical aspect of correctly logging quotaoff is that no dquots
> +	 * are modified after the quotaoff end item hits the on-disk log.
> +	 * Otherwise the quotaoff can fall off the tail and log recovery can
> +	 * replay incorrect data. Instead of letting the start item sit in the
> +	 * log while quotaoff completes, we can provide the same guarantee via a
> +	 * runtime barrier for dquot modifications. Specifically, we pause all
> +	 * transactions on the system via the transaction subsystem lock, log
> +	 * both start and end items (via sync transactions, which drains the
> +	 * CIL), deactivate the quota, and then resume the transaction subsystem
> +	 * while quotaoff completes.
> +	 *
> +	 * This is safe because the remaining quotaoff work is in-core cleanup
> +	 * and all subsequent transactions should see the updated quota state
> +	 * due to memory ordering provided by the lock. We also avoid deadlock
> +	 * by committing both items sequentially with near exclusive access to
> +	 * the transaction subsystem.
>  	 */
> +	percpu_down_write(&mp->m_trans_rwsem);
> +
>  	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
> -	if (error)
> +	if (error) {
> +		percpu_up_write(&mp->m_trans_rwsem);
>  		goto out_unlock;
> +	}
>  
> -	/*
> -	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
> -	 * to take care of the race between dqget and quotaoff. We don't take
> -	 * any special locks to reset these bits. All processes need to check
> -	 * these bits *after* taking inode lock(s) to see if the particular
> -	 * quota type is in the process of being turned off. If *ACTIVE, it is
> -	 * guaranteed that all dquot structures and all quotainode ptrs will all
> -	 * stay valid as long as that inode is kept locked.
> -	 *
> -	 * There is no turning back after this.
> -	 */
>  	mp->m_qflags &= ~inactivate_flags;
>  
> +	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> +	if (error) {
> +		percpu_up_write(&mp->m_trans_rwsem);
> +		/* We're screwed now. Shutdown is the only option. */
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		goto out_unlock;
> +	}
> +
> +	percpu_up_write(&mp->m_trans_rwsem);

Hmm, so if I read this correctly, you're changing what gets written to
the log from:

	<quotaoff intent>
	<transactions that maybe log dquots but we don't care>
	...now the qflags get cleared...
	<transactions that maybe log dquots but we don't care>
	...run around purging dquots...
	<transactions that maybe log dquots but we don't care>
	<quotaoff done>

to something that looks more like:

	<transactions that log dquots>
	<quotaoff intent, all other transactions locked out>
	...now the qflags get cleared; no other transactions...
	<quotaoff done, turn off the lockout>
	<transactions that wont log dquots>
	...run around purging dquots...

Is that right?  I guess that makes sense, though it's sort of a pity
that we now make every transaction grab a read lock.  Though I guess
there's not much that can be done about that; it's better than pinning
the log tail.  I don't even think there's a good way to relog that
quotaoff-intent item, is there?  Since you'd have to, I dunno, do all
the checks that xfs_defer_relog() does to decide if it should relog an
intent item?

--D

> +
>  	/*
> -	 * Give back all the dquot reference(s) held by inodes.
> -	 * Here we go thru every single incore inode in this file system, and
> -	 * do a dqrele on the i_udquot/i_gdquot that it may have.
> -	 * Essentially, as long as somebody has an inode locked, this guarantees
> -	 * that quotas will not be turned off. This is handy because in a
> -	 * transaction once we lock the inode(s) and check for quotaon, we can
> -	 * depend on the quota inodes (and other things) being valid as long as
> -	 * we keep the lock(s).
> +	 * Release dquot references held by inodes. Technically some contexts
> +	 * might not pick up the quota state change until the inode lock is
> +	 * cycled if there is no transaction. We don't care about that above
> +	 * because a dquot can't be logged without a transaction and we can't
> +	 * release/purge a dquot here until we've cycled the locks of all inodes
> +	 * that reference it.
>  	 */
>  	xfs_qm_dqrele_all_inodes(mp, flags);
>  
>  	/*
>  	 * Next we make the changes in the quota flag in the mount struct.
> -	 * This isn't protected by a particular lock directly, because we
> -	 * don't want to take a mrlock every time we depend on quotas being on.
> +	 * This isn't protected by a particular lock directly, because we don't
> +	 * want to take a mrlock every time we depend on quotas being on.
>  	 */
>  	mp->m_qflags &= ~flags;
>  
> -	/*
> -	 * Go through all the dquots of this file system and purge them,
> -	 * according to what was turned off.
> -	 */
> +	/* purge all deactivated dquots from the filesystem */
>  	xfs_qm_dqpurge_all(mp, dqtype);
>  
> -	/*
> -	 * Transactions that had started before ACTIVE state bit was cleared
> -	 * could have logged many dquots, so they'd have higher LSNs than
> -	 * the first QUOTAOFF log record does. If we happen to crash when
> -	 * the tail of the log has gone past the QUOTAOFF record, but
> -	 * before the last dquot modification, those dquots __will__
> -	 * recover, and that's not good.
> -	 *
> -	 * So, we have QUOTAOFF start and end logitems; the start
> -	 * logitem won't get overwritten until the end logitem appears...
> -	 */
> -	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> -	if (error) {
> -		/* We're screwed now. Shutdown is the only option. */
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		goto out_unlock;
> -	}
> -
> -	/*
> -	 * If all quotas are completely turned off, close shop.
> -	 */
> +	/* if all quotas are completely turned off, close shop */
>  	if (mp->m_qflags == 0) {
>  		mutex_unlock(&q->qi_quotaofflock);
>  		xfs_qm_destroy_quotainfo(mp);
>  		return 0;
>  	}
>  
> -	/*
> -	 * Release our quotainode references if we don't need them anymore.
> -	 */
> +	/* release our quotainode references if we don't need them anymore */
>  	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
>  		xfs_irele(q->qi_uquotaip);
>  		q->qi_uquotaip = NULL;
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 547ba824542e..9839b83e732a 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -52,6 +52,8 @@ xfs_trans_log_dquot(
>  	struct xfs_dquot	*dqp)
>  {
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
> +	/* quotaoff expects no dquots logged after deactivation */
> +	ASSERT(xfs_this_quota_on(tp->t_mountp, xfs_dquot_type(dqp)));
>  
>  	/* Upgrade the dquot to bigtime format if possible. */
>  	if (dqp->q_id != 0 &&
> -- 
> 2.25.4
> 
