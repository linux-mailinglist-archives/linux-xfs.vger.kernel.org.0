Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBB334A49
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 16:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfFDOYe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 10:24:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfFDOYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 10:24:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54EJJmM071213;
        Tue, 4 Jun 2019 14:24:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=DVPUIJo+tnJ+3yTaa5gsZt3s/r0aeWXdBYnsUvLgxWE=;
 b=P3w++StinzfdcSEHiYXkFfmtul/QhqW7fppB0FISS3cSiHkWkHf6gPFzqrzFE7cLC9tN
 hIZ3lRfYx1z+qhVf2PTkUII9Mpoty+Z2t4pLT7r+uHb/VmHkt2O+vnYnQjQbO0vF0Cqa
 7RbKZwgR5yG+G+GkRfAuUVj8DokhgcVaLLJ+7nvOWie2KJeThQ9La1Fl0jl4GfNfyTik
 EurlZG6/s+EyIASug5KhlchOcVJJalDINUWwFYSDnO4hr5taw8Ryo+VCst94a0pbSZ7Y
 bHv7EvLMquzsMn2RqCWA8lscqcIddGQh27XuzotNhLUcS/8O+Oe2J0on8o1kpoLd5/Z6 kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugstddrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 14:24:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54ENmRS063381;
        Tue, 4 Jun 2019 14:24:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2swnghcg5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 14:24:30 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54EOT8Z026955;
        Tue, 4 Jun 2019 14:24:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 07:24:29 -0700
Date:   Tue, 4 Jun 2019 07:24:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: bulkstat should copy lastip whenever
 userspace supplies one
Message-ID: <20190604142427.GC1200785@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
 <155916880004.757870.14054258865473950566.stgit@magnolia>
 <20190604075442.GX29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604075442.GX29573@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040096
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040096
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 05:54:42PM +1000, Dave Chinner wrote:
> On Wed, May 29, 2019 at 03:26:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When userspace passes in a @lastip pointer we should copy the results
> > back, even if the @ocount pointer is NULL.
> 
> Makes sense and the code change is simple enough, but this changes
> what we return to userspace, right?  Does any of xfsprogs or fstests
> test code actually exercise this case? If not, how have you
> determined it isn't going to break anything?

Coming in a future xfstests submission along with other basic
functionality checks. :)

(Future, as in "later today"...)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
