Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8672208D
	for <lists+linux-xfs@lfdr.de>; Sat, 18 May 2019 00:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfEQW4m (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 18:56:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEQW4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 18:56:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HMi4wL080826;
        Fri, 17 May 2019 22:56:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xugLUjdJeZsGwuViWB9vKHaLNVx3GZKdx59DkRlqK8I=;
 b=Ue2BmrblF+RSlzoy/BBtnT0RGGHAkQ3ze+TGs2GsLQViTfN1jawekZJak8Jgt4RBmFPe
 5icVclwvHlCt4Gc+mfLh8OaoavNsJxq1HU6tea8L0R/bhjMd/z9rdv1Gb4FZ3iaHTavW
 QLVrcELoyfIweWi+lPDMDFcUalI99nXSW/Lhs4JMhP8KRd7DxJ3TLS7HnXPQtddxvGKI
 p+byVG1Jn4QEGrjg9SZ9hGvizB2ZWK5TjuTV6ns/P0unfyZ4xwaBpgmlJH4n8EqLspku
 U50Hwf42VsoOR/RUYSi99em/80ulislh/DSxxb60uZ5xT+6GR3DXDEvciA0Fej+oc5k8 rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sdq1r4aff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 22:56:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HMttP9061917;
        Fri, 17 May 2019 22:56:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2shh5haquk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 22:56:13 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4HMuC5V025690;
        Fri, 17 May 2019 22:56:12 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 May 2019 15:56:12 -0700
Subject: Re: [PATCH 6/3] libxfs: factor common xfs_trans_bjoin code
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <3a54f934-5651-d709-1503-b583f9e044e9@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <99ee81de-e180-8565-5b45-de4a98b86b19@oracle.com>
Date:   Fri, 17 May 2019 15:56:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <3a54f934-5651-d709-1503-b583f9e044e9@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170137
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/16/19 1:39 PM, Eric Sandeen wrote:
> Most of xfs_trans_bjoin is duplicated in xfs_trans_get_buf_map,
> xfs_trans_getsb and xfs_trans_read_buf_map.  Add a new
> _xfs_trans_bjoin which can be called by all three functions.
> 
> Source kernel commit: d7e84f413726876c0ec66bbf90770f69841f7663
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Alex Elder <aelder@sgi.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/trans.c | 53 +++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 39 insertions(+), 14 deletions(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index f3c28fa7..f78222fd 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -537,19 +537,50 @@ xfs_trans_binval(
>   	tp->t_flags |= XFS_TRANS_DIRTY;
>   }
>   
> -void
> -xfs_trans_bjoin(
> -	xfs_trans_t		*tp,
> -	xfs_buf_t		*bp)
> +/*
> + * Add the locked buffer to the transaction.
> + *
> + * The buffer must be locked, and it cannot be associated with any
> + * transaction.
> + *
> + * If the buffer does not yet have a buf log item associated with it,
> + * then allocate one for it.  Then add the buf item to the transaction.
> + */
> +STATIC void
> +_xfs_trans_bjoin(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp,
> +	int			reset_recur)
>   {
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>   
>   	ASSERT(bp->b_transp == NULL);
>   
> +        /*
> +	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
> +	 * it doesn't have one yet, then allocate one and initialize it.
> +	 * The checks to see if one is there are in xfs_buf_item_init().
> +	 */
>   	xfs_buf_item_init(bp, tp->t_mountp);
>   	bip = bp->b_log_item;
> +	if (reset_recur)
> +		bip->bli_recur = 0;
> +
> +	/*
> +	 * Attach the item to the transaction so we can find it in
> +	 * xfs_trans_get_buf() and friends.
> +	 */
>   	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>   	bp->b_transp = tp;
> +
> +}
> +
> +void
> +xfs_trans_bjoin(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +	_xfs_trans_bjoin(tp, bp, 0);
>   	trace_xfs_trans_bjoin(bp->b_log_item);
>   }
>   
> @@ -594,9 +625,7 @@ xfs_trans_get_buf_map(
>   	if (bp == NULL)
>   		return NULL;
>   
> -	xfs_trans_bjoin(tp, bp);
> -	bip = bp->b_log_item;
> -	bip->bli_recur = 0;
> +	_xfs_trans_bjoin(tp, bp, 1);
>   	trace_xfs_trans_get_buf(bp->b_log_item);
>   	return bp;
>   }
> @@ -626,9 +655,7 @@ xfs_trans_getsb(
>   
>   	bp = xfs_getsb(mp);
>   
> -	xfs_trans_bjoin(tp, bp);
> -	bip = bp->b_log_item;
> -	bip->bli_recur = 0;
> +	_xfs_trans_bjoin(tp, bp, 1);
>   	trace_xfs_trans_getsb(bp->b_log_item);
>   	return bp;
>   }
> @@ -677,9 +704,7 @@ xfs_trans_read_buf_map(
>   	if (bp->b_error)
>   		goto out_relse;
>   
> -	xfs_trans_bjoin(tp, bp);
> -	bip = bp->b_log_item;
> -	bip->bli_recur = 0;
> +	_xfs_trans_bjoin(tp, bp, 1);
>   done:
>   	trace_xfs_trans_read_buf(bp->b_log_item);
>   	*bpp = bp;
> 
