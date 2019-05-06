Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC3F15390
	for <lists+linux-xfs@lfdr.de>; Mon,  6 May 2019 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfEFSYZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 6 May 2019 14:24:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfEFSYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 14:24:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46IO7bc090039;
        Mon, 6 May 2019 18:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cw8PQV/rk/UgFFYATHFnkYIx7e/AQbvupt8Fhy2sy7A=;
 b=sDFtl4E5QTQ9fTi6zvkjcmC36fWNpWltwjImxg72ysbYdu2v10aMOFUj77HnnhJxE1XQ
 GANtYEojparHgOaW/fDXsRw6shuolgTxl9mWUWBmWUvcpXfZwQM9/P398fHImvSYlKPf
 e221+s2fQryV23xJJ5MNtQIIXyMWcgZkF5l047K1pKH6TQXEgYdNW4fRPGhk+aNl72Sl
 FWJPm3Q0++KdlAGXjNZhKXkk2i8WpKgmYHdru9bY4bio/Qz4Ko0ErXbfXkFbjsD6kQ6P
 0gcgekjlD8CoN2lu6xtH0e1IuaYahkmBQz2+gxWQHgDgIwInhDT4OG6oSjOHXvyP8ynu ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s94b0ge0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 May 2019 18:24:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46INRkJ126501;
        Mon, 6 May 2019 18:24:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2s94b91y8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 May 2019 18:24:19 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x46IOHZp024621;
        Mon, 6 May 2019 18:24:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 11:24:17 -0700
Date:   Mon, 6 May 2019 11:24:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/4] xfsdump: update to use fallocate
Message-ID: <20190506182413.GS5207@magnolia>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155085403848.5141.1866278990901950186.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905060154
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905060154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Uh, ping? :)

--D

On Fri, Feb 22, 2019 at 08:47:18AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is a series to update the "create file and preallocate blocks"
> code in xfs_restore.
> 
> The first patch refactors the existing copy-pasta into a single helper
> function to create and preallocate space in files, as well as removing
> the totally broken ALLOCSP code.
> 
> The next two patches fix unchecked return values and insufficient
> unsupported-ioctl code.
> 
> The final patch upgrades xfs_restore to try fallocate before RESVSP
> simply because it is the newer API.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
