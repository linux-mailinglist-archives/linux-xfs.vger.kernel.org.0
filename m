Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3279C1D8D15
	for <lists+linux-xfs@lfdr.de>; Tue, 19 May 2020 03:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgESBZs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 May 2020 21:25:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45316 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgESBZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 21:25:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J1LgxL132081;
        Tue, 19 May 2020 01:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=P6764u6XO5UoqWB4+MjtWp6QmEfPmF278f3WUR1B/bw=;
 b=pIej1RmC5sAQeQJ5pNlrEk4sAgfaP2eZa8CwZD1AoqscRfKJepl4ovSCsTTU10JYGqpk
 472MKJ1AjxVo3YykA/tcvJlE81HQrxZqWD5ss8Oyu8TXG8NCOKDNmlN0zd2bu9Bx0ywS
 CFSiFPOvQgXuyxb96I1OTz7x3Hys+3AMkeVHiDlTdarTNoI1uHxpcQUcTkf3wziz/X1b
 GvUCF/NV1KwuA35Kx3ekcoviHsXsb4utPsXgIf7rIayRDrInO5ndx6NISrYtJMCl+Nck
 J+9tnkUcdBF8gc0fVV8aSsPbtuQZe/shm/xUX/XWCB+JNu6WLvPtCY1bhqHAsiSHcacD 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284kt90a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 01:25:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J1ILS3011586;
        Tue, 19 May 2020 01:23:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 312t3wtc3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 01:23:41 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04J1Ne5l017938;
        Tue, 19 May 2020 01:23:40 GMT
Received: from localhost (/10.159.132.30)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 18:23:39 -0700
Date:   Mon, 18 May 2020 18:23:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: inode iterator cleanups
Message-ID: <20200519012337.GE17635@magnolia>
References: <20200518170437.1218883-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518170437.1218883-1-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=769 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=800
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 07:04:31PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up a bunch of lose ends in the inode iterator
> functions.

Funny, I was going to send a series next cycle that refactors a fair
amount of the incore inode iterators and then collapses the
free_cowblocks/free_eofblocks code into a single worker and radix tree
tag that takes care of all the speculative preallocation extent gc
stuff...

incore walks:
https://lore.kernel.org/linux-xfs/157784075463.1360343.1278255546758019580.stgit@magnolia/

reworking of the quota flushing:
https://lore.kernel.org/linux-xfs/157784083298.1361522.7064886067520069080.stgit@magnolia/

posteof/cowblocks consolidation:
https://lore.kernel.org/linux-xfs/157784087594.1361683.5987233633798863051.stgit@magnolia/

--D
