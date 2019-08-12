Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75EBE8A353
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbfHLQ2q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:28:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50100 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfHLQ2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:28:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGSdAl177018
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DY/s2VXbD72pDL9KFPhO6HVSkfXZv5fdUJHOHnmy5lY=;
 b=gUULIH9grVtjAQ2D+PTEkw5lccRkGBW+CL1a4O1G+eMroqKCWDT5C3AJQgBd0R3gQeou
 RgdoPwi9NzXvhkJWLcy7DAtFy7YEmbI+06OP1qWDtqGOLYjKqLfbsPQhhbxZwNjwN36Q
 wcQS/ElQrpG9RbRVfLhg+WF1jP+WiEibke0g3/MpeRSyPxM6lUXvAS9rLu5k5ukQjh9D
 nJcv+x09PyMl20ATJPKLTPHbPleb1AeL63+GKclOoDdgbCI2N9o0RM+9E0UUPaZFEacn
 lBLDphFvmFNlTT2hIbLCgFFYSkEfCfZSDtVwSXWSiWYg3x9YDOe/8k+ffGnca3AqVU3C kA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=DY/s2VXbD72pDL9KFPhO6HVSkfXZv5fdUJHOHnmy5lY=;
 b=M/qMEDbAJ6XLcARu4Kodx0B0WBTf9tCFQtf+sdDZV0Hxds9/y3lu5Ib2CPhTu5qBN1sT
 FvtArqsRTXc4oAuGCDp7QimJYQkR4qQulG+/S078X9ZjIjXLmENZ1QLMzPF02ytyYj4R
 mbLVt2WW6Moa4f8CI04JndIa/HTrSlCoi6NW52pimv03ZpKhEw7nhcV7INsohpXsYXCd
 LDEaD1fgOFGKiAkGFFk8fVk0h0lbEhdmVLDnqPTCEuvH7sFp7l+AjKQHd7dLcf9aaw0/
 ylbZ5C/jeDpimIUGXEszpDLiFuXyUPMqyYZkFQAdVrkINTJko65IIx/kGzbdwHYgJGa+ 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp0sng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGRwIN131000
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nre2237-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGSiKR017400
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:28:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:28:43 -0700
Date:   Mon, 12 Aug 2019 09:28:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 13/18] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
Message-ID: <20190812162842.GB7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-14-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:21PM -0700, Allison Collins wrote:
> New delayed allocation routines cannot be handling
> transactions so factor them up into the calling functions
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7648ceb..ca57202 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -823,6 +823,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>  		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
>  		error = xfs_attr3_leaf_clearflag(args);
> +
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	return error;
>  }
> @@ -1180,6 +1186,12 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  		if (error)
>  			goto out;
> +
> +		 /*
> +		  * Commit the flag value change and start the next trans in
> +		  * series.
> +		  */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	retval = error = 0;

Doesn't this cause us to lose the error code from the roll_inode above?

--D

>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b2d5f62..e3604b9 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2722,10 +2722,7 @@ xfs_attr3_leaf_clearflag(
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;
>  }
>  
>  /*
> -- 
> 2.7.4
> 
