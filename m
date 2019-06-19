Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB194C3DF
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 00:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfFSWvp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 Jun 2019 18:51:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSWvo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jun 2019 18:51:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JMnnWo028201;
        Wed, 19 Jun 2019 22:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=5pGRbXKM4IR2AyuJPKj/9yH3Ziva/aUKbVFEx9GjBCk=;
 b=WCX5kPtpw3UHLwkS3lC6ghiT6IAiSCBuatnDqOe4j+KIP899dTE/3Ih3472pO6z15hQO
 xV8RBtmVLuZ1HWG0GseOCxHe1UAqcVpuD7hL24Jifn2ZcDTPw3LHuSbJaQfkYjoh1NCG
 dJxxzFwcedNoBE1DyWU8locaBsPufGwGBoYMnSAl+UpHGEwwAmvUZrlItP8G6ElxSlwT
 xem5h5uI5anrjk5GSA8cXpqj6x5YmvjNzbB+BDuAYJgheAOBhvXeOfALkG7MEUrCtuPP
 iv59t95buguc/6+Rj3mHTNq/z41jdaVHcU5Hey6US62pKWisfzckxiDY4oa5Pm3d3qbF Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t7809dyww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 22:51:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5JMpLmJ067726;
        Wed, 19 Jun 2019 22:51:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2t77ynbhy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 22:51:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5JMpbRj011385;
        Wed, 19 Jun 2019 22:51:38 GMT
Received: from localhost (/10.159.231.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Jun 2019 15:51:37 -0700
Date:   Wed, 19 Jun 2019 15:51:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/20] xfs: move the log ioend workqueue to struct xlog
Message-ID: <20190619225136.GU5387@magnolia>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-15-hch@lst.de>
 <20190619121908.GA11894@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619121908.GA11894@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190187
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9293 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190187
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 19, 2019 at 02:19:08PM +0200, Christoph Hellwig wrote:
> The build/test bot found an issue with this one leading to crashes
> at unmount, and I think this incremental patch should fix it:

I have't see any crashes at unmount; would you mind sharing the report?

--D

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 66b87cce69b9..c66757251809 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1954,7 +1954,6 @@ xlog_dealloc_log(
>  	int		i;
>  
>  	xlog_cil_destroy(log);
> -	destroy_workqueue(log->l_ioend_workqueue);
>  
>  	/*
>  	 * Cycle all the iclogbuf locks to make sure all log IO completion
> @@ -1976,6 +1975,7 @@ xlog_dealloc_log(
>  	}
>  
>  	log->l_mp->m_log = NULL;
> +	destroy_workqueue(log->l_ioend_workqueue);
>  	kmem_free(log);
>  }	/* xlog_dealloc_log */
>  
