Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8978A796
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfHLTyS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:54:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfHLTyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:54:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJE49e112999;
        Mon, 12 Aug 2019 19:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=x9VVG3OfmyZl+7BqcbjzbTAQStEYODHPUGHYHkAMiuc=;
 b=j5wQKYbU8MmHTkvTYMBYUB8SK1QbD5jNBSwUOM1YjWbf+zVjazvJdhTZjo+mgGlqYrd8
 IxtRdB/v7YkXHOFMY+QCOOoUbAhoh+CMJL6SZ6R/UaaqcmPT65NCQVuVaSAbeDIoRsyZ
 po8n9BjnBxWnDYcsJrKsF98DNftnZ53RLGSXjZPWHNZgweje/TI5biJ0lOVZ3TOH7jca
 aEjuYddEQyk/TegjySFs0E8S492f0ibhv7Hqb66ODlI5QuCCE7qPmMxYFsqGpHqJxI7z
 dhc9Qi1hNjHZXB60Oaoavd0CLNQxQnuQUJl6lhDBsbUcrG6lDKRCZhhggdfA99MwBpZD bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=x9VVG3OfmyZl+7BqcbjzbTAQStEYODHPUGHYHkAMiuc=;
 b=AP7NXiFFQb/xOa3+Bc86EYXe6dWvIpYAnkoVrifMcWhsQQGTFZLHbhvFdcovOOW+eLNN
 cnzgBbeiTayDSZPiqa7xmli1wXFODwMP2RwafCG2NqFdREDedKrezTGeqHPTR7eZK1wq
 5Q71e9tT3WmInfSrVNSkldUPF6bkc2ypXwMFZuQ0r44Y+xleZt0l6y8JwzIq1ZY5sXwJ
 xqbO7fTiNhJFnYLgL6/S0qMNp7LKTeCGeLOA4YzBE4+dx2sSt6vF3gyQrxeX1V22q1/R
 9/Nca5fjbsFtBaVBH12cE5CSBQpOGp9NVq2sZ4ua+odlSzBPbzj1Z3bhnsNhViQkH33W Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u9pjq9rrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 19:54:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJCgtp138035;
        Mon, 12 Aug 2019 19:54:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u9k1vknx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 19:54:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJsAZZ022631;
        Mon, 12 Aug 2019 19:54:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:54:10 -0700
Date:   Mon, 12 Aug 2019 12:54:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs: xfs: Remove KM_NOSLEEP and KM_SLEEP.
Message-ID: <20190812195409.GJ7138@magnolia>
References: <62ec978e-c045-80ad-24a6-41da07d1b37d@i-love.sakura.ne.jp>
 <1564658887-12654-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801203945.GC7138@magnolia>
 <6e50eef5-434e-a81e-9001-f3deabfa7cc9@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e50eef5-434e-a81e-9001-f3deabfa7cc9@i-love.sakura.ne.jp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 12, 2019 at 07:59:30PM +0900, Tetsuo Handa wrote:
> On 2019/08/02 5:39, Darrick J. Wong wrote:
> > On Thu, Aug 01, 2019 at 08:28:07PM +0900, Tetsuo Handa wrote:
> >> Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
> >> we can remove KM_NOSLEEP and replace KM_SLEEP with 0.
> >>
> >> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > 
> > Ahh, right, KM_{NO,}SLEEP are mutually exclusive values encoded
> > alongside a bit flag set (ala fallocate mode)....
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> 
> Thank you. Please apply to xfs tree.

Will do.

--D
