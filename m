Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029588A31B
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfHLQOY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:14:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38344 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLQOY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:14:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGEHEi137502
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7IWAvFGmHrNZghs1GfBUTB8yxG/e1eNYylZOuKJHQOU=;
 b=CZCLEyeIlq/0kuKhUXuUYOmK6SeyjR0NJViXu0t0GahJWGczuXxYssWVd0JpHxbONFzE
 JKjdnXb13hZTvBFMYV8ke0/5sem9ayIZtNhTwknlGhfTV1xmOg9/eNf1F87n+AtfRc1p
 WsE9Cj7UXcqSyUQOLy728LRjUQvQmuDJdhPh6DYEn2elHE3Ka7eL2LhNoL5OaumCdCJ5
 byQ5sP65aT11hFGy0s9wPLYUHgZhCNDGVaPH1pqUsIpb+UlolHRvOongbqDVdadeO1up
 XEpBhSIGgG8H8HAOMRiuAo+YPSUrHfwTnOa9BlTz00lgTWgJHQd6RiNOaDmozy2vUP2M aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=7IWAvFGmHrNZghs1GfBUTB8yxG/e1eNYylZOuKJHQOU=;
 b=Mi2n10sjmEWgWV3fe6ifTSCu7qwA3MtRR+ZVbYLnQEiwrV7ys0zb1YgLn+5TIn5rkZR1
 1HmGDz0ZhuT5lMeh0V8LFtHmKa9QMBw4U5lwAyKYVaHu5pFJJTliTtcTQTOBr3LERL57
 h1WePZNrr8snP6qRcPPEYVaqtYyJeCotPSObudEodM2zg0EAe2X+/CNQ40It2/lyxP+H
 UeRJzXaaPRZnfBjcfIwa2AcoDghmGIFBxQqttAbYoxUepzagDuBc8wCGx3zCqOhVPoPk
 GxQpAOq0wYQiAUH0byGlFsmSzJwXYLwFmYbGAB4QSj04MnaOa1kNM+IC5cjg0WDdemjF 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbt8qah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGCtf3015328
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u9k1vce4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:22 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CGEMG3030230
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:14:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:14:21 -0700
Date:   Mon, 12 Aug 2019 09:14:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 09/18] xfs: Factor up commit from
 xfs_attr_try_sf_addname
Message-ID: <20190812161420.GX7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-10-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-10-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:17PM -0700, Allison Collins wrote:
> New delayed attribute routines cannot handle transactions,
> so factor this up to the calling function.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f9d5e28..6bd87e6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -196,7 +196,7 @@ xfs_attr_try_sf_addname(
>  {
>  
>  	struct xfs_mount	*mp = dp->i_mount;
> -	int			error, error2;
> +	int			error;
>  
>  	error = xfs_attr_shortform_addname(args);
>  	if (error == -ENOSPC)
> @@ -212,9 +212,7 @@ xfs_attr_try_sf_addname(
>  	if (mp->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args->trans);
>  
> -	error2 = xfs_trans_commit(args->trans);
> -	args->trans = NULL;
> -	return error ? error : error2;
> +	return error;
>  }
>  
>  /*
> @@ -226,7 +224,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error;
> +	int			error, error2 = 0;;
>  
>  	/*
>  	 * If the attribute list is non-existent or a shortform list,
> @@ -246,8 +244,11 @@ xfs_attr_set_args(
>  		 * Try to add the attr to the attribute list in the inode.
>  		 */
>  		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC)
> -			return error;
> +		if (error != -ENOSPC) {
> +			error2 = xfs_trans_commit(args->trans);

I've wondered about this weird logic... if xfs_attr_shortform_addname
returns an error code other than ENOSPC, why would we commit the
transaction?  Usually we let the error code bounce up to whomever
allocated the transaction and let them cancel it.

Hmm, looking around some more, I guess xfs_attr_shortform_remove can
return ENOATTR to _addname and _shortform_lookup can return EEXIST, but
with either of those error codes, the transaction isn't dirty so it's
not like we're committing garbage state into the filesystem...?

--D

> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
>  
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
> -- 
> 2.7.4
> 
