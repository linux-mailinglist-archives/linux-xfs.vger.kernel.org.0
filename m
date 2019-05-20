Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72053243EC
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfETXKz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:10:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfETXKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:10:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KN0FBA140620;
        Mon, 20 May 2019 23:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cPFAW3gWE85ytXAjUDKhXLy4uhK+/29PAlzU+BEQYbo=;
 b=g9jV5wydYUAERUmE3h1AA2bRu21V3/r/AGvIYV0mZKnUxGopROoqgmrGZCIJcUT/h3jF
 1d4wcWKesgESo7iJNlq9XOOl9nFhIbsrFgXYZ3U5cyAYBJaQf7lwvUZUy0IhgAjeI12Y
 l8J6G9ONmtdfFOAVVAgN1MLAyJ3CH/U+HbjkO8hJti9AkuI3suKFvgptAn0ciJC+XYms
 Fad9Gir7niqDfRXAD2/XdxtLdLs1temeXP+rZq2UOM+0u4UMVNpGVK5Gsn5Bhd15CEkU
 9CXqdJw+M0ZYDFqFDuwfk0TaFEQ0GldEzRQC7wVw/mKcZoxBSLkLxb5QTQ+OP78AIjFd 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sjapq9tjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:10:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KN9dw5047670;
        Mon, 20 May 2019 23:10:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sks1j464h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:10:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNAhkH011861;
        Mon, 20 May 2019 23:10:43 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:10:43 +0000
Date:   Mon, 20 May 2019 16:10:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] xfsprogs: more libxfs/ spring cleaning
Message-ID: <20190520231042.GJ5335@magnolia>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <20190520230311.GI5335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520230311.GI5335@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200141
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 04:03:11PM -0700, Darrick J. Wong wrote:
> On Thu, May 16, 2019 at 12:42:45PM -0500, Eric Sandeen wrote:
> > It wasn't super clear before - my goal here is to keep reducing
> > cosmetic differences between kernelspace & userspace libxfs/*
> > files and functions.
> > 
> > To that end, 3 more patches ... the first one may requires someone
> > who groks the libxfs_* API namespace picture (looking at you, Dave!)
> > 
> > (this abandons the "make new files" patches I sent before, at least
> > for now, I'll heed dave's advice to minimize moves...)
> 
> Er, can you turn on diffstat for each patch that gets sent?  That'll
> make it much easier for me to figure out if any of these patches have to
> go in the kernel first.
> 
> I /think/ the answer is 'no'....?

Yes, this is purely userspace stuff, no kernel patches required.

For the whole series (modulo everyone else's comments),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> --D
> 
> > Thanks,
> > -Eric
