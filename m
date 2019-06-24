Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E45198A
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 19:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732458AbfFXR3O (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 13:29:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38468 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFXR3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 13:29:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHNwcZ179866;
        Mon, 24 Jun 2019 17:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=IkWhAs8I5Miu5BiLb4nznG0nqtLAPkqPjsaTdf1ACfY=;
 b=ueIly1rsLQ5RWwm0aNPk0iYwZDJCE/iyY6eevNpLl025HywpquYiCVoYERCDbaPox9K3
 5PI5gJkGu8BAUm31s+WX5QQ9CA1pES64kOM5sZFPV6jK8vPfENHHziLZLyxApafS9Y/W
 6FdXhtE628kHNZnqsa8zUr5VFxDlvJuncVfEQ9EROxvwvt9kPoxrA8at1yQg+ul7Wf1n
 DIK1CaF/QO/lE0MExTRs0jSTseAle9LZL5nPflb26yAfsefVNwgkDFRLa92R8AeOrJIT
 yKbLsv0dwQj+98UoO6jxhnae8REDPX64Ct96TXF10M4dC1hxqHHZRTSJcbMtdppllrjy pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t9cyq7ngt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:28:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHPOQ7106071;
        Mon, 24 Jun 2019 17:26:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tat7brtj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:26:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5OHQYuX024213;
        Mon, 24 Jun 2019 17:26:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 10:26:33 -0700
Date:   Mon, 24 Jun 2019 10:26:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 03/10] xfs: mount-api - add xfs_parse_param()
Message-ID: <20190624172632.GU5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134511636.2519.2203014992522713286.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134511636.2519.2203014992522713286.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 10:58:36AM +0800, Ian Kent wrote:
> Add the fs_context_operations method .parse_param that's called
> by the mount-api ito parse each file system mount option.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---
>  fs/xfs/xfs_super.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 176 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 14c2a775786c..e78fea14d598 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -495,6 +495,178 @@ xfs_parseargs(
>  	return 0;
>  }
>  
> +struct xfs_fs_context {
> +	int	dsunit;
> +	int	dswidth;
> +	uint8_t	iosizelog;
> +};
> +
> +/*
> + * This function fills in xfs_mount_t fields based on mount args.
> + * Note: the superblock has _not_ yet been read in.
> + *
> + * Note that this function leaks the various device name allocations on
> + * failure.  The caller takes care of them.

Wait, what?  Do you mean "The caller is responsible for freeing the
device name allocations if option parsing ends in failure"?

> + */
> +STATIC int
> +xfs_parse_param(
> +	struct fs_context	 *fc,
> +	struct fs_parameter	 *param)
> +{
> +	struct xfs_fs_context    *ctx = fc->fs_private;
> +	struct xfs_mount	 *mp = fc->s_fs_info;
> +	struct fs_parse_result    result;
> +	int			  iosize = 0;
> +	int			  opt;
> +
> +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> +	if (opt < 0)
> +		return opt;
> +
> +	switch (opt) {
> +	case Opt_logbufs:
> +		mp->m_logbufs = result.uint_32;
> +		break;
> +	case Opt_logbsize:
> +		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
> +			return -EINVAL;
> +		break;
> +	case Opt_logdev:
> +		kfree(mp->m_logname);
> +		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> +		if (!mp->m_logname)
> +			return -ENOMEM;
> +		break;
> +	case Opt_rtdev:
> +		kfree(mp->m_rtname);
> +		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> +		if (!mp->m_rtname)
> +			return -ENOMEM;
> +		break;
> +	case Opt_allocsize:
> +	case Opt_biosize:
> +		if (suffix_kstrtoint(param->string, 10, &iosize))
> +			return -EINVAL;
> +		ctx->iosizelog = ffs(iosize) - 1;
> +		break;
> +	case Opt_bsdgroups:
> +		mp->m_flags |= XFS_MOUNT_GRPID;
> +		break;
> +	case Opt_grpid:
> +		if (result.negated)
> +			mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		else
> +			mp->m_flags |= XFS_MOUNT_GRPID;
> +		break;
> +	case Opt_sysvgroups:
> +		mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		break;
> +	case Opt_wsync:
> +		mp->m_flags |= XFS_MOUNT_WSYNC;
> +		break;
> +	case Opt_norecovery:
> +		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> +		break;
> +	case Opt_noalign:
> +		mp->m_flags |= XFS_MOUNT_NOALIGN;
> +		break;
> +	case Opt_swalloc:
> +		mp->m_flags |= XFS_MOUNT_SWALLOC;
> +		break;
> +	case Opt_sunit:
> +		ctx->dsunit = result.uint_32;
> +		break;
> +	case Opt_swidth:
> +		ctx->dswidth = result.uint_32;
> +		break;
> +	case Opt_inode32:
> +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		break;
> +	case Opt_inode64:
> +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		break;
> +	case Opt_nouuid:
> +		mp->m_flags |= XFS_MOUNT_NOUUID;
> +		break;
> +	case Opt_ikeep:
> +		if (result.negated)
> +			mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		else
> +			mp->m_flags |= XFS_MOUNT_IKEEP;
> +		break;
> +	case Opt_largeio:
> +		if (result.negated)
> +			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
> +		else
> +			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
> +		break;
> +	case Opt_attr2:
> +		if (!result.negated) {
> +			mp->m_flags |= XFS_MOUNT_ATTR2;
> +		} else {
> +			mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +			mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		}
> +		break;
> +	case Opt_filestreams:
> +		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> +		break;
> +	case Opt_quota:
> +		if (!result.negated) {
> +			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +					 XFS_UQUOTA_ENFD);
> +		} else {
> +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> +			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> +			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> +		}
> +		break;
> +	case Opt_uquota:
> +	case Opt_usrquota:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +				 XFS_UQUOTA_ENFD);
> +		break;
> +	case Opt_qnoenforce:
> +	case Opt_uqnoenforce:
> +		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> +		break;
> +	case Opt_pquota:
> +	case Opt_prjquota:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> +				 XFS_PQUOTA_ENFD);
> +		break;
> +	case Opt_pqnoenforce:
> +		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> +		break;
> +	case Opt_gquota:
> +	case Opt_grpquota:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> +				 XFS_GQUOTA_ENFD);
> +		break;
> +	case Opt_gqnoenforce:
> +		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> +		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> +		break;
> +	case Opt_discard:
> +		if (result.negated)
> +			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		else
> +			mp->m_flags |= XFS_MOUNT_DISCARD;
> +		break;
> +#ifdef CONFIG_FS_DAX
> +	case Opt_dax:
> +		mp->m_flags |= XFS_MOUNT_DAX;
> +		break;
> +#endif
> +	default:
> +		return invalf(fc, "XFS: unknown mount option [%s].", param->key);

What do these messages end up looking like in dmesg?

The reason I ask is that today when mount option processing fails we log
the device name in the error message:

# mount /dev/sda1 /mnt -o gribblegronk
[64010.878477] XFS (sda1): unknown mount option [gribblegronk].

AFAICT using invalf (instead of xfs_warn) means that now we don't report
the device name, and all you'd get is:

"[64010.878477] XFS: unknown mount option [gribblegronk]."

which is not as helpful...

--D

> +	}
> +
> +	return 0;
> +}
> +
>  struct proc_xfs_info {
>  	uint64_t	flag;
>  	char		*str;
> @@ -1914,6 +2086,10 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  };
>  
> +static const struct fs_context_operations xfs_context_ops = {
> +	.parse_param = xfs_parse_param,
> +};
> +
>  static struct file_system_type xfs_fs_type = {
>  	.owner			= THIS_MODULE,
>  	.name			= "xfs",
> 
