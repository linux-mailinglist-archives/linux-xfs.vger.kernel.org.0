Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6585121B9C3
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jul 2020 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGJPom (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jul 2020 11:44:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbgGJPom (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 11:44:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AFaqDj139538;
        Fri, 10 Jul 2020 15:44:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4TX80nWXBYUetU6EWwfqTgSalK9LB2PropViIo7MHcA=;
 b=bfv/CTMBm0uyHlbsltrCIWv0m3VysPeKsbfWYRmGl1jT/xOJFZgRGLiumpQOk+skW8Lm
 iTap5o46ZndRIUbgUAAPLzOgdjQkNz/4aCYVQT1uQ75iCUo58rUz/dZq6a/1GqyvVVRi
 RWfKAZQpI11Ab7VjdrERBXtp43uksM82Zkf/n+xU1g+aNXmmIu0iF8nxXBOPP+LB4utH
 jxAhhqwREnwN4NCqtu/4V8pYphmP8QKa/0hUHM6bCE7lwLOX6ukMicKsKv5HiLD/hLhD
 DTE7OhBpGUgbZrDNYS/K9FdoAgzFKRvKqrQsFuC0kwzVDahJLCmINFvTmMcb4t6p/D4a bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 325y0ar7cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 10 Jul 2020 15:44:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06AFbR2V027042;
        Fri, 10 Jul 2020 15:42:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 325k3khgrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jul 2020 15:42:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06AFgTth006524;
        Fri, 10 Jul 2020 15:42:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jul 2020 08:42:29 -0700
Date:   Fri, 10 Jul 2020 08:42:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Bill O'Donnell" <billodo@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_quota: display warning limits when printing quota
 type information
Message-ID: <20200710154228.GT7606@magnolia>
References: <20200709161124.GP7606@magnolia>
 <20200710085906.GA30797@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710085906.GA30797@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9678 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007100106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9678 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 09:59:06AM +0100, Christoph Hellwig wrote:
> On Thu, Jul 09, 2020 at 09:11:24AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > We should dump the default warning limits when we're printing quota
> > information.
> 
> This looks sensible.  Do we need any xfstests changes for thew new
> output, though?
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Yep.  I'll throw that series in at the end of the next round of the
quota refactoring.

--D
