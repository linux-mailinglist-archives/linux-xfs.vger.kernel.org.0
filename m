Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D6495AC
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 01:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFQXIr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 19:08:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44720 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfFQXIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 19:08:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HN4QtW171591;
        Mon, 17 Jun 2019 23:08:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=9VTuoWDoy9Gx15TCZaMxAcoyDgR8w6fhkZ3WxNQyaqQ=;
 b=1JgphGjpyH1WwJhb6Thho6yETi4wmxPdb0Kfk8T3hrLlAUmCY92PgY7rvi8995oEVitd
 vEzf8RfE4Vz5aR5GQ2NWKVioxVuMo7XcBIN4j2SE+zjOeP7j+zYIE57xNWKJpkjbW57p
 w9KtPx/x6etc702McvT4AyFz3Jv5dKfVHWpJAM4ZoWklLiI8YSfDayh+tHuQqR8q8rEn
 dWMfvT985z9jkRD31p+fTXMa8y7LCuI3qdKW0kT5MrjRTc38SbWI/OFtTgAqY5nhCmJz
 Q+jbuVEo1wfmSqkarDlwR/ZzNdmZs4Tl7FUTyzuaTc43h6/WHWC75hVWNmbt+oZD3q06 AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t4r3th4mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:08:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5HN7vkE146684;
        Mon, 17 Jun 2019 23:08:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t5h5tdec0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 23:08:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5HN8aOj022272;
        Mon, 17 Jun 2019 23:08:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 16:08:36 -0700
Date:   Mon, 17 Jun 2019 16:08:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] xfs: remove the l_iclog_size_log field from strut
 xlog
Message-ID: <20190617230835.GO3773859@magnolia>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605191511.32695-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906170200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906170199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 09:14:52PM +0200, Christoph Hellwig wrote:
> This field is never used, so we can simply kill it.

s/strut xlog/struct xlog/ in the subject; will fix it in the series if I
end up pulling it in...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 9 ---------
>  fs/xfs/xfs_log_priv.h | 1 -
>  2 files changed, 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a2048e46be4e..8033b64092bb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1307,7 +1307,6 @@ xlog_get_iclog_buffer_size(
>  	struct xfs_mount	*mp,
>  	struct xlog		*log)
>  {
> -	int size;
>  	int xhdrs;
>  
>  	if (mp->m_logbufs <= 0)
> @@ -1319,13 +1318,6 @@ xlog_get_iclog_buffer_size(
>  	 * Buffer size passed in from mount system call.
>  	 */
>  	if (mp->m_logbsize > 0) {
> -		size = log->l_iclog_size = mp->m_logbsize;
> -		log->l_iclog_size_log = 0;
> -		while (size != 1) {
> -			log->l_iclog_size_log++;
> -			size >>= 1;
> -		}
> -
>  		if (xfs_sb_version_haslogv2(&mp->m_sb)) {
>  			/* # headers = size / 32k
>  			 * one header holds cycles from 32k of data
> @@ -1346,7 +1338,6 @@ xlog_get_iclog_buffer_size(
>  
>  	/* All machines use 32kB buffers by default. */
>  	log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;
> -	log->l_iclog_size_log = XLOG_BIG_RECORD_BSHIFT;
>  
>  	/* the default log size is 16k or 32k which is one header sector */
>  	log->l_iclog_hsize = BBSIZE;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b5f82cb36202..78a2abeba895 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -361,7 +361,6 @@ struct xlog {
>  	int			l_iclog_heads;  /* # of iclog header sectors */
>  	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
>  	int			l_iclog_size;	/* size of log in bytes */
> -	int			l_iclog_size_log; /* log power size of log */
>  	int			l_iclog_bufs;	/* number of iclog buffers */
>  	xfs_daddr_t		l_logBBstart;   /* start block of log */
>  	int			l_logsize;      /* size of log in bytes */
> -- 
> 2.20.1
> 
