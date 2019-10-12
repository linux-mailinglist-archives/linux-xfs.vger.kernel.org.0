Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49189D4B74
	for <lists+linux-xfs@lfdr.de>; Sat, 12 Oct 2019 02:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfJLAlw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Oct 2019 20:41:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33498 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfJLAlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 20:41:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0VAfj085482;
        Sat, 12 Oct 2019 00:41:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=/kE/rJ7I2+tIjUHREygFSDDFahThUtSxlzG9kTvwWO4=;
 b=ZTlkux1OAwzKbmhpEwOU9RHcT2XIi0gwKAJ4v39US18xkudy8zldHK4KYQkc65gnQ6mh
 q3rH8SXugoC4GE3qu+bNZc3zwWM7/9+IZ3fuWV+z9iuyBJB1iybQ//Cum2RUT4oVIYwd
 jyHPZYtDp0uQJW9jIxJseIOVdyAwchdlrpwws/Z0lHRj9V6JTv566ITPxZdFYPnPNZX/
 P8+gEoKWHvrqvH01AQp5keo+WAgrnQEp4FYb6XkaffIew9kBXbQK9UIn/N0meOjvTkCN
 ItmHZTyLPZuIX4mnYeIpuJl2DPsCaFQOQ101PasL7o0K9NHjI8FCYxSwT0hhb0hW4yD0 MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4r4kw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:41:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0TQGh152144;
        Sat, 12 Oct 2019 00:41:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vk3xvhfcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:41:47 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9C0fkpS011724;
        Sat, 12 Oct 2019 00:41:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Oct 2019 17:41:46 -0700
Date:   Fri, 11 Oct 2019 17:41:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: remove the XLOG_STATE_DO_CALLBACK state
Message-ID: <20191012004145.GP13108@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-9-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910120001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910120001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:48PM +0200, Christoph Hellwig wrote:
> XLOG_STATE_DO_CALLBACK is only entered through XLOG_STATE_DONE_SYNC
> and just used in a single debug check.  Remove the flag and thus
> simplify the calling conventions for xlog_state_do_callback and
> xlog_state_iodone_process_iclog.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 76 +++++++------------------------------------
>  fs/xfs/xfs_log_priv.h |  1 -
>  2 files changed, 11 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 001a9586cb56..d158b6d56a26 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2750,7 +2750,6 @@ static bool
>  xlog_state_iodone_process_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog,
> -	struct xlog_in_core	*completed_iclog,
>  	bool			*ioerror)
>  {
>  	xfs_lsn_t		lowest_lsn;
> @@ -2768,17 +2767,16 @@ xlog_state_iodone_process_iclog(
>  		 * Between marking a filesystem SHUTDOWN and stopping the log,
>  		 * we do flush all iclogs to disk (if there wasn't a log I/O
>  		 * error). So, we do want things to go smoothly in case of just
> -		 * a SHUTDOWN  w/o a LOG_IO_ERROR.
> +		 * a SHUTDOWN w/o a LOG_IO_ERROR.
>  		 */
>  		*ioerror = true;
>  		return false;
>  	case XLOG_STATE_DONE_SYNC:
> -	case XLOG_STATE_DO_CALLBACK:
>  		/*
> -		 * Now that we have an iclog that is in either the DO_CALLBACK
> -		 * or DONE_SYNC states, do one more check here to see if we have
> -		 * chased our tail around.  If this is not the lowest lsn iclog,
> -		 * then we will leave it for another completion to process.
> +		 * Now that we have an iclog that is in the DONE_SYNC state, do
> +		 * one more check here to see if we have chased our tail around.
> +		 * If this is not the lowest lsn iclog, then we will leave it
> +		 * for another completion to process.
>  		 */
>  		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  		lowest_lsn = xlog_get_lowest_lsn(log);
> @@ -2789,15 +2787,9 @@ xlog_state_iodone_process_iclog(
>  	default:
>  		/*
>  		 * Can only perform callbacks in order.  Since this iclog is not
> -		 * in the DONE_SYNC or DO_CALLBACK states, we skip the rest and
> -		 * just try to clean up.  If we set our iclog to DO_CALLBACK, we
> -		 * will not process it when we retry since a previous iclog is
> -		 * in the CALLBACK and the state cannot change since we are
> -		 * holding l_icloglock.
> +		 * in the DONE_SYNC state, we skip the rest and just try to
> +		 * clean up.
>  		 */
> -		if (completed_iclog &&
> -		    (completed_iclog->ic_state == XLOG_STATE_DONE_SYNC))
> -			completed_iclog->ic_state = XLOG_STATE_DO_CALLBACK;
>  		return true;
>  	}
>  }
> @@ -2838,54 +2830,13 @@ xlog_state_do_iclog_callbacks(
>  	spin_unlock(&iclog->ic_callback_lock);
>  }
>  
> -#ifdef DEBUG
> -/*
> - * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
> - * above loop finds an iclog earlier than the current iclog and in one of the
> - * syncing states, the current iclog is put into DO_CALLBACK and the callbacks
> - * are deferred to the completion of the earlier iclog. Walk the iclogs in order
> - * and make sure that no iclog is in DO_CALLBACK unless an earlier iclog is in
> - * one of the syncing states.
> - */
> -static void
> -xlog_state_callback_check_state(
> -	struct xlog		*log)
> -{
> -	struct xlog_in_core	*first_iclog = log->l_iclog;
> -	struct xlog_in_core	*iclog = first_iclog;
> -
> -	do {
> -		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
> -		/*
> -		 * Terminate the loop if iclogs are found in states
> -		 * which will cause other threads to clean up iclogs.
> -		 *
> -		 * SYNCING - i/o completion will go through logs
> -		 * DONE_SYNC - interrupt thread should be waiting for
> -		 *              l_icloglock
> -		 * IOERROR - give up hope all ye who enter here
> -		 */
> -		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		    iclog->ic_state == XLOG_STATE_SYNCING ||
> -		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
> -		    iclog->ic_state == XLOG_STATE_IOERROR )
> -			break;
> -		iclog = iclog->ic_next;
> -	} while (first_iclog != iclog);
> -}
> -#else
> -#define xlog_state_callback_check_state(l)	((void)0)
> -#endif

