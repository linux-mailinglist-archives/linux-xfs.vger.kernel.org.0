Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D1C8A345
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfHLQ1I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:27:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfHLQ1I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:27:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGO7n2159558
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bEbLcdPAGW7exabXqBx5zRCJqG3MK6Z9DFO4jhpjkuo=;
 b=Akx7e70jowxaSNzUh0QXZf4Gh2OW6id6Skh2Ifqxt+geSvRBmoq5vLTF9B62YrHEBRqV
 zidgVESnsgy+VnGIKfm7VryotG6y+Kj9OvVDTMWkp6bpSkcEjojNamKFrPX1WDrIaxUe
 BzmOrEPfDrxln+/OdjZO14PIvmPHOdsF0QPuSFef3uouq62CBlEgUjXrHC9RP1Zm3tQH
 ZsQJYyU6/Z3qS1fdMaAji1VKQ1gs3b67qfVTXKySgmJm3Ys7NGqeXzTPW9xp2kfQL+uQ
 +Aj9MIYdgS+xDa1AVEgRFJ6xCNoJIKRjlZyPth4CzOLCzR8jxOgg5f846OJTdisrVO9d WA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=bEbLcdPAGW7exabXqBx5zRCJqG3MK6Z9DFO4jhpjkuo=;
 b=lZ+34yhUuImCe/EIhopZiMNizswYi2qphSTr/m8NYmYvNgX42wX1VIuN0OEdPrEJ4zXC
 oB2N0UZVTgnXKoWgjR91t9uiDLh/rSVJbTL7sXtHRavq9E+1AGMq6V/ffg1HdPW8u3C/
 HTwjgiazl572u5ZOU/KEv8/QiBwSxrdjtRQ5FeIAKi3rvQ2uIH76JBIvVM0wMpPjS0Pl
 zBCKofoH9Cg7C22Y+mzBRE97C6od82OTLPMNjCmo/VbPy2QCwfoX/awdf9XH3prMZ2eW
 mtlAe+iEJ28U354UgdT4Xpu8A9WynxfAl0UZQl4kB1m1yhAaRxPv1P7k4esrqh9NAOde YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjq8p58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:27:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGN5xS118732
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:27:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u9nre20ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:27:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGR5LT021457
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:27:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:27:04 -0700
Date:   Mon, 12 Aug 2019 09:27:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 12/18] xfs: Factor out xfs_attr_rmtval_remove_value
Message-ID: <20190812162704.GA7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-13-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:20PM -0700, Allison Collins wrote:
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_rmtval_remove that we can use.  This will help to
> reduce repetitive code later when we introduce delayed
> attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++------
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index c421412..f030365 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -586,19 +586,14 @@ xfs_attr_rmtval_set_value(
>  	return 0;
>  }
>  
> -/*
> - * Remove the value associated with an attribute by deleting the
> - * out-of-line buffer that it is stored on.
> - */
>  int
> -xfs_attr_rmtval_remove(
> +xfs_attr_rmtval_remove_value(

This function invalidates the incore buffers, right?  Since _remove
below still does the actual bunmapi work to unmap blocks from the attr
fork?  Would this be better named xfs_attr_rmtval_invalidate()?

>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_mount	*mp = args->dp->i_mount;
>  	xfs_dablk_t		lblkno;
>  	int			blkcnt;
>  	int			error;
> -	int			done;
>  
>  	trace_xfs_attr_rmtval_remove(args);

Leave this in xfs_attr_rmtval_remove.

--D

>  
> @@ -642,7 +637,25 @@ xfs_attr_rmtval_remove(
>  		lblkno += map.br_blockcount;
>  		blkcnt -= map.br_blockcount;
>  	}
> +	return 0;
> +}
>  
> +/*
> + * Remove the value associated with an attribute by deleting the
> + * out-of-line buffer that it is stored on.
> + */
> +int
> +xfs_attr_rmtval_remove(
> +	struct xfs_da_args      *args)
> +{
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +	int			error = 0;
> +	int			done = 0;
> +
> +	error = xfs_attr_rmtval_remove_value(args);
> +	if (error)
> +		return error;
>  	/*
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 2a73cd9..9a58a23 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> +int xfs_attr_rmtval_remove_value(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>  int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
>  			   xfs_fileoff_t *lfileoff);
> -- 
> 2.7.4
> 
