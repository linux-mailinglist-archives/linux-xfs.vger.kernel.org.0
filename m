Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84CC29F625
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgJ2U0c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 16:26:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2U0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 16:26:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THOrdT108587;
        Thu, 29 Oct 2020 17:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DKLUiTjQen64u4sJLu/9kFXbGzaKajgFaBZ06kd7Cno=;
 b=NyTvhBKqrO8AAydL/c1T5QaVrdyuuHOcg4a+pIUeQSVerzZkPS0sNEyyrR7Bezzbpv29
 w4TsVL+JtP+Jdh06tWWZZLyAB0c6E/8a0kz3aAHYDe/wtJhXLLAelZMsZv3oKHgm1zV4
 syE+WvgRGLSN8IxBprswEfSxQkZoHNT+o9ylDCdQRVwqZNFT/L8vv9dweSwc/LWURSV6
 OfYjb+3KIbYcV5H0fcS6i57f2xKmzYQ8pcwaIY2+NsEmozmRy6yK+MMeiwOS9QzT1kD5
 sMpMsZLDKiYDjGX78oJ2wouG2yMJnM51uGbiU8qe/19oXGI4VYLNyQX1v6c0pzbwTlUn lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm4bqej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 17:28:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THOXtw063132;
        Thu, 29 Oct 2020 17:26:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwuq1j3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 17:26:00 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09THPxbD010426;
        Thu, 29 Oct 2020 17:25:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 10:25:58 -0700
Date:   Thu, 29 Oct 2020 10:25:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] libfrog: define LIBFROG_BULKSTAT_CHUNKSIZE to
 remove dependence on XFS_INODES_PER_CHUNK
Message-ID: <20201029172557.GQ1061252@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375526530.881414.1004347326416234607.stgit@magnolia>
 <20201029094504.GF2091@infradead.org>
 <20201029094549.GH2091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029094549.GH2091@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=980 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 09:45:49AM +0000, Christoph Hellwig wrote:
> On Thu, Oct 29, 2020 at 09:45:04AM +0000, Christoph Hellwig wrote:
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> And no good reason to use struct timespec64 here, right?

Huh?  There's no mention of a timespec in this patch at all...?

<confused>

--D
