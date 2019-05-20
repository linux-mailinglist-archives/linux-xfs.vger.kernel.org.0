Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368A624358
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfETWIx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:08:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47592 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfETWIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:08:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KLsYsI083835;
        Mon, 20 May 2019 22:08:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ZbM5E+MuSl6+25kPMx2bHc9nUaUh2AgbiUgxSfvzuO4=;
 b=MAZ4QiE12CChcr0HY8A52dw+EZ++EScmuEMFEKJdSLG9DyQVCDGD87qBKpSybSj+OkrK
 GOfnmOhNzB4qy5drxxtivJgHwVV6DMmoi6e1HvVcV9dyhys+Ua1irvV6E5YlUneKJAyP
 v2m8hZ5zOEUqIbWgKdRKLY7wqPXCryQhUOVTaDGjVmYs4Hdq7U6Ec1n8El2bvsBTU7xC
 xJCPoOlnHpEO1p8AGYLCnPTuYfJGGyeWX6vIwhc3CaTnwnkbGSImj5WAwkoTDP9lzAVt
 8LMpQ/TttxyG94rjSFX0oId8OqtpHvrR5DawQBOyG1Pq3j65IflfpL4RHAkBeIDg2/ps /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sj9ft9tjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:08:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KM7cVb129026;
        Mon, 20 May 2019 22:08:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sks1j3jsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:08:46 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KM8jcZ011986;
        Mon, 20 May 2019 22:08:45 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:08:45 +0000
Date:   Mon, 20 May 2019 15:08:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
Message-ID: <20190520220844.GD5335@magnolia>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200136
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:01AM +0200, Christoph Hellwig wrote:
> Just pass a straight bool aborted instead of abusing XFS_LI_ABORTED as a
> flag in function parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 25 +++++++++++--------------
>  fs/xfs/xfs_log.h     |  2 +-
>  fs/xfs/xfs_log_cil.c |  4 ++--
>  3 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 457ced3ee3e1..1eb0938165fc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -54,12 +54,9 @@ xlog_dealloc_log(
>  	struct xlog		*log);
>  
>  /* local state machine functions */
> -STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
> -STATIC void
> -xlog_state_do_callback(
> -	struct xlog		*log,
> -	int			aborted,
> -	struct xlog_in_core	*iclog);
> +STATIC void xlog_state_done_syncing(
> +	struct xlog_in_core	*iclog,
> +	bool			aborted);

I totally mistook this for a function definition. :/

STATIC void xlog_state_done_syncing(struct xlog_in_core *iclog, bool aborted);

...seems to fit on one line, right?

--D

>  STATIC int
>  xlog_state_get_iclog_space(
>  	struct xlog		*log,
> @@ -1255,7 +1252,7 @@ xlog_iodone(xfs_buf_t *bp)
>  {
>  	struct xlog_in_core	*iclog = bp->b_log_item;
>  	struct xlog		*l = iclog->ic_log;
> -	int			aborted = 0;
> +	bool			aborted = false;
>  
>  	/*
>  	 * Race to shutdown the filesystem if we see an error or the iclog is in
> @@ -1275,9 +1272,9 @@ xlog_iodone(xfs_buf_t *bp)
>  		 * callback routines to let them know that the log-commit
>  		 * didn't succeed.
>  		 */
> -		aborted = XFS_LI_ABORTED;
> +		aborted = true;
>  	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
> -		aborted = XFS_LI_ABORTED;
> +		aborted = true;
>  	}
>  
>  	/* log I/O is always issued ASYNC */
> @@ -2697,7 +2694,7 @@ xlog_get_lowest_lsn(
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log,
> -	int			aborted,
> +	bool			aborted,
>  	struct xlog_in_core	*ciclog)
>  {
>  	xlog_in_core_t	   *iclog;
> @@ -2936,10 +2933,10 @@ xlog_state_do_callback(
>   */
>  STATIC void
>  xlog_state_done_syncing(
> -	xlog_in_core_t	*iclog,
> -	int		aborted)
> +	struct xlog_in_core	*iclog,
> +	bool			aborted)
>  {
> -	struct xlog	   *log = iclog->ic_log;
> +	struct xlog		*log = iclog->ic_log;
>  
>  	spin_lock(&log->l_icloglock);
>  
> @@ -4026,7 +4023,7 @@ xfs_log_force_umount(
>  	 * avoid races.
>  	 */
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
> -	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
> +	xlog_state_do_callback(log, true, NULL);
>  
>  #ifdef XFSERRORDEBUG
>  	{
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 73a64bf32f6f..4450a2a26a1a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -77,7 +77,7 @@ xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>   */
>  typedef struct xfs_log_callback {
>  	struct xfs_log_callback	*cb_next;
> -	void			(*cb_func)(void *, int);
> +	void			(*cb_func)(void *, bool);
>  	void			*cb_arg;
>  } xfs_log_callback_t;
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5e595948bc5a..1b54002d3874 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -577,7 +577,7 @@ xlog_discard_busy_extents(
>  static void
>  xlog_cil_committed(
>  	void	*args,
> -	int	abort)
> +	bool	abort)
>  {
>  	struct xfs_cil_ctx	*ctx = args;
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> @@ -864,7 +864,7 @@ xlog_cil_push(
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
> -	xlog_cil_committed(ctx, XFS_LI_ABORTED);
> +	xlog_cil_committed(ctx, true);
>  	return -EIO;
>  }
>  
> -- 
> 2.20.1
> 
