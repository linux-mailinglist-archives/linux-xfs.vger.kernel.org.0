Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63C416EE62
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 19:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgBYSwR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 13:52:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42058 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727494AbgBYSwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:52:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIhMYZ039609;
        Tue, 25 Feb 2020 18:52:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZE33GrzacmItwV2jzYR8cnN0X9X1S/DREEXGopB2HJ4=;
 b=z1VR11sdhrgHQz8d2GdL5kfYJObdkiFuYSnkv6+C3IiXj5MgxqebtqfJ6lQENf2+pWZk
 EFwUpcHtBdajTPuaqnc0e8UNOzJrOL0Bn/F8PfHH9jq1y8JM2t/HwTafRS4ZYUK9A2WB
 UM70yXOl/WMngVOASX7Gc8PjJleAgTarsQsrmYnTl2qdCqJqMIHdOwWDx04J2/aZk+16
 kxZSdRXKRpi4otZtZj1h8Z4bZpUujKyTyNIumiFol5VLS0BgRfhVSKlze26aiAbU8+A2
 977R7DFwthl5S8DdxzWldoEkK+BK2mTetd6i1+PpICUjbmeR6WofNqF+oJSSqpHagh/7 MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yd0njkdpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:52:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIqAbn115162;
        Tue, 25 Feb 2020 18:52:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yd09b86yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:52:12 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PIqB8i029973;
        Tue, 25 Feb 2020 18:52:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:52:10 -0800
Date:   Tue, 25 Feb 2020 10:52:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/25] libxfs: remove dangerous casting between xfs_buf
 and cache_node
Message-ID: <20200225185209.GM6740@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258961671.451378.13182510046201286918.stgit@magnolia>
 <20200225175216.GS20570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225175216.GS20570@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:52:16AM -0800, Christoph Hellwig wrote:
> >  #define XFS_BUF_SET_PRIORITY(bp,pri)	cache_node_set_priority( \
> >  						libxfs_bcache, \
> > -						(struct cache_node *)(bp), \
> > +						&(bp)->b_node, \
> >  						(pri))
> 
> I think this one would benefit from being turned into an inline
> function..

Yeah, probably both of those.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
