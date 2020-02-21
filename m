Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1070816886C
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 21:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgBUUp7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 15:45:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgBUUp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 15:45:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LKhQ8M145214;
        Fri, 21 Feb 2020 20:43:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6ycSSph/o0svKqdoePuhRwn/7A1kF3mvhNIz8ddbfyc=;
 b=jDd0H4Bgrf9alBaZ3NfmQfsONTnWloaKXR4UvmdzgVQD2J+VjAt5WHHsenCatso6PO7s
 u2czfhKUrRcM9NnvoHmNBf6aS20+dkzTDkTxe06A4eQqat8UaiNutTQF4UN8ICk+BbKD
 kJPHnnrTJOiAYCEjTaveciZQhro9pvTTvmVIuKrqH8M4ZMXAlQXNJD8wbKVfq1rBoQzV
 EacmdnBck0NmI1KjY0Q7Z/MbVVqPCJ5+u67FtuGHoncaFjEcPf+shspG5/Ww+Fi27Xft
 uDTOY4tXXedOhEuuaxvm4kWB8Nx3w1CreEB1aQfOZZxJ/4AbCi+akgiFiNjo5lJrNqaV gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y8uddjtxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 20:43:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LKfvsP166334;
        Fri, 21 Feb 2020 20:43:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y8ud9mvsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 20:43:46 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LKhgPc029447;
        Fri, 21 Feb 2020 20:43:43 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 12:43:42 -0800
Date:   Fri, 21 Feb 2020 12:43:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/18] libxfs: make libxfs_bwrite do what
 libxfs_writebufr does
Message-ID: <20200221204341.GZ9506@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216299927.602314.10659390054898124986.stgit@magnolia>
 <20200221144547.GE15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221144547.GE15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=2 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=2
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:45:47AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:43:19PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make libxfs_bwrite equivalent to libxfs_writebufr.  This makes it so
> > that libxfs bwrite calls write the buffer to disk immediately and
> > without double-freeing the buffer.  However, we choose to consolidate
> > around the libxfs_bwrite name to match the kernel.
> 
> The commit message looks a little odd.  Also why is the subject a
> different style than the previous messages?

Ok, changed to:

"libxfs: rename libxfs_writebufr to libxfs_bwrite

"Rename this function so that we have an API that matches the kernel
without a #define."

> Also if there was a double free shouldn't we fix that in a small
> backportable patch first (not that I see such a fix anywhere)?

Hmmm... I can't find one either.  I think that's just an anachronism
from an earlier version of this series.

--D