So, uh... does this debugging functionality just disappear?  Is it
unnecessary?  It's not clear (to me anyway) why it's ok for the extra
checking to go away.

--D

> -
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log,
> -	bool			aborted,
> -	struct xlog_in_core	*ciclog)
> +	bool			aborted)
>  {
>  	struct xlog_in_core	*iclog;
>  	struct xlog_in_core	*first_iclog;
> -	bool			did_callbacks = false;
>  	bool			cycled_icloglock;
>  	bool			ioerror;
>  	int			flushcnt = 0;
> @@ -2909,7 +2860,7 @@ xlog_state_do_callback(
>  
>  		do {
>  			if (xlog_state_iodone_process_iclog(log, iclog,
> -							ciclog, &ioerror))
> +							&ioerror))
>  				break;
>  
>  			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
> @@ -2929,8 +2880,6 @@ xlog_state_do_callback(
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
>  
> -		did_callbacks |= cycled_icloglock;
> -
>  		if (repeats > 5000) {
>  			flushcnt += repeats;
>  			repeats = 0;
> @@ -2940,9 +2889,6 @@ xlog_state_do_callback(
>  		}
>  	} while (!ioerror && cycled_icloglock);
>  
> -	if (did_callbacks)
> -		xlog_state_callback_check_state(log);
> -
>  	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
>  	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
>  		wake_up_all(&log->l_flush_wait);
> @@ -2993,7 +2939,7 @@ xlog_state_done_syncing(
>  	 */
>  	wake_up_all(&iclog->ic_write_wait);
>  	spin_unlock(&log->l_icloglock);
> -	xlog_state_do_callback(log, aborted, iclog);	/* also cleans log */
> +	xlog_state_do_callback(log, aborted);	/* also cleans log */
>  }	/* xlog_state_done_syncing */
>  
>  
> @@ -3987,7 +3933,7 @@ xfs_log_force_umount(
>  	spin_lock(&log->l_cilp->xc_push_lock);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
>  	spin_unlock(&log->l_cilp->xc_push_lock);
> -	xlog_state_do_callback(log, true, NULL);
> +	xlog_state_do_callback(log, true);
>  
>  	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index bf076893f516..4f19375f6592 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -45,7 +45,6 @@ enum xlog_iclog_state {
>  	XLOG_STATE_WANT_SYNC,	/* Want to sync this iclog; no more writes */
>  	XLOG_STATE_SYNCING,	/* This IC log is syncing */
>  	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
> -	XLOG_STATE_DO_CALLBACK,	/* Process callback functions */
>  	XLOG_STATE_CALLBACK,	/* Callback functions now */
>  	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
>  	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
> -- 
> 2.20.1
> 
