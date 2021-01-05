Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12092EA4E6
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Jan 2021 06:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbhAEFcK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Jan 2021 00:32:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55094 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbhAEFcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 00:32:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1055PulM098603
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CXtn5JQbg4EA2AxRUipZXdnHaB86UIOXrR48Y3EX0k0=;
 b=hA2rQ5TwqKuFrIA6vQb9EN45ZR6fKEmQC9OFgHAWuF8NQKgakazM6sjAJxIQ/uRJYRDS
 1FCk2rBw8tVI6aia1bs+IJFq5+4if1lX8ZxF+rEtL6JnzuzdUbrDS/lAE3L7+TQI32cL
 FqM2pgd+U1zp24RSFBJLqItrpP0lPVjNZP8mZnV1tnBSsYJMIDfg7gmse3Y/ZG+i4kXT
 EuqknmyR+A0RPNF5wzMC3+6K5GgBZfIjpwlZqHl6Wn6Xrq5DvxgeiocQGmRQoyR4z5ma
 KdoVkQHq9Uc/lRvHftx5mdIfI7lwTBWdxI53GlnOW34Qsn+eyZugrsvu3AVrglsLDBjU Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35tgskq8kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 05:31:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1055VPDn101439
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:31:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35uxns5ht3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jan 2021 05:31:24 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1055S8MZ016047
        for <linux-xfs@vger.kernel.org>; Tue, 5 Jan 2021 05:28:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Jan 2021 21:28:07 -0800
Date:   Mon, 4 Jan 2021 21:28:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 06/15] xfs: Add state machine tracepoints
Message-ID: <20210105052807.GT6918@magnolia>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218072917.16805-7-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050033
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 18, 2020 at 12:29:08AM -0700, Allison Henderson wrote:
> This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
> use this to track when ever a new state is set or -EAGAIN is returned
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 22 +++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |  1 +
>  fs/xfs/xfs_trace.h              | 20 ++++++++++++++++++++
>  3 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index cd72512..8ed00bc 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -263,6 +263,7 @@ xfs_attr_set_shortform(
>  	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
>  	 * fork to leaf format and will restart with the leaf add.
>  	 */
> +	trace_xfs_das_state_return(XFS_DAS_UNINIT);

It would help to record the inode number in the trace data.  When
someone encounters an xattr problem involving things like fsstress,
it'll be /much/ easier to disentangle who's doing what.

>  	return -EAGAIN;
>  }
>  
> @@ -409,9 +410,11 @@ xfs_attr_set_iter(
>  		 * down into the node handling code below
>  		 */
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return -EAGAIN;
>  	case 0:
>  		dac->dela_state = XFS_DAS_FOUND_LBLK;
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return -EAGAIN;
>  	}
>  	return error;
> @@ -841,6 +844,7 @@ xfs_attr_leaf_addname(
>  			return error;
>  
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_das_state_return(dac->dela_state);

Also, please consider capturing more info about /which/ of these
xfs_das_state_return tracepoints fired, either by introducing more
variants (e.g. xfs_attr_leaf_addname_das_return) or by feeding
__this_address into the trace "call" and printing it in the TP_printk
output (formatting string '%pS').

Each declared tracepoint /does/ have a permanent memory cost, so I would
think hard about trying #2...

--D

>  		return -EAGAIN;
>  	}
>  
> @@ -874,6 +878,7 @@ xfs_attr_leaf_addname(
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
>  	dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +	trace_xfs_das_state_return(dac->dela_state);
>  	return -EAGAIN;
>  das_flip_flag:
>  	/*
> @@ -891,6 +896,8 @@ xfs_attr_leaf_addname(
>  das_rm_lblk:
>  	if (args->rmtblkno) {
>  		error = __xfs_attr_rmtval_remove(dac);
> +		if (error == -EAGAIN)
> +			trace_xfs_das_state_return(dac->dela_state);
>  		if (error)
>  			return error;
>  	}
> @@ -1142,6 +1149,7 @@ xfs_attr_node_addname(
>  			 * this point.
>  			 */
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			trace_xfs_das_state_return(dac->dela_state);
>  			return -EAGAIN;
>  		}
>  
> @@ -1175,6 +1183,7 @@ xfs_attr_node_addname(
>  	state = NULL;
>  
>  	dac->dela_state = XFS_DAS_FOUND_NBLK;
> +	trace_xfs_das_state_return(dac->dela_state);
>  	return -EAGAIN;
>  das_found_nblk:
>  
> @@ -1202,6 +1211,7 @@ xfs_attr_node_addname(
>  				return error;
>  
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			trace_xfs_das_state_return(dac->dela_state);
>  			return -EAGAIN;
>  		}
>  
> @@ -1236,6 +1246,7 @@ xfs_attr_node_addname(
>  	 * Commit the flag value change and start the next trans in series
>  	 */
>  	dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +	trace_xfs_das_state_return(dac->dela_state);
>  	return -EAGAIN;
>  das_flip_flag:
>  	/*
> @@ -1253,6 +1264,10 @@ xfs_attr_node_addname(
>  das_rm_nblk:
>  	if (args->rmtblkno) {
>  		error = __xfs_attr_rmtval_remove(dac);
> +
> +		if (error == -EAGAIN)
> +			trace_xfs_das_state_return(dac->dela_state);
> +
>  		if (error)
>  			return error;
>  	}
> @@ -1396,6 +1411,8 @@ xfs_attr_node_remove_rmt (
>  	 * May return -EAGAIN to request that the caller recall this function
>  	 */
>  	error = __xfs_attr_rmtval_remove(dac);
> +	if (error == -EAGAIN)
> +		trace_xfs_das_state_return(dac->dela_state);
>  	if (error)
>  		return error;
>  
> @@ -1514,6 +1531,7 @@ xfs_attr_node_removename_iter(
>  
>  			dac->flags |= XFS_DAC_DEFER_FINISH;
>  			dac->dela_state = XFS_DAS_RM_SHRINK;
> +			trace_xfs_das_state_return(dac->dela_state);
>  			return -EAGAIN;
>  		}
>  
> @@ -1532,8 +1550,10 @@ xfs_attr_node_removename_iter(
>  		goto out;
>  	}
>  
> -	if (error == -EAGAIN)
> +	if (error == -EAGAIN) {
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return error;
> +	}
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 6af86bf..4840de9 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -763,6 +763,7 @@ __xfs_attr_rmtval_remove(
>  	 */
>  	if (!done) {
>  		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		trace_xfs_das_state_return(dac->dela_state);
>  		return -EAGAIN;
>  	}
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9074b8b..4f6939b4 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3887,6 +3887,26 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
>  DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
>  DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
>  
> +
> +DECLARE_EVENT_CLASS(xfs_das_state_class,
> +	TP_PROTO(int das),
> +	TP_ARGS(das),
> +	TP_STRUCT__entry(
> +		__field(int, das)
> +	),
> +	TP_fast_assign(
> +		__entry->das = das;
> +	),
> +	TP_printk("state change %d",
> +		  __entry->das)
> +)
> +
> +#define DEFINE_DAS_STATE_EVENT(name) \
> +DEFINE_EVENT(xfs_das_state_class, name, \
> +	TP_PROTO(int das), \
> +	TP_ARGS(das))
> +DEFINE_DAS_STATE_EVENT(xfs_das_state_return);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.7.4
> 
