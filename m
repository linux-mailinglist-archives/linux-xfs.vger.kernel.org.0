Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F224AC12
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 22:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfFRUx2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 16:53:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44062 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbfFRUx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 16:53:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IKi6iF129014;
        Tue, 18 Jun 2019 20:52:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=pb9YBlR8jln45gp766ipzWUQCqAL7YrX0POZ0qaYNBo=;
 b=PDu4ZrhytVaAMfzMLNrIsFm36IPd9vpkRavm5oTCv8wGoU4YNALgwZMQD/GWSwHE+F6R
 24Eo6nFncS++DBy8H346brXndH5AbOwcwlSEyipTaopKNDpZLgSj+d4QIK3j34+sFslV
 jWNkST4+DEJMgHi2Lt2YNzpgseX7IaBbVkt+ZDn3xhjUQQXsiaHom8cuzgkCPjvDWdPe
 Pw6T4jc1uDJnPXbnFxwIQ0WUs+TZcef5p60SmqFu3uZEjoGjnZ66wWeCijyWCUPaeJlJ
 yw28naK8/WfJJv8Y9usb+rytrXQ09wA3mtj2t2CPjCwv+nWFuFAAKMXTRRjIlu2Pm1kM ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t4rmp6rag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:52:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IKqaB6035839;
        Tue, 18 Jun 2019 20:52:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2t59ge2e9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:52:54 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IKqroe020819;
        Tue, 18 Jun 2019 20:52:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 13:52:53 -0700
Date:   Tue, 18 Jun 2019 13:52:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/4] xfs: separate inode geometry
Message-ID: <20190618205252.GR5387@magnolia>
References: <155968493259.1657505.18397791996876650910.stgit@magnolia>
 <155968493890.1657505.14039176301049696712.stgit@magnolia>
 <20190618181732.GA873@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618181732.GA873@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=767
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=831 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 18, 2019 at 11:17:32AM -0700, Christoph Hellwig wrote:
> Sorry for spotting this so late, but this one is pretty bogus as-is.
> 
> The geometry information is not an on-disk structure in any sense,
> and has absolutely no business in xfs_format.h.

Ok I'll move it.

--D
