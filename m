Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F37951A1F
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 19:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfFXR46 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 13:56:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXR46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 13:56:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHrgjJ195791;
        Mon, 24 Jun 2019 17:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=PN/LWT3y+O2hkeDKCbZ8SnR2shKq7IY94CIdk8i0hog=;
 b=2HJ2NXSCfWEjaI2NlxBkGQ+NyDFCQ/PPP1BoYQ3Z9FnoPbqu1oSgoadz9rmKbEyHyJ/5
 +HrihSFr73FwpCp7ZFHV+HOYYlHhrDWR+X67mB0up7eRNIFZAGE2ORRi30WZvYFW3A5U
 UouOeYZlr5fQZHQFguQs6IirDjiPIY9NkLcnlItWzG8507g4KEXCKUfhulv0iIZgfsan
 M3M0+knnWAvSgPV0kKEAkW012eZpVMWJ18R88DI+Lh0EZSw5OEMx6/+5F5ZCvxGrbqsk
 tQj9s9Seac9jbNbE+AATjWd0gU/arHDeb72/8QNVlLuJqE8dmy6dWX5Hjqub9rn8q/5L PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brsyvbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:56:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHtMe8173605;
        Mon, 24 Jun 2019 17:56:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7bs716-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:56:29 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5OHuSKL004895;
        Mon, 24 Jun 2019 17:56:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 10:56:28 -0700
Date:   Mon, 24 Jun 2019 10:56:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 07/10] xfs: mount-api - add xfs_fc_free()
Message-ID: <20190624175627.GY5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134514204.2519.9597800141023778002.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134514204.2519.9597800141023778002.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 10:59:02AM +0800, Ian Kent wrote:
> Add the fs_context_operations method .free that performs fs
> context cleanup on context release.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7326b21b32d1..0a771e1390e7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -2413,10 +2413,33 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static void xfs_fc_free(struct fs_context *fc)
> +{
> +	struct xfs_fs_context	*ctx = fc->fs_private;
> +	struct xfs_mount	*mp = fc->s_fs_info;
> +
> +	if (mp) {
> +		/*
> +		 * If an error occurs before ownership the xfs_mount
> +		 * info struct is passed to xfs by the VFS (by assigning
> +		 * it to sb->s_fs_info and clearing the corresponding
> +		 * fs_context field, done before calling fill super via
> +		 * .get_tree()) there may be some strings to cleanup.
> +		 */
> +		if (mp->m_logname)
> +			kfree(mp->m_logname);

Doesn't kfree handle null parameters gracefully?

--D

> +		if (mp->m_rtname)
> +			kfree(mp->m_rtname);
> +		kfree(mp);
> +	}
> +	kfree(ctx);
> +}
> +
>  static const struct fs_context_operations xfs_context_ops = {
>  	.parse_param = xfs_parse_param,
>  	.get_tree    = xfs_get_tree,
>  	.reconfigure = xfs_reconfigure,
> +	.free	     = xfs_fc_free,
>  };
>  
>  static struct file_system_type xfs_fs_type = {
> 
